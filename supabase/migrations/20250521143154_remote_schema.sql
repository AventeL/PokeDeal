

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."create_exchange"("sender" "uuid", "receiver" "uuid", "sender_card_id" "text", "sender_card_variant" "text", "receiver_card_id" "text", "receiver_card_variant" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$declare
  exchange_id uuid;
begin
  -- Étape 1 : créer l'échange
  insert into exchanges (
    sender_id, receiver_id,
    sender_card_id, sender_card_variant,
    receiver_card_id, receiver_card_variant
  )
  values (
    sender, receiver,
    sender_card_id, sender_card_variant,
    receiver_card_id, receiver_card_variant
  )
  returning id into exchange_id;

  -- Étape 2 : créer la discussion liée
  insert into exchange_discussions (
    exchange_id
  )
  values (exchange_id);
end;$$;


ALTER FUNCTION "public"."create_exchange"("sender" "uuid", "receiver" "uuid", "sender_card_id" "text", "sender_card_variant" "text", "receiver_card_id" "text", "receiver_card_variant" "text") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."user_cards" (
    "id" bigint NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "quantity" numeric DEFAULT '0'::numeric NOT NULL,
    "variant" "text" DEFAULT 'normal'::"text" NOT NULL,
    "card_id" "text" NOT NULL,
    "set_id" "text" NOT NULL
);


ALTER TABLE "public"."user_cards" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."decrement_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") RETURNS "public"."user_cards"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user_id uuid := auth.uid();
  v_result user_cards;
  v_actual_quantity int;
begin
  select quantity into v_actual_quantity
  from user_cards
  where user_id = v_user_id and card_id = p_card_id and variant = p_variant;

  if v_actual_quantity is null then
    return null;
  end if;


  if p_quantity >= v_actual_quantity then
    RAISE NOTICE 'Quantité actuelle : %', v_actual_quantity;
    RAISE NOTICE 'user_id actuelle : %', v_user_id;
    RAISE NOTICE 'card_id actuelle : %', p_card_id;
    RAISE NOTICE 'variant actuelle : %', p_variant;
    RAISE NOTICE 'set_id actuelle : %', p_set_id;
    delete from user_cards
    where user_id = v_user_id and card_id = p_card_id and variant = p_variant and set_id = p_set_id;
    return null;

  else
    update user_cards
    set quantity = quantity - p_quantity
    where user_id = v_user_id and card_id = p_card_id and variant = p_variant;

    select * into v_result
    from user_cards
    where user_id = v_user_id and card_id = p_card_id and variant = p_variant;

    return v_result;
  end if;
end;
$$;


ALTER FUNCTION "public"."decrement_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."increment_or_insert_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") RETURNS "public"."user_cards"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  v_user_id uuid := auth.uid();
  v_result user_cards;
begin
  insert into public.user_cards (user_id, card_id, quantity, variant, set_id)
  values (v_user_id, p_card_id, p_quantity, p_variant, p_set_id)
  on conflict (user_id, card_id, variant)
  do update set quantity = user_cards.quantity + p_quantity;

  select * into v_result
  from user_cards
  where user_id = v_user_id and card_id = p_card_id and variant = p_variant;

  return v_result;
end;
$$;


ALTER FUNCTION "public"."increment_or_insert_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."perform_trade"("trade_uuid" "uuid", "sender_card" "jsonb", "receiver_card" "jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  auth_user uuid := auth.uid();

  sender_id uuid := (sender_card->>'user_id')::uuid;
  receiver_id uuid := (receiver_card->>'user_id')::uuid;

  set_id_from_sender text;
  set_id_from_receiver text;
begin
  -- 1. Vérification que l'utilisateur est connecté
  if auth_user is null then
    raise exception 'Non authentifié';
  end if;

  -- 2. Vérifie que l'utilisateur est bien impliqué dans l’échange
  if not exists (
    select 1 from exchanges
    where exchanges.id = trade_uuid
      and (exchanges.sender_id = auth_user or exchanges.receiver_id = auth_user)
  ) then
    raise exception 'Non autorisé à effectuer cet échange';
  end if;

  -- 3. Vérifie que chaque joueur possède bien la carte à échanger (quantity >= 1)
  if not exists (
    select 1 from user_cards
    where user_id = sender_id
      and card_id = sender_card->>'card_id'
      and variant = sender_card->>'variant'
      and quantity >= 1
  ) then
    raise exception 'Le sender ne possède pas la carte à échanger';
  end if;

  if not exists (
    select 1 from user_cards
    where user_id = receiver_id
      and card_id = receiver_card->>'card_id'
      and variant = receiver_card->>'variant'
      and quantity >= 1
  ) then
    raise exception 'Le receiver ne possède pas la carte à échanger';
  end if;

  -- 4. Récupération des set_id depuis les cartes données
  select set_id into set_id_from_sender
  from user_cards
  where user_id = sender_id
    and card_id = sender_card->>'card_id'
    and variant = sender_card->>'variant'
  limit 1;

  select set_id into set_id_from_receiver
  from user_cards
  where user_id = receiver_id
    and card_id = receiver_card->>'card_id'
    and variant = receiver_card->>'variant'
  limit 1;

  -- 5. Marquer l’échange comme accepté
  update exchanges
  set status = 'accepted'
  where exchanges.id = trade_uuid;

  -- 6. Décrémenter la quantité des cartes échangées
  update user_cards
  set quantity = quantity - 1
  where user_id = sender_id
    and card_id = sender_card->>'card_id'
    and variant = sender_card->>'variant';

  update user_cards
  set quantity = quantity - 1
  where user_id = receiver_id
    and card_id = receiver_card->>'card_id'
    and variant = receiver_card->>'variant';

  -- 7. Supprimer les cartes tombées à 0
  delete from user_cards
  where quantity <= 0;

  -- 8. Ajouter ou incrémenter la carte reçue par le receiver (du sender)
  insert into user_cards (user_id, card_id, variant, quantity, set_id)
  values (
    receiver_id,
    sender_card->>'card_id',
    sender_card->>'variant',
    1,
    set_id_from_sender
  )
  on conflict (user_id, card_id, variant)
  do update set quantity = user_cards.quantity + 1;

  -- 9. Ajouter ou incrémenter la carte reçue par le sender (du receiver)
  insert into user_cards (user_id, card_id, variant, quantity, set_id)
  values (
    sender_id,
    receiver_card->>'card_id',
    receiver_card->>'variant',
    1,
    set_id_from_receiver
  )
  on conflict (user_id, card_id, variant)
  do update set quantity = user_cards.quantity + 1;
end;
$$;


ALTER FUNCTION "public"."perform_trade"("trade_uuid" "uuid", "sender_card" "jsonb", "receiver_card" "jsonb") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_profiles" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "pseudo" "text" NOT NULL,
    "email" "text" NOT NULL
);


ALTER TABLE "public"."user_profiles" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sign_up_with_profile"("_email" "text", "_password" "text", "_pseudo" "text") RETURNS "public"."user_profiles"
    LANGUAGE "plpgsql"
    AS $$
declare
  _user_id uuid;
  _user user_profiles;
begin
  -- Démarrer la transaction
  begin
    -- Création de l'utilisateur avec auth.sign_up()
    select id from auth.Users into _user_id where Email=_email;

    if _user_id is null then
      raise exception 'Erreur lors de la création de l utilisateur';
    end if;

    -- Insérer le profil utilisateur dans user_profiles
    insert into user_profiles (id, email, pseudo, created_at)
    values (_user_id, _email, _pseudo, now())
    returning * into _user; -- On récupère tout le profil

    -- Commit si tout va bien
    return _user;
  exception
    when others then
      -- Rollback si erreur
      raise exception 'User creation failed: %', sqlerrm;
  end;
end;
$$;


ALTER FUNCTION "public"."sign_up_with_profile"("_email" "text", "_password" "text", "_pseudo" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_auth_user_email"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE auth.users
  SET email = NEW.email
  WHERE id = NEW.id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_auth_user_email"() OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exchange_discussions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "exchange_id" "uuid" DEFAULT "gen_random_uuid"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."exchange_discussions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exchange_messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "discussion_id" "uuid" DEFAULT "gen_random_uuid"(),
    "sender_id" "uuid" DEFAULT "gen_random_uuid"(),
    "content" "text",
    "send_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "type" bigint DEFAULT '1'::bigint
);


ALTER TABLE "public"."exchange_messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exchanges" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sender_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "receiver_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "status" "text" DEFAULT 'waiting'::"text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "sender_card_id" "text",
    "sender_card_variant" "text",
    "receiver_card_variant" "text",
    "receiver_card_id" "text"
);


ALTER TABLE "public"."exchanges" OWNER TO "postgres";


ALTER TABLE "public"."user_cards" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."user_cards_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."exchange_discussions"
    ADD CONSTRAINT "exchange_discussions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exchange_messages"
    ADD CONSTRAINT "exchange_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exchanges"
    ADD CONSTRAINT "exchanges_pkey" PRIMARY KEY ("id", "sender_id", "receiver_id");



ALTER TABLE ONLY "public"."user_cards"
    ADD CONSTRAINT "unique_user_card_variant" UNIQUE ("user_id", "card_id", "variant");



ALTER TABLE ONLY "public"."user_cards"
    ADD CONSTRAINT "user_cards_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "users_profil_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "trigger_update_auth_user_email" AFTER UPDATE OF "email" ON "public"."user_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_auth_user_email"();



ALTER TABLE ONLY "public"."exchange_messages"
    ADD CONSTRAINT "exchange_messages_discussion_id_fkey" FOREIGN KEY ("discussion_id") REFERENCES "public"."exchange_discussions"("id");



ALTER TABLE ONLY "public"."exchanges"
    ADD CONSTRAINT "exchanges_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."user_profiles"("id");



ALTER TABLE ONLY "public"."exchanges"
    ADD CONSTRAINT "exchanges_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."user_profiles"("id");



ALTER TABLE ONLY "public"."user_cards"
    ADD CONSTRAINT "user_cards_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_profiles"("id");



CREATE POLICY "Allow read access to all user_cards" ON "public"."user_cards" FOR SELECT USING (true);



CREATE POLICY "Allow user to delete their own cards" ON "public"."user_cards" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow user to insert their own cards" ON "public"."user_cards" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow user to read their own exchanges" ON "public"."exchanges" FOR SELECT USING ((("auth"."uid"() = "sender_id") OR ("auth"."uid"() = "receiver_id")));



CREATE POLICY "Allow user to update their own cards" ON "public"."user_cards" FOR UPDATE USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow user to update their own exchanges" ON "public"."exchanges" FOR UPDATE USING ((("auth"."uid"() = "sender_id") OR ("auth"."uid"() = "receiver_id")));



CREATE POLICY "Allow user to update their own profile" ON "public"."user_profiles" FOR UPDATE USING (("auth"."uid"() = "id"));



CREATE POLICY "Can create discussions linked to user's exchanges" ON "public"."exchange_discussions" FOR INSERT WITH CHECK (("exchange_id" IN ( SELECT "exchanges"."id"
   FROM "public"."exchanges"
  WHERE (("exchanges"."sender_id" = "auth"."uid"()) OR ("exchanges"."receiver_id" = "auth"."uid"())))));



CREATE POLICY "Enable insert for authenticated users only" ON "public"."exchange_discussions" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."exchange_messages" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."user_profiles" FOR INSERT WITH CHECK (true);



CREATE POLICY "Enable insert for users based on user_id" ON "public"."exchanges" FOR INSERT WITH CHECK (("sender_id" = "auth"."uid"()));



CREATE POLICY "Enable read access for all users" ON "public"."exchange_discussions" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."exchange_messages" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."user_profiles" FOR SELECT USING (true);



CREATE POLICY "allow user to read exchange" ON "public"."exchanges" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."exchange_discussions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."exchange_messages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."exchanges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_cards" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_profiles" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."exchange_messages";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."create_exchange"("sender" "uuid", "receiver" "uuid", "sender_card_id" "text", "sender_card_variant" "text", "receiver_card_id" "text", "receiver_card_variant" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_exchange"("sender" "uuid", "receiver" "uuid", "sender_card_id" "text", "sender_card_variant" "text", "receiver_card_id" "text", "receiver_card_variant" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_exchange"("sender" "uuid", "receiver" "uuid", "sender_card_id" "text", "sender_card_variant" "text", "receiver_card_id" "text", "receiver_card_variant" "text") TO "service_role";



GRANT ALL ON TABLE "public"."user_cards" TO "anon";
GRANT ALL ON TABLE "public"."user_cards" TO "authenticated";
GRANT ALL ON TABLE "public"."user_cards" TO "service_role";



GRANT ALL ON FUNCTION "public"."decrement_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."decrement_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."decrement_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."increment_or_insert_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."increment_or_insert_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."increment_or_insert_card"("p_card_id" "text", "p_quantity" integer, "p_variant" "text", "p_set_id" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."perform_trade"("trade_uuid" "uuid", "sender_card" "jsonb", "receiver_card" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."perform_trade"("trade_uuid" "uuid", "sender_card" "jsonb", "receiver_card" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."perform_trade"("trade_uuid" "uuid", "sender_card" "jsonb", "receiver_card" "jsonb") TO "service_role";



GRANT ALL ON TABLE "public"."user_profiles" TO "anon";
GRANT ALL ON TABLE "public"."user_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_profiles" TO "service_role";



GRANT ALL ON FUNCTION "public"."sign_up_with_profile"("_email" "text", "_password" "text", "_pseudo" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."sign_up_with_profile"("_email" "text", "_password" "text", "_pseudo" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."sign_up_with_profile"("_email" "text", "_password" "text", "_pseudo" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_auth_user_email"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_auth_user_email"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_auth_user_email"() TO "service_role";


















GRANT ALL ON TABLE "public"."exchange_discussions" TO "anon";
GRANT ALL ON TABLE "public"."exchange_discussions" TO "authenticated";
GRANT ALL ON TABLE "public"."exchange_discussions" TO "service_role";



GRANT ALL ON TABLE "public"."exchange_messages" TO "anon";
GRANT ALL ON TABLE "public"."exchange_messages" TO "authenticated";
GRANT ALL ON TABLE "public"."exchange_messages" TO "service_role";



GRANT ALL ON TABLE "public"."exchanges" TO "anon";
GRANT ALL ON TABLE "public"."exchanges" TO "authenticated";
GRANT ALL ON TABLE "public"."exchanges" TO "service_role";



GRANT ALL ON SEQUENCE "public"."user_cards_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."user_cards_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."user_cards_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;

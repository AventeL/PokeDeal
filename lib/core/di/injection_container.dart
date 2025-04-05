import 'package:get_it/get_it.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt getIt = GetIt.I;
final SupabaseClient supabaseClient = Supabase.instance.client;

Future<void> initInjectionDependencies() async {
  initExternal();
  initDataSource();
  initRepository();
  initBloc();
}

void initBloc() {
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(
      authenticationRepository: getIt<AuthenticationRepository>(),
    ),
  );
  getIt.registerFactory<CollectionPokemonBloc>(
    () => CollectionPokemonBloc(
      collectionPokemonRepository: getIt<CollectionPokemonRepository>(),
    ),
  );
}

void initRepository() {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      authenticationDataSource: getIt<IAuthenticationDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CollectionPokemonRepository>(
    () => CollectionPokemonRepository(
      collectionPokemonDataSource: getIt<ICollectionPokemonDataSource>(),
    ),
  );
}

void initDataSource() {
  getIt.registerLazySingleton<IAuthenticationDataSource>(
    () => AuthenticationDataSource(),
  );
  getIt.registerLazySingleton<ICollectionPokemonDataSource>(
    () => CollectionPokemonDataSource(),
  );
}

void initExternal() {}

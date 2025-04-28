import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/authentication/presentation/pages/authentication_gate.dart';
import 'package:pokedeal/features/authentication/presentation/pages/get_info_profile_page.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/pages/card_detail_page.dart';
import 'package:pokedeal/features/collection/presentation/pages/card_list_page.dart';
import 'package:pokedeal/features/collection/presentation/pages/set_details_page.dart';
import 'package:pokedeal/features/profile/presentation/pages/modify_profile_page.dart';
import 'package:pokedeal/features/profile/presentation/pages/profile_page.dart';
import 'package:pokedeal/features/profile/presentation/pages/settings_page.dart';

import '../../features/profile/presentation/pages/modify_password_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (context, state) => const AuthenticationGate(),
    ),
    GoRoute(
      path: '/authentication',
      name: 'authentication',
      builder: (context, state) {
        return const AuthenticationGate();
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
      path: '/get_info_profile',
      name: 'get_info_profile',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MaterialPage(
          child: GetMoreInfoProfilePage(
            email: extra?['email'] as String? ?? "",
            password: extra?['password'] as String? ?? "",
          ),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MaterialPage(
          child: ProfilePage(userId: extra?['userId'] as String?),
        );
      },
    ),
    GoRoute(
      path: '/set_details',
      name: 'set_details',
      builder: (context, state) {
        final PokemonSetBrief setInfo =
            (state.extra as Map<String, dynamic>)['setInfo'] as PokemonSetBrief;

        return SetDetailsPage(setInfo: setInfo);
      },
    ),
    GoRoute(
      path: '/card_details',
      name: 'card_details',
      builder: (context, state) {
        final String cardId =
            (state.extra as Map<String, dynamic>)['cardId'] as String;
        final PokemonCardBrief cardBrief =
            (state.extra as Map<String, dynamic>)['cardBrief']
                as PokemonCardBrief;
        final String userId =
            (state.extra as Map<String, dynamic>)['userId'] as String;
        return CardDetailPage(
          cardId: cardId,
          cardBrief: cardBrief,
          userId: userId,
        );
      },
    ),
    GoRoute(
      path: '/card_list',
      name: 'card_list',
      builder: (context, state) {
        final List<PokemonCardBrief> cards =
            (state.extra as Map<String, dynamic>)['cards']
                as List<PokemonCardBrief>;
        final List<UserCardCollection> userCardsCollection =
            (state.extra as Map<String, dynamic>)['userCardsCollection']
                as List<UserCardCollection>;
        final String userId =
            (state.extra as Map<String, dynamic>)['userId'] as String;
        final String setName =
            (state.extra as Map<String, dynamic>)['setName'] as String;
        return CardListPage(
          userId: userId,
          cards: cards,
          userCardsCollection: userCardsCollection,
          setName: setName,
        );
      },
    ),
    GoRoute(
      path: '/modify_profil',
      name: 'modify_profil',
      builder: (context, state) {
        return const ModifyProfilePage();
      },
    ),
    GoRoute(
      path: '/modify_password',
      name: 'modify_password',
      builder: (context, state) {
        return const ModifyPasswordPage();
      },
    ),
  ],
);

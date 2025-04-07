import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/authentication/presentation/pages/authentication_gate.dart';
import 'package:pokedeal/features/authentication/presentation/pages/get_info_profile_page.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/pages/set_details_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (context, state) => const AuthenticationGate(),
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
      path: '/set_details',
      name: 'set_details',
      builder: (context, state) {
        final PokemonSetBrief setInfo = state.extra as PokemonSetBrief;
        return SetDetailsPage(setInfo: setInfo);
      },
    ),
  ],
);

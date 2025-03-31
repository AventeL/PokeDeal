import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/authentication/presentation/pages/authentication_gate.dart';
import 'package:pokedeal/features/authentication/presentation/pages/get_info_profile_page.dart';

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
  ],
);

import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/Authentication/presentation/pages/authentication_gate.dart';
import 'package:pokedeal/features/home/presentation/pages/home_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (context, state) => const AuthenticationGate(),
    ),
    GoRoute(
      path: '/home',
      name: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

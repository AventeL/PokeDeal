import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/Authentication/presentation/pages/authentication_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (context, state) => const AuthenticationPage(),
    ),
  ],
);

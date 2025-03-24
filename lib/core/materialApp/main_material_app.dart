import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/routes/router.dart';
import 'package:pokedeal/features/Authentication/presentation/bloc/authentication_bloc.dart';

class MainMaterialApp extends StatelessWidget {
  const MainMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => getIt<AuthenticationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'PokeDeal',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

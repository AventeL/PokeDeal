import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/routes/router.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';
import 'package:pokedeal/theme/custom_theme.dart';

class MainMaterialApp extends StatelessWidget {
  const MainMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => getIt<AuthenticationBloc>(),
        ),
        BlocProvider<CollectionPokemonBloc>(
          create:
              (context) =>
                  getIt<CollectionPokemonBloc>()
                    ..add(CollectionPokemonGetSeriesEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'PokeDeal',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}

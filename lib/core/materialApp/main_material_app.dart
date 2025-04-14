import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/routes/router.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/theme/custom_theme.dart';

import '../../features/trade/presentation/bloc/trade_bloc.dart';

class MainMaterialApp extends StatelessWidget {
  const MainMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => getIt<AuthenticationBloc>(),
        ),
        BlocProvider<CollectionPokemonSerieBloc>(
          create:
              (context) =>
                  getIt<CollectionPokemonSerieBloc>()
                    ..add(CollectionPokemonGetSeriesEvent()),
        ),
        BlocProvider<CollectionPokemonSetBloc>(
          create: (context) => getIt<CollectionPokemonSetBloc>(),
        ),
        BlocProvider<CollectionPokemonCardBloc>(
          create: (context) => getIt<CollectionPokemonCardBloc>(),
        ),
        BlocProvider<TradeBloc>(create: (context) => getIt<TradeBloc>()),
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

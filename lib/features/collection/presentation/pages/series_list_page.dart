import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_serie_card.dart';

class SeriesListPage extends StatelessWidget {
  const SeriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CollectionPokemonSerieBloc,
      CollectionPokemonSerieState
    >(
      listener: (context, state) {
        if (state is CollectionPokemonSerieError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CollectionPokemonSerieLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CollectionPokemonSerieError) {
          return Center(child: Text(state.message));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text(
                'Ma Collection',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: getIt<CollectionPokemonRepository>().series.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PokemonSerieCard(
                        pokemonSerie:
                            getIt<CollectionPokemonRepository>().series[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

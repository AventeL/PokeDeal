import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_serie_card.dart';

class SeriesListPage extends StatelessWidget {
  const SeriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionPokemonBloc, CollectionPokemonState>(
      listener: (context, state) {
        if (state is CollectionPokemonError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CollectionPokemonLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CollectionPokemonSeriesGet) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                8.height,
                Center(
                  child: Text(
                    'Liste des séries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.series.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PokemonSerieCard(name: state.series[index].name),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('No series available'));
      },
    );
  }
}

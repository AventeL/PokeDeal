import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_serie_card.dart';

class UserCollectionWidget extends StatefulWidget {
  final String? userId;

  const UserCollectionWidget({super.key, this.userId});

  @override
  State<UserCollectionWidget> createState() => _UserCollectionWidgetState();
}

class _UserCollectionWidgetState extends State<UserCollectionWidget> {
  List<UserCardCollection> cards = [];
  List<PokemonSet> sets = [];
  List<PokemonSerie> series = [];
  List<BasePokemonCard> listOfCards = [];

  @override
  void initState() {
    super.initState();
    loadCollection();
  }

  @override
  void didUpdateWidget(covariant UserCollectionWidget oldWidget) {
    loadCollection();
    super.didUpdateWidget(oldWidget);
  }

  void loadCollection() {
    BlocProvider.of<UserCollectionBloc>(context).add(
      UserCollectionLoadAllEvent(
        userId:
            widget.userId == null
                ? getIt<AuthenticationRepository>().userProfile!.id
                : widget.userId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCollectionList();
  }

  Widget _buildCollectionList() {
    return BlocConsumer<UserCollectionBloc, UserCollectionState>(
      listener: (context, state) {
        if (state is UserCollectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is UserCollectionAllLoaded) {
          cards = state.userCardsCollection;
          sets = state.setsCollection;
          series = state.seriesCollection;
          listOfCards = state.listOfCards;
        }
      },
      builder: (context, state) {
        if (state is UserCollectionLoading) {
          return Center(child: LinearProgressIndicator());
        }

        if (state is UserCollectionError) {
          return Center(child: Text(state.message));
        }

        if (cards.isEmpty) {
          return Center(child: Text('Aucune carte trouvée'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: PokemonSerieCard(
                pokemonSerie: series[index],
                sets:
                    sets
                        .where((set) => set.serieBrief.id == series[index].id)
                        .map((set) => set.toBrief())
                        .toList(),
                onSetTap: (PokemonSetBrief set) {
                  context.push(
                    '/card_list',
                    extra: {
                      'setName': set.name,
                      'userId': widget.userId,
                      'cards':
                          listOfCards
                              .where((card) => card.setBrief.id == set.id)
                              .toList()
                              .map((card) => card.toBrief())
                              .toList(),
                      'userCardsCollection': cards,
                    },
                  );
                },
              ),
            );
          },
          itemCount: series.length,
        );
      },
    );
  }
}

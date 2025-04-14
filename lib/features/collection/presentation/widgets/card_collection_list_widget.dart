import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';

class CardCollectionListWidget extends StatefulWidget {
  final String userId;
  final String? cardId;

  const CardCollectionListWidget({
    super.key,
    required this.userId,
    required this.cardId,
  });

  @override
  State<CardCollectionListWidget> createState() =>
      _CardCollectionListWidgetState();
}

class _CardCollectionListWidgetState extends State<CardCollectionListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<UserCollectionBloc>().add(
      UserCollectionLoadEvent(userId: widget.userId, cardId: widget.cardId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCollectionBloc, UserCollectionState>(
      listener: (context, state) {
        if (state is UserCollectionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
        if (state is UserCollectionStateCardAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carte ajoutée à la collection')),
          );
        }
      },
      builder: (context, state) {
        if (state is UserCollectionLoading) {
          return const Center(child: LinearProgressIndicator());
        }

        if (state is UserCollectionError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is UserCollectionLoaded) {
          if (state.userCardsCollection.isEmpty) {
            return const Center(
              child: Text('Aucune carte dans votre collection'),
            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: state.userCardsCollection.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final card = state.userCardsCollection[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.tertiaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card.variant.getFullName),
                        Text(card.quantity.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Aucune carte dans votre collection'));
      },
    );
  }
}

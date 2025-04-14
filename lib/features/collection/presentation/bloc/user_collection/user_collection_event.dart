part of 'user_collection_bloc.dart';

class UserCollectionEvent {}

class UserCollectionLoadEvent extends UserCollectionEvent {
  String userId;
  String? cardId;
  String? setId;

  UserCollectionLoadEvent({required this.userId, this.cardId, this.setId});
}

class UserCollectionAddCardEvent extends UserCollectionEvent {
  String pokemonCardId;
  int quantity;
  VariantValue variant;
  String setId;

  UserCollectionAddCardEvent({
    required this.pokemonCardId,
    required this.quantity,
    required this.variant,
    required this.setId,
  });
}

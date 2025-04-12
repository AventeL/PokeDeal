part of 'user_collection_bloc.dart';

class UserCollectionEvent {}

class UserCollectionLoadEvent extends UserCollectionEvent {
  String userId;

  UserCollectionLoadEvent({required this.userId});
}

class UserCollectionAddCardEvent extends UserCollectionEvent {
  String pokemonCardId;
  int quantity;

  UserCollectionAddCardEvent({
    required this.pokemonCardId,
    required this.quantity,
  });
}

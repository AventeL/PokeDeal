part of 'user_collection_bloc.dart';

class UserCollectionEvent {}

class UserCollectionLoadSetEvent extends UserCollectionEvent {
  String userId;
  String setId;

  UserCollectionLoadSetEvent({required this.userId, required this.setId});
}

class UserCollectionLoadCardEvent extends UserCollectionEvent {
  String userId;
  String cardId;

  UserCollectionLoadCardEvent({required this.userId, required this.cardId});
}

class UserCollectionAddCardEvent extends UserCollectionEvent {
  String pokemonCardId;
  int quantity;
  VariantValue variant;
  String setId;
  bool needRefresh;

  UserCollectionAddCardEvent({
    required this.pokemonCardId,
    required this.quantity,
    required this.variant,
    required this.setId,
    this.needRefresh = true,
  });
}

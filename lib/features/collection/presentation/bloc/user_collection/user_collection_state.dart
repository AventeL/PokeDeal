part of 'user_collection_bloc.dart';

class UserCollectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class UserCollectionInitial extends UserCollectionState {}

final class UserCollectionLoading extends UserCollectionState {}

final class UserCollectionError extends UserCollectionState {
  final String message;

  UserCollectionError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UserCollectionLoaded extends UserCollectionState {
  final List<UserCardCollection> userCardsCollection;

  UserCollectionLoaded({required this.userCardsCollection});

  @override
  List<Object?> get props => [userCardsCollection];
}

final class UserCollectionStateCardAdded extends UserCollectionState {}

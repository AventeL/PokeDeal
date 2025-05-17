part of 'discussion_bloc.dart';

class DiscussionState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DiscussionInitial extends DiscussionState {}

final class DiscussionStateLoading extends DiscussionState {}

final class DiscussionStateLoadingMessage extends DiscussionState {}

final class DiscussionStateError extends DiscussionState {
  final String message;

  DiscussionStateError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DiscussionStateDiscussionGet extends DiscussionState {
  final Discussion discussion;

  DiscussionStateDiscussionGet({required this.discussion});

  @override
  List<Object?> get props => [discussion];
}

final class DiscussionStateMessageSent extends DiscussionState {
  final Message message;

  DiscussionStateMessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

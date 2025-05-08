import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/discussion/domain/model/Discussion.dart';
import 'package:pokedeal/features/discussion/domain/repository/discussion_repository.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository discussionRepository;

  DiscussionBloc({required this.discussionRepository})
    : super(DiscussionInitial()) {
    on<DiscussionEventGetDiscussionByTradeId>(onDiscussionGetByTradeId);
  }

  Future<void> onDiscussionGetByTradeId(
    DiscussionEventGetDiscussionByTradeId event,
    Emitter<DiscussionState> emit,
  ) async {
    emit(DiscussionStateLoading());
    try {
      final Discussion discussion = await discussionRepository
          .getDiscussionByTradeId(event.tradeId);
      emit(DiscussionStateDiscussionGet(discussion: discussion));
    } catch (e) {
      emit(DiscussionStateError(message: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/userStats.dart';
import '../../domain/repository/trade_repository.dart';

part 'trade_event.dart';
part 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final TradeRepository tradeRepository;

  TradeBloc({required this.tradeRepository}) : super(TradeStateInitial()) {
    on<TradeEventGetAllUsers>(_onTradeEventGetAllUsers);
  }

  Future<void> _onTradeEventGetAllUsers(
    TradeEventGetAllUsers event,
    Emitter<TradeState> emit,
  ) async {
    try {
      emit(TradeStateSuccessGetAllUsers());
      final users = tradeRepository.getAllUser();
      emit(TradeStateUsersLoaded(users: await users));
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }
}

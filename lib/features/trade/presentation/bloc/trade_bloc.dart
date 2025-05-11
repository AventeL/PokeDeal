import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';

import '../../domain/models/trade.dart';
import '../../domain/models/user_stats.dart';
import '../../domain/repository/trade_repository.dart';

part 'trade_event.dart';
part 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final TradeRepository tradeRepository;

  TradeBloc({required this.tradeRepository}) : super(TradeStateInitial()) {
    on<TradeEventGetAllUsers>(_onTradeEventGetAllUsers);
    on<TradeEventGetSendTrade>(_onTradeEventGetSendTrade);
    on<TradeEventGetReceivedTrade>(_onTradeEventGetReceivedTrade);
    on<TradeEventAskTrade>(_onTradeEventAskTrade);
    on<TradeEventAcceptTrade>(_onTradeEventAcceptTrade);
    on<TradeEventRefuseTrade>(_onTradeEventRefuseTrade);
  }

  Future<void> _onTradeEventGetAllUsers(
    TradeEventGetAllUsers event,
    Emitter<TradeState> emit,
  ) async {
    try {
      emit(TradeStateSuccessGetAllUsers());
      final users = await tradeRepository.getAllUser();
      emit(TradeStateUsersLoaded(users: users));
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }

  Future<void> _onTradeEventGetSendTrade(
    TradeEventGetSendTrade event,
    Emitter<TradeState> emit,
  ) async {
    try {
      final trades = await tradeRepository.getSendTrade();
      emit(TradeStateSendTradesLoaded(trades: trades));
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }

  Future<void> _onTradeEventGetReceivedTrade(
    TradeEventGetReceivedTrade event,
    Emitter<TradeState> emit,
  ) async {
    try {
      final trades = await tradeRepository.getReceivedTrade();
      emit(TradeStateReceivedTradesLoaded(trades: trades));
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }

  Future<void> _onTradeEventAskTrade(
    TradeEventAskTrade event,
    Emitter<TradeState> emit,
  ) async {
    try {
      emit(TradeStateLoading());
      await tradeRepository.askTrade(
        myTradeRequestData: event.myTradeRequestData,
        otherTradeRequestData: event.otherTradeRequestData,
      );
      emit(TradeStateAskTradeSuccess());
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }

  Future<void> _onTradeEventAcceptTrade(
    TradeEventAcceptTrade event,
    Emitter<TradeState> emit,
  ) async {
    try {
      emit(TradeStateLoading());
      await tradeRepository.acceptTrade(tradeId: event.tradeId);
      emit(TradeStateAcceptTradeSuccess());
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }

  Future<void> _onTradeEventRefuseTrade(
    TradeEventRefuseTrade event,
    Emitter<TradeState> emit,
  ) async {
    try {
      emit(TradeStateLoading());
      await tradeRepository.refuseTrade(tradeId: event.tradeId);
      emit(TradeStateRefuseTradeSuccess());
    } catch (e) {
      emit(TradeStateError(message: e.toString(), timestamp: DateTime.now()));
    }
  }
}

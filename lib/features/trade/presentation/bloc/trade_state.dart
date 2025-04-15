part of 'trade_bloc.dart';

class TradeState extends Equatable {
  @override
  List<Object> get props => [];
}

final class TradeStateInitial extends TradeState {}

final class TradeStateSuccessGetAllUsers extends TradeState {}

final class TradeStateUsersLoaded extends TradeState {
  final List<Userstats> users;

  TradeStateUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

final class TradeStateError extends TradeState {
  final String message;
  final DateTime timestamp;

  TradeStateError({required this.message, required this.timestamp});

  @override
  List<Object> get props => [message, timestamp];
}

final class TradeStateSendTradesLoaded extends TradeState {
  final List<Trade> trades;

  TradeStateSendTradesLoaded({required this.trades});

  @override
  List<Object> get props => [trades];
}

final class TradeStateReceivedTradesLoaded extends TradeState {
  final List<Trade> trades;

  TradeStateReceivedTradesLoaded({required this.trades});

  @override
  List<Object> get props => [trades];
}

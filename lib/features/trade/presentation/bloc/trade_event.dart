part of 'trade_bloc.dart';

class TradeEvent {}

final class TradeEventGetAllUsers extends TradeEvent {}

final class TradeEventGetSendTrade extends TradeEvent {}

final class TradeEventGetReceivedTrade extends TradeEvent {}

final class TradeEventAskTrade extends TradeEvent {
  final TradeRequestData myTradeRequestData;
  final TradeRequestData otherTradeRequestData;

  TradeEventAskTrade({
    required this.myTradeRequestData,
    required this.otherTradeRequestData,
  });
}

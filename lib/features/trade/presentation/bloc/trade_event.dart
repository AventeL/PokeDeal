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

final class TradeEventAcceptTrade extends TradeEvent {
  final Trade trade;

  TradeEventAcceptTrade({required this.trade});
}

final class TradeEventRefuseTrade extends TradeEvent {
  final String tradeId;

  TradeEventRefuseTrade({required this.tradeId});
}

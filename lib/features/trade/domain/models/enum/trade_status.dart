enum TradeStatus { waiting, refused, accepted }

extension TradeStatusExtension on TradeStatus {
  static TradeStatus fromString(String status) {
    switch (status) {
      case 'accepted':
        return TradeStatus.accepted;
      case 'refused':
        return TradeStatus.refused;
      case 'waiting':
        return TradeStatus.waiting;
      default:
        throw ArgumentError('Status invalide: $status');
    }
  }
}

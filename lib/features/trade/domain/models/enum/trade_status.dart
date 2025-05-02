enum TradeStatus { waiting, refused, accepted }

extension TradeStatusExtension on TradeStatus {
  static TradeStatus fromString(String status) {
    switch (status) {
      case 'Accepté':
        return TradeStatus.accepted;
      case 'Refusé':
        return TradeStatus.refused;
      case 'En attente':
        return TradeStatus.waiting;
      default:
        throw ArgumentError('Status invalide: $status');
    }
  }
}

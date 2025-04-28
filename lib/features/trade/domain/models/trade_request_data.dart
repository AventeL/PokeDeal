import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

class TradeRequestData extends Equatable {
  final String userId;
  final String? cardId;
  final VariantValue? variantValue;

  const TradeRequestData({
    required this.userId,
    this.cardId,
    this.variantValue,
  });

  @override
  List<Object?> get props => [userId, cardId, variantValue];
}

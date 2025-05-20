import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

class UserCardCollection extends Equatable {
  final String id;
  final String userId;
  final int quantity;
  final String cardId;
  final String setId;
  final VariantValue variant;

  const UserCardCollection({
    required this.id,
    required this.userId,
    required this.quantity,
    required this.cardId,
    required this.variant,
    required this.setId,
  });

  UserCardCollection copyWith({
    String? id,
    String? userId,
    int? quantity,
    String? cardId,
    String? setId,
    VariantValue? variant,
  }) {
    return UserCardCollection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      cardId: cardId ?? this.cardId,
      variant: variant ?? this.variant,
      setId: setId ?? this.setId,
    );
  }

  factory UserCardCollection.fromJson(Map<String, dynamic> json) {
    return UserCardCollection(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      quantity: json['quantity'] as int,
      cardId: json['card_id'].toString(),
      variant: VariantValueExtension.fromJson(json['variant']),
      setId: json['set_id'].toString(),
    );
  }

  @override
  List<Object?> get props => [id, userId, quantity, variant, cardId, setId];
}

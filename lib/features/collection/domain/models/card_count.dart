import 'package:equatable/equatable.dart';

class CardCount extends Equatable {
  final int total;
  final int official;
  final int? firstEd;
  final int? holo;
  final int? reverse;
  final int? normal;

  const CardCount({
    required this.total,
    required this.official,
    this.firstEd,
    this.holo,
    this.reverse,
    this.normal,
  });

  factory CardCount.fromJson(Map<String, dynamic> json) {
    return CardCount(
      total: json['total'] ?? 0,
      official: json['official'] ?? 0,
      firstEd: json['first_edition'],
      holo: json['holo'],
      reverse: json['reverse'],
      normal: json['normal'],
    );
  }

  @override
  List<Object?> get props => [total, official, firstEd, holo, reverse, normal];
}

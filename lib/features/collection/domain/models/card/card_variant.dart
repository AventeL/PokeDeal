class CardVariant {
  final bool firstEdition;
  final bool holo;
  final bool reverse;
  final bool promo;
  final bool normal;

  const CardVariant({
    required this.firstEdition,
    required this.holo,
    required this.reverse,
    required this.promo,
    required this.normal,
  });

  factory CardVariant.fromJson(Map<String, dynamic> json) {
    return CardVariant(
      firstEdition: json['firstEdition'],
      holo: json['holo'],
      reverse: json['reverse'],
      promo: json['promo'],
      normal: json['normal'],
    );
  }
}

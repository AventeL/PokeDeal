import 'package:equatable/equatable.dart';

class Legal extends Equatable {
  final bool expanded;
  final bool standard;

  const Legal({required this.expanded, required this.standard});

  factory Legal.fromJson(Map<String, dynamic> json) {
    return Legal(
      expanded: json['expanded'] ?? false,
      standard: json['standard'] ?? false,
    );
  }

  @override
  List<Object?> get props => [expanded, standard];
}

import 'package:equatable/equatable.dart';

class Discussion extends Equatable {
  final String id;

  const Discussion({required this.id});

  @override
  List<Object?> get props => [id];
}

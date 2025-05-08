import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;

  const Message({required this.id});

  @override
  List<Object?> get props => [id];
}

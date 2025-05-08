import 'package:flutter/material.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 50, color: Colors.red);
  }
}

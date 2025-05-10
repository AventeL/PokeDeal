import 'package:flutter/material.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final Widget? child;

  const MessageWidget({super.key, required this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            message.senderId ==
                    getIt<AuthenticationRepository>().userProfile?.id
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child ?? Text(message.content),
    );
  }
}

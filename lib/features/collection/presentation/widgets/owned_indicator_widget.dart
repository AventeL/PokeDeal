import 'package:flutter/material.dart';

class OwnedIndicatorWidget extends StatelessWidget {
  const OwnedIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Icon(
        Icons.check_circle_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

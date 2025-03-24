import 'package:flutter/material.dart';

class CustomLargeButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;

  const CustomLargeButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

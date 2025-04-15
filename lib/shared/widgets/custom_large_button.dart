import 'package:flutter/material.dart';

class CustomLargeButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final Color? bgColor;
  final Color? textColor;

  const CustomLargeButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}

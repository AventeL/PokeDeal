import 'package:flutter/material.dart';

class CustomLargeButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final bool isActive;

  const CustomLargeButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.textColor,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? () => onPressed() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActive
                  ? bgColor ?? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
          foregroundColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BaseTradeMenuButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onTap;

  const BaseTradeMenuButton({
    super.key,
    required this.text,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

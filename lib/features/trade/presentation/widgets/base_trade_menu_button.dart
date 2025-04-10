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
    BorderRadius borderRadius = BorderRadius.circular(20);

    return Expanded(
      child: Material(
        color:
            isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).disabledColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

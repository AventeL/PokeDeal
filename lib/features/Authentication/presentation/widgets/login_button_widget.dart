import 'package:flutter/material.dart';

class LoginButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  final String label;

  const LoginButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

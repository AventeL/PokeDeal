import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Echanges',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Collection'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      selectedItemColor: Theme.of(context).colorScheme.primary,
    );
  }
}

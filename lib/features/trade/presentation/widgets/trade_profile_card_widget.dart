import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';

class TradeProfileCardWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const TradeProfileCardWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(8);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: borderRadius,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cocorico',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('25 cartes, 3 échanges'),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}

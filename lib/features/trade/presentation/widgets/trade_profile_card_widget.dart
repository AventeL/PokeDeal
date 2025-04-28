import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

class TradeProfileCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final UserStats userProfile;

  const TradeProfileCardWidget({
    super.key,
    required this.userProfile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(8);

    return Material(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: borderRadius),
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
                      userProfile.user.pseudo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${userProfile.nbCards} cartes, ${userProfile.nbExchanges} échanges',
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

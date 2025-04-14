import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

import '../bloc/trade_bloc.dart';

class TradeSearchPage extends StatefulWidget {
  const TradeSearchPage({super.key});

  @override
  State<TradeSearchPage> createState() => _TradeSearchPageState();
}

class _TradeSearchPageState extends State<TradeSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Rechercher un collectionneur',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          4.height,
          Expanded(
            child: BlocBuilder<TradeBloc, TradeState>(
              builder: (context, state) {
                if (state is TradeStateUsersLoaded) {
                  final users = state.users;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TradeProfileCardWidget(userProfile: user),
                      );
                    },
                  );
                } else if (state is TradeStateError) {
                  return Center(child: Text('Erreur : ${state.message}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

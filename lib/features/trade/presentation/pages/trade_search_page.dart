import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

import '../../domain/models/user_stats.dart';
import '../bloc/trade_bloc.dart';

class TradeSearchPage extends StatefulWidget {
  const TradeSearchPage({super.key});

  @override
  State<TradeSearchPage> createState() => _TradeSearchPageState();
}

class _TradeSearchPageState extends State<TradeSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserStats> _filteredUsers = [];
  List<UserStats> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers =
          _allUsers.where((user) {
            return user.user.pseudo.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher un collectionneur',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          4.height,
          Expanded(
            child: BlocConsumer<TradeBloc, TradeState>(
              listener: (context, state) {
                if (state is TradeStateUsersLoaded) {
                  _allUsers = state.users;
                  _filterUsers();
                }
              },
              builder: (context, state) {
                if (state is TradeStateError) {
                  return Center(child: Text('Erreur : ${state.message}'));
                }
                if (state is TradeStateLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TradeProfileCardWidget(
                        userProfile: user,
                        onTap: () => onProfileTap(user.user.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onProfileTap(String id) {
    context.push('/profile', extra: {'userId': id});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_request_list_page.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_search_page.dart';
import 'package:pokedeal/features/trade/presentation/widgets/base_trade_menu_button.dart';

import '../bloc/trade_bloc.dart';

class TradeBasePage extends StatefulWidget {
  const TradeBasePage({super.key});

  @override
  State<TradeBasePage> createState() => _TradeBasePageState();
}

class _TradeBasePageState extends State<TradeBasePage>
    with SingleTickerProviderStateMixin {
  TradeMenu selectedMenu = TradeMenu.search;

  @override
  void initState() {
    super.initState();
    context.read<TradeBloc>().add(TradeEventGetAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          Text(
            'Echanges',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseTradeMenuButton(
                text: 'Rechercher',
                isSelected: selectedMenu == TradeMenu.search,
                onTap: () {
                  context.read<TradeBloc>().add(TradeEventGetAllUsers());
                  setState(() {
                    selectedMenu = TradeMenu.search;
                  });
                },
              ),
              8.width,
              BaseTradeMenuButton(
                text: 'Demandes',
                isSelected: selectedMenu == TradeMenu.requests,
                onTap: () {
                  setState(() {
                    selectedMenu = TradeMenu.requests;
                  });
                },
              ),
            ],
          ),
          32.height,
          _buildPageFromMenuValue(),
        ],
      ),
    );
  }

  Widget _buildPageFromMenuValue() {
    return selectedMenu == TradeMenu.search
        ? const TradeSearchPage()
        : const TradeRequestListPage();
  }
}

enum TradeMenu { search, requests }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_list_widget.dart';

import '../bloc/trade_bloc.dart';

class TradeRequestListPage extends StatefulWidget {
  const TradeRequestListPage({super.key});

  @override
  State<TradeRequestListPage> createState() => _TradeRequestListPageState();
}

class _TradeRequestListPageState extends State<TradeRequestListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<TradeBloc>().add(TradeEventGetReceivedTrade());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [Tab(text: 'Reçues'), Tab(text: 'Envoyées')],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                TradeListWidget(tabIndex: 0),
                TradeListWidget(tabIndex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

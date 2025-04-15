import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_list_widget.dart';

import '../bloc/trade_bloc.dart';

class TradeRequestPage extends StatefulWidget {
  const TradeRequestPage({super.key});

  @override
  State<TradeRequestPage> createState() => _TradeRequestPageState();
}

class _TradeRequestPageState extends State<TradeRequestPage>
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
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [Tab(text: 'Reçues'), Tab(text: 'Envoyées')],
          ),
          Expanded(
            child: TabBarView(
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

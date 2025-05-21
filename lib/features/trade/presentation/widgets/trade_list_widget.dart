import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_card_widget.dart';

import '../bloc/trade_bloc.dart';

class TradeListWidget extends StatefulWidget {
  final int tabIndex;

  const TradeListWidget({super.key, required this.tabIndex});

  @override
  State<TradeListWidget> createState() => _TradeListWidgetState();
}

class _TradeListWidgetState extends State<TradeListWidget> {
  @override
  void initState() {
    super.initState();
    loadTrades();
  }

  void loadTrades() {
    if (widget.tabIndex == 0) {
      context.read<TradeBloc>().add(TradeEventGetReceivedTrade());
    } else {
      context.read<TradeBloc>().add(TradeEventGetSendTrade());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTradeList();
  }

  Widget _buildTradeList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: BlocConsumer<TradeBloc, TradeState>(
        listener: (context, state) {
          if (state is TradeStateAcceptTradeSuccess ||
              state is TradeStateRefuseTradeSuccess) {
            loadTrades();
          }
        },
        builder: (context, state) {
          if (state is TradeStateLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          if (state is TradeStateReceivedTradesLoaded ||
              state is TradeStateSendTradesLoaded) {
            final trade =
                state is TradeStateReceivedTradesLoaded
                    ? state.trades
                    : (state as TradeStateSendTradesLoaded).trades;

            if (trade.isEmpty) {
              return Center(
                child: Text(
                  'Aucun échange trouvé',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: trade.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TradeCardRequestWidget(
                    isTradeReceived:
                        state is TradeStateReceivedTradesLoaded ? true : false,
                    onTap: () => onTradeCardWidgetTap(trade[index]),
                    trade: trade[index],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Aucun échange trouvé',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }

  void onTradeCardWidgetTap(Trade trade) {
    context.push('/discussion', extra: {'trade': trade});
  }
}

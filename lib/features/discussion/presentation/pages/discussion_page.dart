import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/discussion/domain/model/Discussion.dart';
import 'package:pokedeal/features/discussion/presentation/bloc/discussion_bloc.dart';

class DiscussionPage extends StatefulWidget {
  final String tradeId;

  const DiscussionPage({super.key, required this.tradeId});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late Discussion discussion;

  @override
  @override
  void initState() {
    context.read<DiscussionBloc>().add(
      DiscussionEventGetDiscussionByTradeId(tradeId: widget.tradeId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Discussion Page')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/presentation/bloc/discussion_bloc.dart';

class DiscussionPage extends StatefulWidget {
  final String tradeId;

  const DiscussionPage({super.key, required this.tradeId});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Discussion? discussion;
  final TextEditingController messageController = TextEditingController();
  final String senderId = getIt<AuthenticationRepository>().userProfile!.id;
  bool hasSubscribedToMessages = false;
  bool isMessageLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<DiscussionBloc>().add(
      DiscussionEventGetDiscussionByTradeId(tradeId: widget.tradeId),
    );
  }

  @override
  void dispose() {
    getIt<DiscussionBloc>().add(DiscussionEventUnsubscribeFromMessages());
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<DiscussionBloc, DiscussionState>(
          listener: (context, state) {
            isMessageLoading = state is DiscussionStateLoadingMessage;

            if (state is DiscussionStateError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is DiscussionStateDiscussionGet ||
                state is DiscussionStateMessageSent) {
              discussion =
                  state is DiscussionStateDiscussionGet
                      ? state.discussion
                      : discussion;
              if (!hasSubscribedToMessages) {
                context.read<DiscussionBloc>().add(
                  DiscussionEventSubscribeToMessages(
                    discussionId: discussion!.id,
                  ),
                );
                hasSubscribedToMessages = true;
              }
            }
          },
          builder: (context, state) {
            if (state is DiscussionStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DiscussionStateDiscussionGet ||
                state is DiscussionStateLoadingMessage) {
              return buildBody(discussion);
            }

            return const Center(child: Text('Aucune discussion.'));
          },
        ),
      ),
    );
  }

  Widget buildBody(Discussion? discussion) {
    if (discussion == null) {
      return const Center(child: Text('Aucune discussion trouvée.'));
    }

    final messages = discussion.messages;

    return Column(
      children: [
        Expanded(
          child:
              messages.isEmpty
                  ? const Center(child: Text('Aucun message.'))
                  : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.senderId == senderId;

                      return Column(
                        children: [
                          Align(
                            alignment:
                                isMine
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    isMine
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(message.content),
                            ),
                          ),
                          if (isMessageLoading &&
                              message.id == messages.first.id)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: Colors.black.withValues(alpha: 0.5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Écrire un message...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final content = messageController.text.trim();
    if (content.isEmpty || discussion == null) return;

    context.read<DiscussionBloc>().add(
      DiscussionEventSendMessage(
        message: Message(
          id: '',
          discussionId: discussion!.id,
          senderId: senderId,
          content: content,
          sendAt: DateTime.now(),
          type: MessageType.normal,
        ),
      ),
    );

    messageController.clear();
  }

  void addMessage(Message message) {
    setState(() {
      if (discussion == null && !discussion!.messages.contains(message)) {
        discussion?.messages.insert(0, message);
      }
    });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/widgets/my_message_card.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/widgets/shimmer_listview_builder.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUserId;
  const ChatList({
    Key? key,
    required this.reciverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList>
    with WidgetsBindingObserver {
  final ScrollController messageController = ScrollController();

  bool _isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    setState(() {
      _isKeyboardVisible = keyboardHeight > 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.watch(chatControllerProvider).chatMessages(widget.reciverUserId),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const ShimmerListViewBuilder();
        }
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Message messageData = snapshot.data![index];
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(messageData.timeSent),
                type: messageData.type,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: DateFormat.Hm().format(messageData.timeSent),
              type: messageData.type,
            );
          },
        );
      },
    );
  }
}

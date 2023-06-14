import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/models/chat_contact.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepositoy: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepositoy? chatRepositoy;
  final ProviderRef? ref;

  ChatController({
    this.chatRepositoy,
    this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref!.read(userDataAuthProvider).whenData(
          (value) => chatRepositoy!.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepositoy!.getChatContacts();
  }

  Stream<List<Message>> chatMessages(String reciverUserId) {
    return chatRepositoy!.getChatStream(reciverUserId);
  }
}

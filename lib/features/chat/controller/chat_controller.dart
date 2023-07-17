import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/models/chat_contact.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepository? chatRepository;
  final ProviderRef? ref;

  ChatController({
    this.chatRepository,
    this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref!.read(userDataAuthProvider).whenData(
          (value) => chatRepository!.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository!.getChatContacts();
  }

  Stream<List<Message>> chatMessages(String reciverUserId) {
    return chatRepository!.getChatStream(reciverUserId);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    //  final messageReply = ref!.read(messageReplyProvider);
    ref!.read(userDataAuthProvider).whenData(
          (value) => chatRepository!.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref!,
            // messageReply: messageReply,
            //isGroupChat: isGroupChat,
          ),
        );
    //ref?.read(messageReplyProvider.state).update((state) => null);
  }
}

import 'package:flutter/material.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/reciever_chat_bubble.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/sender_chat_bubble.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatModel.length,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(top: 20),
      itemBuilder: (context, index) {
        ChatModel chats = chatModel[index];

        return chats.isMine
            ? SenderBubble(chat: chats)
            : ReceivingBubble(chat: chats);
      },
    );
  }
}

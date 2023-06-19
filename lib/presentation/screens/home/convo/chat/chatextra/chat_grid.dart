import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/reciever_chat_bubble.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/sender_chat_bubble.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../model/conversation_model.dart';
import '../../../../../../services/middleware/chat_ware.dart';

class ChatList extends StatefulWidget {
  List<Conversation> chat;
  String me;
  String? to;
  ScrollController controller;
  String? myUserId;
  String? toUserId;
  bool isHome;
  ChatList(
      {super.key,
      required this.chat,
      required this.me,
      this.to,
      required this.controller,
      required this.myUserId,
      this.toUserId, required this.isHome});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  SharedPreferences? pref;

  String myName = "";
  Timer? timing;
  @override
  void initState() {
    super.initState();
    // timing = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   ChatController.retrievChatController(context, false);
    // });
    //  initPref();

 //   print(widget.myUserId ?? "Me");
  //  print(widget.toUserId ?? "Friend ");
  }

  bool show = true;

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    Temp temp = context.watch<Temp>();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            // print(notification.scrollDelta);

            //List scroll position

            if (notification.metrics.pixels == 0) {
           //   print(notification.scrollDelta);
             // log(notification.metrics.maxScrollExtent.toString());
              setState(() {
                show = false;
              });
            } else {
           //   log(notification.metrics.maxScrollExtent.toString());
              setState(() {
                show = true;
              });
            }
            return true;
          },
          child: StreamBuilder(
              stream: null,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
              //    print("nodata");
                } else if (snapshot.hasData) {
               //   print(snapshot.data);
                }
                return ListView.builder(
                  itemCount: stream.justChat.length,
                  // itemCount: widget.chat.last.sender != temp.userName
                  //     ? stream.chatList
                  //         .where((element) => element.userOne == widget.to)
                  //         .single
                  //         .conversations!
                  //         .length
                  //     : stream.chatList
                  //         .where((element) => element.userTwo == widget.to)
                  //         .single
                  //         .conversations!
                  //         .length,
                  controller: widget.controller,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 100, bottom: 100),
                  itemBuilder: (context, index) {
                    // Conversation chats = widget.chat.last.sender !=
                    //         temp.userName
                    //     ? stream.chatList
                    //         .where((element) => element.userOne == widget.to)
                    //         .single
                    //         .conversations![index]
                    //     : stream.chatList
                    //         .where((element) => element.userTwo == widget.to)
                    //         .single
                    //         .conversations![index];
                    Conversation chats = stream.justChat[index];

                    //not here before
                    // widget.controller.animateTo(
                    //   widget.controller.position.maxScrollExtent,
                    //   curve: Curves.easeOut,
                    //   duration: const Duration(milliseconds: 300),
                    // );

                    return widget.me == chats.sender
                        ? SenderBubble(chat: chats, isHome: widget.isHome)
                        : ReceivingBubble(
                            chat: chats,
                          );
                  },
                );
              }),
        ),
        show
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 67,
                  width: 326,
                  decoration: BoxDecoration(
                    color: HexColor("#F0ECF6"),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: SvgPicture.asset('assets/icon/lock.svg'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AppText(
                              size: 12,
                              color: HexColor("#8B8B8B"),
                              fontWeight: FontWeight.w400,
                              text:
                                  "Messsages here are end-to-end encrypted. No one outside of this chat, not even the developers can read them. "),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class FakeChatList extends StatefulWidget {
  const FakeChatList({super.key});

  @override
  State<FakeChatList> createState() => _FakeChatListState();
}

class _FakeChatListState extends State<FakeChatList> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    Temp temp = context.watch<Temp>();
    return Stack(
      children: [
        stream.fakeMsg.isEmpty
            ? const SizedBox.shrink()
            : NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  // print(notification.scrollDelta);

                  //List scroll position

                  if (notification.metrics.pixels == 0) {
                 //   print(notification.scrollDelta);
                 //   log(notification.metrics.maxScrollExtent.toString());
                    setState(() {
                      show = false;
                    });
                  } else {
                  //  log(notification.metrics.maxScrollExtent.toString());
                    setState(() {
                      show = true;
                    });
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: stream.fakeMsg.length,
                  // controller: widget.controller,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 20, bottom: 100),
                  itemBuilder: (context, index) {
                    return FakeSenderBubble(chat: stream.fakeMsg[index]);
                  },
                ),
              ),
        show
            ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 67,
                    width: 326,
                    decoration: BoxDecoration(
                      color: HexColor("#F0ECF6"),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: SvgPicture.asset('assets/icon/lock.svg'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: AppText(
                                size: 12,
                                color: HexColor("#8B8B8B"),
                                fontWeight: FontWeight.w400,
                                text:
                                    "Messsages here are end-end encrypted. No one outside of this chat, not even the developers can read them. "),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

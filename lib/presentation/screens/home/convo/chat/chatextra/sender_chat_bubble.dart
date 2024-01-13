import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../../../model/conversation_model.dart';
import '../../../../../operations.dart';

class SenderBubble extends StatelessWidget {
  final Conversation chat;
  final bool isHome;
  const SenderBubble({super.key, required this.chat, required this.isHome});

  @override
  Widget build(BuildContext context) {
    //   if(isHome == false){
    // ChatController.retrievChatController(context, false);
    //   }
    String utf8convert(String text) {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, left: 35.0, right: 0.0, top: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                //  height: 53,
                constraints: BoxConstraints(
                    //  maxWidth: MediaQuery.of(context).size.width * .8,
                    minWidth: MediaQuery.of(context).size.width * .3),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: backgroundSecondary,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.elliptical(5, 30))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 5, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chat.media != null
                          ? Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          chat.media!))),
                            )
                          : const SizedBox.shrink(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .7,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ChatAppText(
                            text: chat.body!,
                            color: textWhite,
                            size: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      text: "${Operations.times(chat.createdAt!).toString()} ",
                      color: HexColor("#C0C0C0"),
                      size: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5,
                      child: Icon(
                        Icons.done,
                        size: 8,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class FakeSenderBubble extends StatelessWidget {
  final String chat;
  const FakeSenderBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0, left: 35.0, right: 0.0, top: 15),
      child: Column(
        children: [
          Container(
            //  height: 53,
            width: MediaQuery.of(context).size.width * 0.8,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                color: HexColor(primaryColor),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: chat,
                    color: HexColor(backgroundColor),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  text: "",
                  color: HexColor("#C0C0C0"),
                  size: 12,
                ),
                SvgPicture.asset(
                  "assets/icon/done.svg",
                  width: 20,
                  height: 12,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

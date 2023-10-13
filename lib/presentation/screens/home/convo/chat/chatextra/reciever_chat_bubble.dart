import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../../../model/conversation_model.dart';

class ReceivingBubble extends StatelessWidget {
  final Conversation chat;
  const ReceivingBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    String utf8convert(String text) {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    }

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 5.0, left: 0.0, right: 35.0, top: 0),
      child: Column(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8,
                minWidth: MediaQuery.of(context).size.width * .3),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: HexColor(backgroundColor),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  chat.media != null
                      ? Container(
                          constraints: BoxConstraints(
                              maxHeight: 200,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(chat.media!))),
                        )
                      : const SizedBox.shrink(),
                  AppText(
                    text: chat.body!,
                    color: HexColor("#5F5F5F"),
                    size: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 5,
            ),
            child: Row(
              children: [
                AppText(
                  text: Operations.times(chat.createdAt!).toString(),
                  color: HexColor("#C0C0C0"),
                  size: 12,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

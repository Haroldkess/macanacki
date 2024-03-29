import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/conversation_model.dart';
import '../../../../../../services/middleware/chat_ware.dart';
import '../../../../../uiproviders/screen/chat_provider.dart';

class ReceivingBubble extends StatefulWidget {
  final Conversation chat;
  final AudioPlayer? player;
  ChatData? user;
  ReceivingBubble({super.key, required this.chat, this.player, this.user});

  @override
  State<ReceivingBubble> createState() => _ReceivingBubbleState();
}

class _ReceivingBubbleState extends State<ReceivingBubble> {
  bool ring = true;
  @override
  Widget build(BuildContext context) {
    ChatWare stream = context.watch<ChatWare>();
    // String utf8convert(String text) {
    //   List<int> bytes = text.toString().codeUnits;
    //   return utf8.decode(bytes);
    // }
    // print(chat.body);

    return ObxValue((recieve) {
      try {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          bool play;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            if (widget.chat.createdAt!.compareTo(
                    DateTime.now().subtract(const Duration(seconds: 7))) ==
                1) {
              play = true;
              if (widget.player != null) {
                if (play == true) {
                  try {
                    // emitter(
                    //     "don everything on the sound ${recieve.value}, ${widget.chat.id}");
                    if (recieve.value == widget.chat.id) {
                      await widget.player!
                          .setAsset(
                            "assets/sound/receive.mp3",
                            preload: false,
                          )
                          .then((_) => ChatProvider.instance.changeId(0));
                      // emitter(
                      //     "don everything on the sound ${recieve.value}, ${widget.chat.id}  second step");
                      widget.player!
                          .play()
                          .then((value) => ChatProvider.instance.changeId(0));
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        ChatProvider.instance.changeId(0);
                      });
                    }

                    play = false;
                    play = true;

                    // Future.delayed(Duration(seconds: 1))
                    //     .whenComplete(() => play = true);
                  } catch (e) {
                    print(e);
                  }
                }
              }
            }

            //    await Future.delayed(Duration(seconds: 3));
          });
        });
      } catch (e) {
        emitter(e.toString());
      }

      return Visibility(
        visible: recieve.value > 0 ? true : true,
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 5.0, left: 0.0, right: 35.0, top: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.8,
                    constraints: BoxConstraints(
                        //  maxWidth: MediaQuery.of(context).size.width * .8,
                        minWidth: MediaQuery.of(context).size.width * .3),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.elliptical(5, 30))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 5, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.chat.media != null
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 200,
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              widget.chat.media!))),
                                )
                              : const SizedBox.shrink(),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .7,
                            ),
                            child: ChatAppText(
                              text: widget.chat.body!,
                              color: textWhite,
                              // color: HexColor("#5F5F5F"),
                              size: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(
                          //         left: 0,
                          //         top: 5,
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           AppText(
                          //             text:
                          //                 Operations.times(chat.createdAt!).toString(),
                          //             color: HexColor("#C0C0C0"),
                          //             size: 10,
                          //           )
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 10,
                    child: AppText(
                      text: Operations.times(widget.chat.createdAt!).toString(),
                      color: textPrimary,
                      size: 10,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }, ChatProvider.instance.id);
  }
}

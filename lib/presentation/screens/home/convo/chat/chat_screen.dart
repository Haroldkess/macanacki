import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_field.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_grid.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/option_menu.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../../../model/conversation_model.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/hexagon_avatar.dart';

class ChatScreen extends StatefulWidget {
  ChatData user;
  List<Conversation> chat;
  String? dp;
  String? mode;
  ChatScreen({super.key, required this.user, required this.chat, this.dp, required this.mode});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController? controiller = ScrollController();
  TextEditingController msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool? isOnline;
    var size = MediaQuery.of(context).size;
    var w = (size.width - 4 * 1) / 15;
    Temp stream = context.watch<Temp>();
    Temp temp = context.watch<Temp>();
    if (widget.user.conversations!.isEmpty) {
      isOnline = false;
    } else {
      if (widget.user.conversations!.last.sender == temp.userName) {
        if (widget.user.userTwoMode == "online") {
          isOnline = true;
        } else {
          isOnline = false;
        }
      } else {
        if (widget.user.userOneMode == "Online") {
          isOnline = true;
        } else {
          isOnline = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    HexagonWidget.pointy(
                      width: w + 4.0,
                      elevation: 3.0,
                      color: Colors.white,
                      cornerRadius: 7.0,
                      child: AspectRatio(
                        aspectRatio: HexagonType.POINTY.ratio,
                        // child: Image.asset(
                        //   'assets/tram.jpg',
                        //   fit: BoxFit.fitWidth,
                        // ),
                      ),
                    ),
                    widget.user.conversations!.isEmpty
                        ? HexagonAvatar(
                            url: widget.user.userTwoProfilePhoto == null
                                ? widget.dp!
                                : widget.user.userTwoProfilePhoto!,
                            w: w + 4)
                        : HexagonAvatar(
                            url: widget.user.conversations!.last.sender ==
                                    stream.userName
                                ? widget.user.userTwoProfilePhoto!
                                : widget.user.userOneProfilePhoto!,
                            w: w + 4),
                  ],
                ),
                Positioned(
                  right: 1.1,
                  top: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: widget.mode == "online" ? Colors.green : Colors.red,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            widget.user.conversations!.isNotEmpty
                ? RichText(
                    text: TextSpan(
                    text: widget.user.conversations!.last.sender ==
                            stream.userName
                        ? "${widget.user.userTwo} "
                        : "${widget.user.userOne} ",
                    style: GoogleFonts.spartan(
                      color: HexColor(darkColor),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    //     children: [
                    //   TextSpan(
                    //     text: widget.user.age,
                    //     style: GoogleFonts.spartan(
                    //         color: HexColor("#C0C0C0"), fontSize: 20),
                    //   )
                    // ]
                  ))
                : RichText(
                    text: TextSpan(
                    text: "${widget.user.userTwo} ",

                    style: GoogleFonts.spartan(
                      color: HexColor(darkColor),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    //     children: [
                    //   TextSpan(
                    //     text: widget.user.age,
                    //     style: GoogleFonts.spartan(
                    //         color: HexColor("#C0C0C0"), fontSize: 20),
                    //   )
                    // ]
                  )),
          ],
        ),

        // AppText(
        //   text: widget.user.name,
        //   color: HexColor(darkColor),
        //   size: 24,
        //   fontWeight: FontWeight.w700,
        // ),
        centerTitle: true,
        leading: BackButton(color: HexColor("#322929")),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: InkWell(
              onTap: () => chatOptionModal(context),
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: Colors.transparent,
                        style: BorderStyle.solid)),
                child: SvgPicture.asset(
                  "assets/icon/options.svg",
                  color: HexColor(darkColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: "",
                      size: 14,
                      color: HexColor("#8B8B8B"),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: widget.user.conversations!.isEmpty
                  ? FakeChatList()
                  : ChatList(
                      chat: widget.chat,
                      me: widget.user.conversations!.last.sender ==
                              stream.userName
                          ? widget.user.userOne!
                          : widget.user.userTwo!,
                      to: widget.user.conversations!.last.sender ==
                              stream.userName
                          ? widget.user.userTwo
                          : widget.user.userOne,
                      controller: controiller!,
                    ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: widget.user.conversations!.isEmpty
                    ? ChatForm(
                        controller: controiller!,
                        msgController: msgController,
                        sendTo: widget.user.userTwo!,
                        chat: widget.user,

                        //  val: controiller!.position.maxScrollExtent,
                      )
                    : ChatForm(
                        controller: controiller!,
                        msgController: msgController,
                        sendTo: widget.user.conversations!.last.sender ==
                                stream.userName
                            ? widget.user.userTwo!
                            : widget.user.userOne!,
                        chat: widget.user,
                        //  val: controiller!.position.maxScrollExtent,
                      )),
          ],
        ),
      ),
    );
  }
}

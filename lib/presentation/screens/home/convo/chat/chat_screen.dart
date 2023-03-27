import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_field.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/chat_grid.dart';
import 'package:makanaki/presentation/screens/home/convo/chat/chatextra/option_menu.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';

class ChatScreen extends StatefulWidget {
  final AppUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
            text: TextSpan(
                text: "${widget.user.name}, ",
                style: GoogleFonts.spartan(
                  color: HexColor(darkColor),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                children: [
              TextSpan(
                text: widget.user.age,
                style: GoogleFonts.spartan(
                    color: HexColor("#C0C0C0"), fontSize: 20),
              )
            ])),

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
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: HexColor("#E8E6EA"),
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
                      text: "Tue, Nov 29, 2022",
                      size: 14,
                      color: HexColor("#8B8B8B"),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ChatList(),
            ),
            Align(alignment: Alignment.bottomCenter, child: const ChatForm()),
          ],
        ),
      ),
    );
  }
}

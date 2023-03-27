import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class SenderBubble extends StatelessWidget {
  final ChatModel chat;
  const SenderBubble({super.key, required this.chat});

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
              child: AppText(
                text: chat.msg,
                color: HexColor(backgroundColor),
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
                  text: chat.time,
                  color: HexColor("#C0C0C0"),
                  size: 12,
                ),
                SvgPicture.asset("assets/icon/done.svg")
              ],
            ),
          )
        ],
      ),
    );
  }
}

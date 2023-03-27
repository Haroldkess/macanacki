import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class ReceivingBubble extends StatelessWidget {
  final ChatModel chat;
  const ReceivingBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15.0, left: 0.0, right: 35.0, top: 15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
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
              child: AppText(
                text: chat.msg,
                color: HexColor("#5F5F5F"),
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
                  text: chat.time,
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/middleware/chat_ware.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/conversation_model.dart';
import '../../../../../../services/controllers/mode_controller.dart';
import '../../../../../../services/middleware/user_profile_ware.dart';
import '../../../../../constants/colors.dart';
import '../../../../../uiproviders/screen/card_provider.dart';

class ChatForm extends StatelessWidget {
  ScrollController controller;
  TextEditingController msgController;
  String sendTo;
  ChatData chat;
  IO.Socket? socket;
  String? toId;
  ChatForm(
      {super.key,
      required this.controller,
      required this.msgController,
      required this.chat,
      required this.sendTo,
      required this.socket,
      this.toId});

  @override
  Widget build(BuildContext context) {
    CardProvider stream = context.watch<CardProvider>();
    ChatWare chatWare = context.watch<ChatWare>();
    CardProvider provide = Provider.of<CardProvider>(context, listen: false);
    ChatWare listenWare = Provider.of<ChatWare>(context, listen: false);
    if (socket == null) {
    } else {
    

      // socket!.on("getMessage", (data2) async {
      //   Conversation data3 = Conversation(
      //     body: data2.toString(),
      //     read: true,
      //     id: chatWare.justChat.length + 1,
      //     senderId: int.tryParse(toId!),
      //     createdAt: DateTime.now(),
      //     updatedAt: DateTime.now(),
      //     sender: sendTo,
      //   );
      //   if (data2 != null) {
      //     print(data2);
      //     listenWare.addMsg(data3);
      //     ChatController.readAll(context, int.tryParse(toId!)!);
      //     //  ChatController.retrievChatController(context, false);
      //   } else {
      //     print("null");
      //   }
      // });
    }

    // Future.delayed(const Duration(seconds: 1)).whenComplete(() {
    //   controller.animateTo(
    //     controller.position.maxScrollExtent,
    //     curve: Curves.easeOut,
    //     duration: const Duration(milliseconds: 300),
    //   );
    // });
    return Card(
      color: Colors.transparent,
      elevation: 10,
      shadowColor: HexColor("#D8D1F4"),
      child: Container(
        height: stream.addHeight ? 80 : 53,
        width: 379,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: HexColor(backgroundColor),
            shape: BoxShape.rectangle,
            border: Border.all(
                width: 1.0,
                color: HexColor("#E8E6EA"),
                style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: TextFormField(
          controller: msgController,
          cursorColor: HexColor(primaryColor),
          // textInputAction: TextInputAction.go,
          maxLines: null,
          onChanged: (val) async {
            if (val.isEmpty) {
              provide.increase(false);
              provide.typeMsg(false);
            } else {
              provide.typeMsg(true);
              if (val.length > 35) {
                provide.increase(true);
              }
            }
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "  Your message",
            hintStyle:
                GoogleFonts.spartan(color: HexColor("#8B8B8B"), fontSize: 14),
            contentPadding: const EdgeInsets.only(top: 15, bottom: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/icon/sticker.svg",
                height: 5,
                width: 5,
                color: const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
            suffixIcon: stream.isTyping
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () async {
                            if (chatWare.socket != null) {
                ChatController.addUserToSocket(context);
              }
                        ChatController.sendMessageHandler(
                            context, msgController, chat, toId!, sendTo);
                        // UserProfileWare user = Provider.of<UserProfileWare>(
                        //     context,
                        //     listen: false);
                        // ChatWare ware =
                        //     Provider.of<ChatWare>(context, listen: false);
                        // if (msgController.text.isEmpty) return;

                        // final saveMsg = msgController.text;

                        // Conversation data = Conversation(
                        //   body: msgController.text,
                        //   read: true,
                        //   id: ware.justChat.length + 1,
                        //   senderId: user.userProfileModel.id,
                        //   createdAt: DateTime.now(),
                        //   updatedAt: DateTime.now(),
                        //   sender: user.userProfileModel.username,
                        // );
                        // var messageMap = {
                        //   "from": int.tryParse(
                        //       user.userProfileModel.id!.toString()),
                        //   "to": int.tryParse(toId!),
                        //   "message": saveMsg,
                        // };
                        // socket!.emit(
                        //   "sendMessage",
                        //   messageMap,
                        // );
                        // ware.addMsg(data);
                        // msgController.clear();
                        // provide.typeMsg(false);

                        // await ChatController.sendChatController(
                        //   context,
                        //   saveMsg,
                        //   sendTo,
                        //   chat,
                        // );
                      },
                      child: SvgPicture.asset(
                        "assets/icon/Send.svg",
                        height: 5,
                        width: 5,
                        color: const Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: const BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  }
}

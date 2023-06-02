import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:makanaki/model/conversation_model.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/controllers/plan_controller.dart';
import 'package:makanaki/services/middleware/chat_ware.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController {
  static Future<void> retrievChatCompare(
      BuildContext context, bool isForm) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);

    bool isDone = await ware
        .getChatFromApi2()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      // if (isForm) {
      //   ware.isLoading(false);
      // }
      debugPrint("we  have fetched all Chat");

      // if (isForm) {
      //   ware.isLoading(false);
      // }
      // ignore: use_build_context_synchronously
      //  showToast2(context, ware.message, isError: false);
    } else {
      debugPrint("we  have fetched all Chat");
    }

    // if (isForm) {
    //   ware.isLoading(true);
    // }
  }

  static Future<void> retrievChatController(
      BuildContext context, bool isForm) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);

    if (isForm) {
      ware.isLoading(true);
    }

    bool isDone = await ware
        .getChatFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      if (isForm) {
        ware.isLoading(false);
      }
      debugPrint("we  have fetched all Chat");
    } else {
      if (isForm) {
        ware.isLoading(false);
        // ignore: use_build_context_synchronously
        showToast2(context, "User unavailable at the moment", isError: false);
      }
      // ignore: use_build_context_synchronously
      //  showToast2(context, ware.message, isError: false);
    }
    if (isForm) {
      ware.isLoading(false);
    }
  }

  static Future<void> sendChatController(
      BuildContext context, String msg, String to, ChatData chat) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    SharedPreferences pref = await SharedPreferences.getInstance();
    // Conversation converse = Conversation(
    //   id: 500000,
    //   body: msg.text,
    //   read: null,
    //   senderId: user.userProfileModel.id,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    //   sender: user.userProfileModel.username,
    //   media: null,
    // );

    SendMsgModel data = SendMsgModel(
      body: msg,
      username: to,
    );

    // ware.isLoading(true);

    bool isDone = await ware
        .sendMsgUserFromApi(data)
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      // if (chat.conversations!.isNotEmpty) {
      //   ware.removeTempMsg(chat.id!);
      // }

      //   msg.clear();
      // if (ware.message == "user must be followed before you can send message") {
      //   if (user.userProfileModel.activePlan == "inactive subscription") {
      //     // ignore: use_build_context_synchronously
      //     await PlanController.retrievPlanController(context);
      //   } else {
      //     // ignore: use_build_context_synchronously
      //     showToast2(context, ware.message, isError: true);
      //   }
      // ignore: use_build_context_synchronously
      // msg.clear();
      // showToast2(context, ware.message, isError: true);
      // return;
      // } else {
      //   //msg.clear();
      // }
      // ignore: use_build_context_synchronously
      bool isDone2 = await ware
          .getChatFromApi()
          .whenComplete(() => log("everything from api and provider is done"));
      if (isDone2) {
        // if (isForm) {
        //   ware.isLoading(false);
        // }
        debugPrint("we  have fetched all Chat");
      } else {
        // if (isForm) {
        //   ware.isLoading(false);
        // }
        // ignore: use_build_context_synchronously
        //  showToast2(context, ware.message, isError: false);
      }
      //  ware.isLoading(false);
    } else {
      // if (user.userProfileModel.activePlan == "inactive subscription") {
      //   // ignore: use_build_context_synchronously
      //   await PlanController.retrievPlanController(context);
      // } else {
      //   // ignore: use_build_context_synchronously
      //   showToast2(context, ware.message, isError: true);
      // }

      //  ware.isLoading(false);
      // ignore: use_build_context_synchronously
      // msg.clear();
      // showToast2(context, ware.message, isError: true);

      // ignore: use_build_context_synchronously
      // showToast2(context, ware.message, isError: true);
    }
  }
}

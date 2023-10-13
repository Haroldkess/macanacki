// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:macanacki/model/conversation_model.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/controllers/plan_controller.dart';
import 'package:macanacki/services/middleware/chat_ware.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation/uiproviders/screen/card_provider.dart';

class StreamSocket {
  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class StreamSocketMsgs {
  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();
StreamSocketMsgs streamSocketMsgs = StreamSocketMsgs();

class ChatController {
  // static Future<void> retrievChatCompare(
  //     BuildContext context, bool isForm) async {
  //   ChatWare ware = Provider.of<ChatWare>(context, listen: false);

  //   bool isDone = await ware.getChatFromApi2().whenComplete(
  //       () => emitter("everything from api and provider is done"));

  //   if (isDone) {
  //     // if (isForm) {
  //     //   ware.isLoading(false);
  //     // }
  //     //   debugPrint("we  have fetched all Chat");

  //     // if (isForm) {
  //     //   ware.isLoading(false);
  //     // }
  //     // ignore: use_build_context_synchronously
  //     //  showToast2(context, ware.message, isError: false);
  //   } else {
  //     //   debugPrint("we  have fetched all Chat");
  //   }

  //   // if (isForm) {
  //   //   ware.isLoading(true);
  //   // }
  // }

  static Future<void> retrievChatController(
      BuildContext context, bool isForm, bool isPaginated,
      [int? pageNum]) async {
    ChatWare ware = Provider.of(context, listen: false);

    if (isForm) {
      ware.isLoading(true);
    }

    bool isDone = await ware
        .getChatFromApi(false, pageNum ?? 1, isPaginated)
        .whenComplete(
            () => emitter("everything from api and provider is done"));

    if (isDone) {
      if (isForm) {
        ware.isLoading(false);
      }
      //  debugPrint("we  have fetched all Chat");
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

  static Future<void> retreiveUnread(BuildContext context) async {
    ChatWare ware = Provider.of(context, listen: false);

    bool isDone = await ware.getAllUnreadFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      emitter("we gotten all unread messages ");
    } else {
      // ignore: use_build_context_synchronously
      // showToast2(context, "something went wrong", isError: false);

      // ignore: use_build_context_synchronously
      //  showToast2(context, ware.message, isError: false);
    }
  }

  static Future<void> readAll(BuildContext context, int userId) async {
    ChatWare ware = Provider.of(context, listen: false);

    bool isDone = await ware.readAllFromApi(userId).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      // ignore: use_build_context_synchronously
      //  await retreiveUnread(context);
      //    emitter("we read all unread messages");
    } else {
      //    emitter(" read all unread messages FAILED");
      // ignore: use_build_context_synchronously
      // showToast2(context, "something went wrong", isError: false);

      // ignore: use_build_context_synchronously
      //  showToast2(context, ware.message, isError: false);
    }
  }

  static Future<bool> sendChatController(
      BuildContext context, String msg, String to, ChatData chat) async {
    late bool sent;
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

    bool isDone = await ware.sendMsgUserFromApi(data).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      sent = true;
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
      // bool isDone2 = await ware.getChatFromApi().whenComplete(
      //     () => emitter("everything from api and provider is done"));
      //  if (isDone2) {
      // if (isForm) {
      //   ware.isLoading(false);
      // }
      //  debugPrint("we  have fetched all Chat");
      //  } else {
      // if (isForm) {
      //   ware.isLoading(false);
      // }
      // ignore: use_build_context_synchronously
      //  showToast2(context, ware.message, isError: false);
      //  }
      //  ware.isLoading(false);
    } else {
      sent = false;
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

    return sent;
  }

  static Future<void> initSocket(BuildContext context) async {
    IO.Socket? socket;

    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(tokenKey);
    socket = IO.io(
      chatUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({"Authorization": "$token"})
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      ware.addSocket(socket);
      print('Connection established');
    });
    ware.addSocket(socket);
// socket.on("getMessage", (data) {
//       if (data != null) {
//         ChatController.handleMessage(context, data);
//       } else {
//         print("null");
//       }
//     });
    addUserToSocket(context);

    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
    socket.onDisconnect((_) => print('Connection Disconnection'));
    print(socket.connected);

    // ignore: use_build_context_synchronously
  }

  static void addUserToSocket(BuildContext context) {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    ware.socket!.emit("addUserId", '${user.userProfileModel.id}');
  }

  static void listenForUser(BuildContext context) {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    ware.socket!.on("getUsers", (data) {
      if (data != null) {
        streamSocket.addResponse(data);

        // print(data);
      } else {
        //  print("null");
      }
    });
  }

  static void addUserToList(BuildContext context, data) {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    var dat = jsonDecode(jsonEncode(data));
    // SockerUserModel sockerUserModel = SockerUserModel(data: );

    emitter(data.toString());
    if (data == "user disconnected") {
      return;
    }

    final val = sockerUserModelFromJson(data);

    ware.addUser(val);

    emitter(ware.allSocketUsers.length.toString());
  }

  static void listenForMessages(BuildContext context) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    ware.socket!.on("getMessage", (data) {
      if (data != null) {
        streamSocketMsgs.addResponse(data);

        // handleMessage(context, data);
      } else {
        //  print("null");
      }
    });
  }

  static void handleMessage(context, data) async {
    // log(data.toString());
    //   emitter(data.toString());
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    final jsonData = jsonDecode(data);
    //  emitter(jsonData.toString());

    var val = AllConversationModel.fromJson(jsonData);

    var dat = val.data!.first;

    ChatData chatData = ChatData(
      id: dat.id,
      status: dat.status,
      blockedBy: dat.blockedBy,
      createdAt: dat.createdAt,
      updatedAt: dat.updatedAt,
      userOne: dat.userOne,
      userOneId: dat.userOneId,
      userOneMode: dat.userOneMode,
      userOneVerify: dat.userOneVerify,
      userOneProfilePhoto: dat.userOneProfilePhoto,
      userTwo: dat.userTwo,
      userTwoId: dat.userTwoId,
      userTwoMode: dat.userTwoMode,
      userTwoVerify: dat.userTwoVerify,
      userTwoProfilePhoto: dat.userTwoProfilePhoto,
      conversations: dat.conversations,
    );

    emitter(chatData.conversations!.first.body! +
        " ${chatData.conversations!.first.id}" +
        " ${chatData.conversations!.first.createdAt}");

    ware.testAddToChatData(chatData);

    retreiveUnread(context);

    if (ware.chatPage != 0) {
      readAll(context, ware.chatPage);
    }

    // Conversation data3 = Conversation(
    //   body: data2.toString(),
    //   read: true,
    //   id: chatWare.justChat.length + 1,
    //   senderId: int.tryParse(toId!),
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    //   sender: sendTo,
    // );

    // emitter(jsonData.toString());
  }

  static Future addToList(context, data) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    if (data != null && ware.newConversationData != null) {
      //   emitter("Lets try this  ${data.userTwoProfilePhoto}");
      List<Conversation> newConvo = data.first.conversations!;
      newConvo.insert(0, data.last);

      ChatData chatData = ChatData(
        id: data.first.id,
        status: data.first.status,
        blockedBy: data.first.blockedBy,
        createdAt: data.first.createdAt,
        updatedAt: data.first.updatedAt,
        userOne: data.first.userOne,
        userOneId: data.first.userOneId,
        userOneMode: data.first.userOneMode,
        userOneVerify: data.first.userOneVerify,
        userOneProfilePhoto: data.first.userOneProfilePhoto,
        userTwo: data.first.userTwo,
        userTwoId: data.first.userTwoId,
        userTwoMode: data.first.userTwoMode,
        userTwoVerify: data.first.userTwoVerify,
        userTwoProfilePhoto: data.first.userTwoProfilePhoto,
        conversations: newConvo,
      );

      //  emitter("Lets try this");

      ware.replaceChatData(chatData);
    } else {
      //   emitter("did not work");
    }
    ware.addNewChatData(null);
    ware.addNewConvoData(null);
  }

  static Future sendMessageHandler(
      BuildContext context,
      TextEditingController msgController,
      ChatData chat,
      String toId,
      String sendTo) async {
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    CardProvider provide = Provider.of<CardProvider>(context, listen: false);
    if (msgController.text.isEmpty) return;
    final saveMsg = msgController.text;
    Conversation data = Conversation(
        body: msgController.text,
        read: true,
        id: ware.justChat.length + 1,
        senderId: user.userProfileModel.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: user.userProfileModel.username,
        determineId: chat.id);
    ware.addNewChatData(chat);
    ware.addNewConvoData(data);
    //  ware.allowed(true);

    ware.addMsg(data);
    // ChatData newData = ChatData(
    //     id: chat.id,
    //     status: chat.status,
    //     blockedBy: chat.blockedBy,
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     userOne: chat.userOne,
    //     userOneId: chat.userOneId,
    //     userOneMode: chat.userOneMode,
    //     userOneVerify: chat.userOneVerify,
    //     userOneProfilePhoto: chat.userOneProfilePhoto,
    //     userTwo: chat.userTwo,
    //     userTwoId: chat.userTwoId,
    //     userTwoMode: chat.userTwoMode,
    //     userTwoVerify: chat.userTwoVerify,
    //     userTwoProfilePhoto: chat.userTwoProfilePhoto,
    //     conversations: [data]);
    // ware.testAddToChatData(newData);
    msgController.clear();
    provide.typeMsg(false);

    bool isSent = await sendChatController(
      context,
      saveMsg,
      sendTo,
      chat,
    );

    if (isSent) {
      //   emitter("message is sent run extra functions");

      // emitter("we call the socket here");
      var messageMap = {
        "from": int.tryParse(user.userProfileModel.id!.toString()),
        "to": int.tryParse(toId),
        "message": ware.messageReturn,
      };
      //   emitter("Sent message ${ware.messageReturn}");
      ware.socket!.emit(
        "sendMessage",
        messageMap,
      );

      ware.clearReturnMessage();
    } else {
      //  emitter("WE DID NOT SEND TO SOCKET");
    }
    ReadAndRetrieve.handleunread(toId);
    // retreiveUnread(context);
    //readAll(context, int.tryParse(toId)!);

//  { "data": [  {"socketId": "ePYULb5MpymhWOA4AAsU", "userId": 17}, {"socketId": "yZbBEpAggJLn0vDYAAsa", "userId": 16}]}
  }

  static Future<void> changeChatPage(context, int id) async {
    ChatWare ware = Provider.of<ChatWare>(context, listen: false);
    ware.chatPageChange(id);

    // emitter("Chat page id ${ware.chatPage}");
  }
}

class ReadAndRetrieve extends ChatWare {
  static Future<void> handleunread(id) async {
    ChatWare ware = ChatWare();
    ware.getAllUnreadFromApi();
    ware.readAllFromApi(int.tryParse(id.toString())!);
  }
}

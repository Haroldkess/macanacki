import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/conversation_model.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/presentation/widgets/debug_emitter.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../backoffice/chat_office.dart';

class ChatWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Something went wrong";
  ScrollController controller = ScrollController();
  List<String> fakeMsg = [];
  Timer? _timing;
  List<Conversation> justChat = [];

  List<ChatData> _chatList = [];
  List<ChatData> chatList2 = [];
  AllConversationModel _chat = AllConversationModel();

  bool get loadStatus => _loadStatus;
  List<ChatData> get chatList => _chatList;
  AllConversationModel get chat => _chat;

  Future addTempFakeMsg(String msg) async {
    fakeMsg.add(msg);
    notifyListeners();
  }

  Stream checkAndRedeemChat(
      String sendTo, IO.Socket? socket, String toId) async* {
    late String data;
    doAction(sendTo, socket, toId).listen((event) {
      if (event.toString().isEmpty) {
        data = event.toString();
      } else {
        data = event.toString();
      }
    });
    yield data;
  }

  Stream doAction(String sendTo, IO.Socket? socket, String toId) async* {
    String? data;
    if (socket == null) {
    } else {
      socket.on("getUsers", (data2) async {
        Conversation data3 = Conversation(
          body: data2.toString(),
          read: true,
          id: justChat.length + 1,
          senderId: int.tryParse(toId),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          sender: sendTo,
        );
        if (data2 != null) {
          log(data2.toString());
          addMsg(data3);

          data = data2.toString();
        } else {
          log("null");

          data = "data is null";
        }
      });
    }

    notifyListeners();

    yield data ?? "nothing";
  }

  Future addMsg(Conversation msg) async {
    // emitter(msg.createdAt);
    if (justChat.isEmpty) {
      justChat.insert(0, msg);
    } else {
      if (justChat[0].body == msg.body &&
          "${justChat[0].createdAt!.year}-${justChat[0].createdAt!.month}-${justChat[0].createdAt!.day} ${justChat[0].createdAt!.hour}:${justChat[0].createdAt!.minute}" ==
              "${msg.createdAt!.year}-${msg.createdAt!.month}-${msg.createdAt!.day} ${msg.createdAt!.hour}:${msg.createdAt!.minute}") {
      } else {
        justChat.insert(0, msg);
      }
    }

    notifyListeners();
  }

  Future addAllMsg(List<Conversation> msg) async {
    //final List<Conversation> hold = justChat;
    justChat.clear();
    justChat.addAll(msg);
    //justChat.addAll();
    notifyListeners();
  }

  Future removeTempFakeMsg() async {
    fakeMsg.clear();
    notifyListeners();
  }

  void disposeValue() async {
    _chatList = [];
    _chat = AllConversationModel();
    message = "";

    notifyListeners();
  }

  void addTempMsg(int id, Conversation convo) {
    chatList
        .where((element) => id == element.id)
        .single
        .conversations!
        .add(convo);
    notifyListeners();
  }

  void removeTempMsg(int id) {
    chatList
        .where((element) => id == element.id)
        .single
        .conversations!
        .removeWhere((element) => element.id == 500000);
    notifyListeners();
  }

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> getChatFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllConversation()
          .whenComplete(() => emitter("chats gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("chats request failed");
      } else if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);

        var incomingData = AllConversationModel.fromJson(jsonData);
        _chatList = incomingData.data!;
        message = jsonData["message"];

        //  log("chats  request success");
        isSuccessful = true;
      } else {
        //  log("chats  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("chats  request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getChatFromApi2() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllConversation()
          .whenComplete(() => emitter("chats gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("chats request failed");
      } else if (response.statusCode == 201) {
        print("omooooooooo");
        var jsonData = jsonDecode(response.body);

        var incomingData = AllConversationModel.fromJson(jsonData);
        chatList2 = incomingData.data!;
        _chatList = incomingData.data!;
        message = jsonData["message"];

        log(incomingData.data!.first.userTwo!);
        isSuccessful = true;
      } else {
        //  log("chats  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("chats  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> sendMsgUserFromApi(
    SendMsgModel data,
  ) async {
    late bool isSuccessful;

    try {
      http.StreamedResponse? response = await sendMessageTo(data);

      if (response == null) {
        emitter(" message sending null;");
        isSuccessful = false;
      } else if (response.statusCode == 201) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        message = jsonData["message"];
        //  log(jsonData["message"]);
        emitter("message sent successfully");
        isSuccessful = true;
        //  var res = http.Response.fromStream(response);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        message = jsonData["message"];
        isSuccessful = false;
        emitter(res.statusCode.toString());
        emitter("did not succeeeeeeee");
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/conversation_model.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../backoffice/chat_office.dart';

class ChatWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Something went wrong";
  ScrollController controller = ScrollController();
  List<String> fakeMsg = [];
  Timer? _timing;

  List<ChatData> _chatList = [];
  AllConversationModel _chat = AllConversationModel();

  bool get loadStatus => _loadStatus;
  List<ChatData> get chatList => _chatList;
  AllConversationModel get chat => _chat;
  

  Future addTempFakeMsg(String msg) async {
    fakeMsg.add(msg);
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
          .whenComplete(() => log("chats gotten successfully"));
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

  Future<bool> sendMsgUserFromApi(
    SendMsgModel data,
  ) async {
    late bool isSuccessful;

    try {
      http.StreamedResponse? response = await sendMessageTo(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 201) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        message = jsonData["message"];
        //  log(jsonData["message"]);
        isSuccessful = true;
        //  var res = http.Response.fromStream(response);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        message = jsonData["message"];
        isSuccessful = false;
        // print("did not succeeeeeeee");
      }
    } catch (e) {
      isSuccessful = false;
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}

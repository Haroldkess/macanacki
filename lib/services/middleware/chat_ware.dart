import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/conversation_model.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../backoffice/chat_office.dart';

class ChatWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool isTexted = false;
  String chatName = "";
  ChatData? newChatData;
  Conversation? newConversationData;
  AllConversationModel? initialConverstation;
  String message = "Something went wrong";
  ScrollController controller = ScrollController();
  List<SockerUserModel> allSocketUsers = [];
  List<String> fakeMsg = [];
  Timer? _timing;
  int chatPage = 0;
  List<Conversation> justChat = [];
  List<UnreadData> unreadMsgs = [];
  String searchName = "";
  List<ChatData> _chatList = [];
  List<ChatData> _holdingChatList = [];
  List<ChatData> chatList2 = [];
  AllConversationModel _chat = AllConversationModel();
  IO.Socket? socket;
  dynamic messageReturn;
  bool get loadStatus => _loadStatus;
  List<ChatData> get chatList => _chatList;
  AllConversationModel get chat => _chat;

  void addNewChatData(newData) {
    newChatData = newData;
    notifyListeners();
  }

  Future addChatName(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("chatNameKey", name);
    chatName = name;
    notifyListeners();
  }

  void texted(bool val) {
    isTexted = val;
    notifyListeners();
  }

  void addNewConvoData(newData) {
    newConversationData = newData;
    notifyListeners();
  }

  void addToSearch(String txt) {
    searchName = txt;
    notifyListeners();
  }

  void clearReturnMessage() {
    messageReturn = "";
    messageReturn = null;
    notifyListeners();
  }

  void chatPageChange(int val) {
    chatPage = val;
    notifyListeners();
  }

  void addHoldingChats() {
    _chatList = _holdingChatList;
    notifyListeners();
  }

  Future<void> replaceChatData(ChatData? dat) async {
    _chatList
        .where((element) => element.id == dat!.id)
        .first
        .conversations!
        .insert(0, dat!.conversations!.first);

    //         final holdList = _chatList.where((element) => element.id == dat!.id).first;
    // _chatList.removeWhere((element) => element.id == dat!.id);

    // final value = holdList.conversations!.insert(0, dat!.conversations!.first);

    // _chatList.insert(0, value as ChatData);

    //  tempData.;
    // Conversation toBeAdded = Conversation(
    //   id: dat!.conversations!.first.id,
    //   body: dat.conversations!.first.body,
    //   read: dat.conversations!.first.read,
    //   senderId: dat.conversations!.first.senderId,
    //   createdAt: dat.conversations!.first.createdAt,
    //   updatedAt: dat.conversations!.first.updatedAt,
    //   sender: dat.conversations!.first.sender,
    //   media: dat.conversations!.first.media,
    //   determineId: dat.id,
    // );

    // chatAdd.conversations!.insert(0, toBeAdded);

    // ChatData newChat = chatAdd;

    // for (var i = 0; i < tempData.length; i++) {
    //   List<ChatData> forCheck =
    //       tempData.where((element) => element.id == dat.id).toList();
    //   if (tempData[i].id == dat.id) {

    //     tempData.add(newChat);
    //     _chatList = [];
    //     _chatList.clear();
    //     _chatList = tempData;
    //     addMsg(toBeAdded);
    //     notifyListeners();
    //   }

    //   // if(forCheck.isNotEmpty){

    //   // }
    // }

    // _chatList
    //     .where((element) {
    //       return element.id == dat!.id;
    //     })
    //     .toList()
    //     .first
    //     .conversations!
    //     .addAll(dat!.conversations!);

    // dat.conversations!.forEach((element) async {
    // Conversation data = Conversation(
    //   id: dat.conversations!.first.id,
    //   body: dat.conversations!.first.body,
    //   read: dat.conversations!.first.read,
    //   senderId: dat.conversations!.first.senderId,
    //   createdAt: dat.conversations!.first.createdAt,
    //   updatedAt: dat.conversations!.first.updatedAt,
    //   sender: dat.conversations!.first.sender,
    //   media: dat.conversations!.first.media,
    //   determineId: dat.id,
    // );

    //   });

    notifyListeners();
  }

  Future<void> testAddToChatData(ChatData? dat) async {
    List<ChatData> tempData = _chatList;
    List<ChatData> chatAddList =
        tempData.where((element) => element.id == dat!.id).toList();

    if (chatAddList.isEmpty) {
      await getChatFromApi(false, 1, false).whenComplete(() async {
        tempData = _chatList;
        ChatData chatAdd =
            tempData.where((element) => element.id == dat!.id).first;
        Conversation toBeAdded = Conversation(
          id: dat!.conversations!.first.id,
          body: dat.conversations!.first.body,
          read: dat.conversations!.first.read,
          senderId: dat.conversations!.first.senderId,
          createdAt: dat.conversations!.first.createdAt,
          updatedAt: dat.conversations!.first.updatedAt,
          sender: dat.conversations!.first.sender,
          media: dat.conversations!.first.media,
          determineId: dat.id,
        );

        chatAdd.conversations!.insert(0, toBeAdded);

        ChatData newChat = chatAdd;
        // allowed(true);
        addMsg(toBeAdded);

        for (var i = 0; i < tempData.length; i++) {
          List<ChatData> forCheck =
              tempData.where((element) => element.id == dat.id).toList();
          if (tempData[i].id == dat.id) {
            tempData.removeAt(i);
            tempData.add(newChat);
            _chatList = [];
            _chatList.clear();
            _chatList = tempData;
            notifyListeners();
          } else {}

          // if(forCheck.isNotEmpty){

          // }
        }
      });
    } else {
      ChatData chatAdd =
          tempData.where((element) => element.id == dat!.id).first;
      Conversation toBeAdded = Conversation(
        id: dat!.conversations!.first.id,
        body: dat.conversations!.first.body,
        read: dat.conversations!.first.read,
        senderId: dat.conversations!.first.senderId,
        createdAt: dat.conversations!.first.createdAt,
        updatedAt: dat.conversations!.first.updatedAt,
        sender: dat.conversations!.first.sender,
        media: dat.conversations!.first.media,
        determineId: dat.id,
      );

      chatAdd.conversations!.insert(0, toBeAdded);

      ChatData newChat = chatAdd;
      // allowed(true);
      addMsg(toBeAdded);

      for (var i = 0; i < tempData.length; i++) {
        List<ChatData> forCheck =
            tempData.where((element) => element.id == dat.id).toList();
        if (tempData[i].id == dat.id) {
          tempData.removeAt(i);
          tempData.add(newChat);
          _chatList = [];
          _chatList.clear();
          _chatList = tempData;
          notifyListeners();
        } else {}

        // if(forCheck.isNotEmpty){

        // }
      }
    }

    // _chatList
    //     .where((element) {
    //       return element.id == dat!.id;
    //     })
    //     .toList()
    //     .first
    //     .conversations!
    //     .addAll(dat!.conversations!);

    // dat.conversations!.forEach((element) async {
    // Conversation data = Conversation(
    //   id: dat.conversations!.first.id,
    //   body: dat.conversations!.first.body,
    //   read: dat.conversations!.first.read,
    //   senderId: dat.conversations!.first.senderId,
    //   createdAt: dat.conversations!.first.createdAt,
    //   updatedAt: dat.conversations!.first.updatedAt,
    //   sender: dat.conversations!.first.sender,
    //   media: dat.conversations!.first.media,
    //   determineId: dat.id,
    // );

    //   });

    notifyListeners();
  }

  void addSocket(IO.Socket? soc) {
    socket = soc;
    notifyListeners();
  }

  void addReturn(ret) {
    messageReturn = ret;
    notifyListeners();
  }

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

  bool allow = true;
  Future addMsg(
    Conversation msg,
  ) async {
    // emitter(msg.createdAt);

    List<Conversation> find =
        justChat.where((element) => element.id == msg.id).toList();
    if (justChat.isEmpty) {
      justChat.insert(0, msg);
    } else {
      if (justChat[0].body == msg.body &&
          "${justChat[0].updatedAt!.year}-${justChat[0].updatedAt!.month}-${justChat[0].updatedAt!.day} ${justChat[0].updatedAt!.hour}:${justChat[0].updatedAt!.minute} ${justChat[0].updatedAt!.second}" ==
              "${msg.updatedAt!.year}-${msg.updatedAt!.month}-${msg.updatedAt!.day} ${msg.updatedAt!.hour}:${msg.updatedAt!.minute} ${msg.updatedAt!.second}" &&
          "${justChat[0].updatedAt!.year}-${justChat[0].updatedAt!.month}-${justChat[0].updatedAt!.day} ${justChat[0].updatedAt!.hour}:${justChat[0].updatedAt!.minute} ${justChat[0].updatedAt!.second}.${msg.updatedAt!.millisecond}" ==
              "${msg.updatedAt!.year}-${msg.updatedAt!.month}-${msg.updatedAt!.day} ${msg.updatedAt!.hour}:${msg.updatedAt!.minute} ${msg.updatedAt!.second}.${msg.updatedAt!.millisecond}" &&
          find.isEmpty) {
      } else {
        // if (allow == true) {
        justChat.insert(0, msg);
        texted(true);
        //  allowed(false);
        //  } else {}
      }
    }

    notifyListeners();
  }

  void allowed(bool val) {
    allow = val;
    notifyListeners();
  }

  Future addAllMsg(List<Conversation> msg, id) async {
    //final List<Conversation> hold = justChat;
    List<Conversation> hold = [];
    justChat.clear();
    await Future.forEach(msg, (element) async {
      Conversation data = Conversation(
        id: element.id,
        body: element.body,
        read: element.read,
        senderId: element.senderId,
        createdAt: element.createdAt,
        updatedAt: element.updatedAt,
        sender: element.sender,
        media: element.media,
        determineId: id,
      );
      hold.add(data);
    })
        .whenComplete(() => justChat.addAll(hold))
        .whenComplete(() => hold.clear());

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

  Future<bool> getChatFromApi(
      [bool? isChatPage, int? pageNum, bool? isPaginated]) async {
    late bool isSuccessful;
    // log("page $pageNum");
    try {
      http.Response? response = await getAllConversation(pageNum ?? 1)
          .whenComplete(() => emitter("chats gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("chats request failed");
      } else if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);

        var incomingData = AllConversationModel.fromJson(jsonData);
        if (isPaginated == true) {
          for (ChatData value in incomingData.data!) {
            var lister =
                _chatList.where((element) => element.id == value.id).toList();

            if (lister.isEmpty) {
              _chatList.add(value);
            } else {}
          }
          //_chatList.addAll(incomingData.data!);
          _holdingChatList = _holdingChatList;
        } else {
          if (isChatPage == false) {
            _chatList = incomingData.data!;
            _holdingChatList = incomingData.data!;
          } else {
            _holdingChatList = incomingData.data!;
          }
        }

        initialConverstation = incomingData;
        //  _holdingChatList = incomingData.data!;

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
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getAllUnreadFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUnreadChat()
          .whenComplete(() => emitter("unread gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("chats request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = UnreadChatModel.fromJson(jsonData);
        unreadMsgs = incomingData.data!;
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

  Future<bool> readAllFromApi(int userId) async {
    late bool isSuccessful;
    try {
      http.Response? response = await readAllChats(userId)
          .whenComplete(() => emitter("read all successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("chats request failed");
      } else if (response.statusCode == 200) {
        getAllUnreadFromApi();

        var jsonData = jsonDecode(response.body);

        // var incomingData = UnreadChatModel.fromJson(jsonData);
        // unreadMsgs = incomingData.data!;
        // message = jsonData["message"];

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

  // Future<bool> getChatFromApi2() async {
  //   late bool isSuccessful;
  //   try {
  //     http.Response? response = await getAllConversation(1)
  //         .whenComplete(() => emitter("chats gotten successfully"));
  //     if (response == null) {
  //       isSuccessful = false;
  //       // log("chats request failed");
  //     } else if (response.statusCode == 201) {
  //       print("omooooooooo");
  //       var jsonData = jsonDecode(response.body);

  //       var incomingData = AllConversationModel.fromJson(jsonData);
  //       chatList2 = incomingData.data!;
  //       _chatList = incomingData.data!;
  //       message = jsonData["message"];

  //       log(incomingData.data!.first.userTwo!);
  //       isSuccessful = true;
  //     } else {
  //       //  log("chats  request failed");
  //       isSuccessful = false;
  //     }
  //   } catch (e) {
  //     isSuccessful = false;
  //     // log("chats  request failed");
  //     log(e.toString());
  //   }

  //   notifyListeners();

  //   return isSuccessful;
  // }

  void addUser(List<SockerUserModel> val) async {
    allSocketUsers.clear();
    allSocketUsers.addAll(val);
    // val.forEach((element) {
    //   List<SockerUserModel> dat = allSocketUsers
    //       .where((value) => value.userId == element.userId)
    //       .toList();
    //   if (dat.isEmpty) {
    //     allSocketUsers.add(element);
    //   } else {
    //     allSocketUsers.removeWhere((el) => el.userId == element.userId);
    //     allSocketUsers.add(element);
    //   }
    // });

    notifyListeners();
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
        messageReturn = res.body;
        emitter(
            "THIS IS WHAT WILL BE SENT TO THE SOCKET ${messageReturn.toString()}");
        //  emitter(jsonData.ToString());
        //  log(jsonData["message"]);
        emitter("message sent successfully");
        getChatFromApi(chatPage == 1 ? false : true, 1, false);
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

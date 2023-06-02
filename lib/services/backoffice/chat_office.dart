import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/model/conversation_model.dart';
import 'package:makanaki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<http.StreamedResponse?> sendMessageTo(
  SendMsgModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  var filePhoto;

  final filePhotoName = basename(data.media == null ? '' : data.media!.path);
  // List<dynamic> photo = [filePhotoName];

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/chat/send/to/${data.username}"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };

  if (data.media != null) {
    filePhoto = await http.MultipartFile.fromPath('media', data.media!.path,
        filename: filePhotoName);
  }
  emitter("here is the body ${data.body}");
  request.headers.addAll(headers);
  request.fields["body"] = data.body!;
  if (data.media != null) {
    request.files.add(filePhoto);
  }

  try {
    response = await request.send().timeout(const Duration(seconds: 30));
  } catch (e) {
    //  log("hello");
    //  log(e.toString());
    response = null;
  }

  return response;
}

Future<http.Response?> getAllConversation() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/chat/get/all'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    //
    // log(response.body.toString());
  } catch (e) {
    response = null;
    log(e.toString());
  }
  return response;
}

late IO.Socket socket;
StreamSocket streamSocket = StreamSocket();

class chatSocket {
  static Future<void> initSocket() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(tokenKey);
    socket = IO.io(
        "https://chat.macanacki.com/socket-chat-message?addUserId=16",
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"Authorization": "$token"})
            .enableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {
      // socket.emit("addUserId", {'addUserId': '16'});
      print('Connection established');
    });

    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
    socket.onDisconnect((_) => print('Connection Disconnection'));
  }

  static Future<void> addUserId(
    String userId,
  ) async {
    try {
      socket.emit("addUserId", userId);
    } catch (e) {
      print(e);
    }
  }

  static void send(String userId, String friendId, String message) async {
    Map messageMap = {
      'from': userId,
      'to': friendId,
      'message': message,
    };
    try {
      print("sending");
      socket.emitWithAck("sendMesage", messageMap, ack: (data) {
        print("ack");
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    } catch (e) {
      emitter(e.toString());
    }
  }

  static sendTyping(String friendId, bool action) async {
    socket.emit("typing", {"to": friendId, 'action': action});
  }

  static Future<void> getMsgs() async {
    try {
      socket.on('getMessages', (response) {
        //streamSocket.addResponse(response);
        emitter(response.toString());
        //messageList.add(MessageModel.fromJson(data));
      });
    } catch (e) {
      print(e);
    }
  }

  static getNotification() async {
    socket.on('getNotification', (response) {
      emitter(response.toString());
    });
  }

  static getTyping() async {
    socket.on('typingResponse', (response) {
      emitter(response.toString());
    });
  }

  static getUser() async {
    socket.on('getUsers', (response) {
      emitter(response.toString());
    });
  }

  static getNoNetwork() async {
    socket.on('noNetwork', (response) {
      emitter(response.toString());
    });
  }
}

class StreamSocket {
  static final socketResponse = StreamController<String>();

  void Function(String) get addResponse => socketResponse.sink.add;

  Stream<String> get getResponse => socketResponse.stream;

  void dispose() {
    socketResponse.close();
  }
}

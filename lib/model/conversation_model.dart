// To parse this JSON data, do
//
//     final allConversationModel = allConversationModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

AllConversationModel allConversationModelFromJson(String str) =>
    AllConversationModel.fromJson(json.decode(str));

String allConversationModelToJson(AllConversationModel data) =>
    json.encode(data.toJson());

class AllConversationModel {
  AllConversationModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<ChatData>? data;

  factory AllConversationModel.fromJson(Map<String, dynamic> json) =>
      AllConversationModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ChatData>.from(
                json["data"]!.map((x) => ChatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChatData {
  ChatData({
    this.id,
    this.status,
    this.blockedBy,
    this.createdAt,
    this.updatedAt,
    this.userOne,
    this.userOneId,
    this.userOneMode,
    this.userOneVerify,
    this.userOneProfilePhoto,
    this.userTwo,
    this.userTwoId,
    this.userTwoMode,
    this.userTwoVerify,
    this.userTwoProfilePhoto,
    this.conversations,
  });

  int? id;
  dynamic status;
  dynamic blockedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userOne;
  int? userOneId;
  String? userOneMode;
  int? userOneVerify;
  String? userOneProfilePhoto;
  String? userTwo;
  String? userTwoMode;
  int? userTwoId;
  int? userTwoVerify;
  String? userTwoProfilePhoto;
  List<Conversation>? conversations;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        id: json["id"],
        status: json["status"],
        blockedBy: json["blocked_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userOne: json["user_one"],
        userOneId: json["user_one_id"],
        userOneMode: json["user_one_mode"],
        userOneVerify: json["user_one_verify"],
        userOneProfilePhoto: json["user_one_profile_photo"],
        userTwo: json["user_two"],
        userTwoId: json["user_two_id"],
        userTwoMode: json["user_two_mode"],
        userTwoVerify: json["user_two_verify"],
        userTwoProfilePhoto: json["user_two_profile_photo"],
        conversations: json["conversations"] == null
            ? []
            : List<Conversation>.from(
                json["conversations"]!.map((x) => Conversation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "blocked_by": blockedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user_one": userOne,
        "user_one_id": userOneId,
        "user_one_mode": userOneMode,
        "user_one_verify": userOneVerify,
        "user_one_profile_photo": userOneProfilePhoto,
        "user_two": userTwo,
        "user_two_id": userTwoId,
        "user_two_mode": userTwoMode,
        "user_two_verify": userTwoVerify,
        "user_two_profile_photo": userTwoProfilePhoto,
        "conversations": conversations == null
            ? []
            : List<dynamic>.from(conversations!.map((x) => x.toJson())),
      };
}

class Conversation {
  Conversation({
    this.id,
    this.body,
    this.read,
    this.senderId,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.media,
    this.determineId
  });

  int? id;
  String? body;
  dynamic read;
  int? senderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? sender;
  String? media;
  int? determineId;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        body: json["body"],
        read: json["read"],
        senderId: json["sender_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        sender: json["sender"],
        media: json["media"],
         determineId: json["determineId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "read": read,
        "sender_id": senderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sender": sender,
        "media": media,
        "determineId": determineId,
      };
}

class SendMsgModel {
  String? body;
  File? media;
  String? username;

  SendMsgModel({this.body, this.media, this.username});
}

// To parse this JSON data, do
//
//     final unreadChatModel = unreadChatModelFromJson(jsonString);

UnreadChatModel unreadChatModelFromJson(String str) =>
    UnreadChatModel.fromJson(json.decode(str));

String unreadChatModelToJson(UnreadChatModel data) =>
    json.encode(data.toJson());

class UnreadChatModel {
  bool? status;
  String? message;
  List<UnreadData>? data;

  UnreadChatModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnreadChatModel.fromJson(Map<String, dynamic> json) =>
      UnreadChatModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<UnreadData>.from(
                json["data"]!.map((x) => UnreadData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UnreadData {
  int? senderId;
  int? totalUnread;

  UnreadData({
    this.senderId,
    this.totalUnread,
  });

  factory UnreadData.fromJson(Map<String, dynamic> json) => UnreadData(
        senderId: json["sender_id"],
        totalUnread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "total_unread": totalUnread,
      };
}

// To parse this JSON data, do
//
//     final sockerUserModel = sockerUserModelFromJson(jsonString);

List<SockerUserModel> sockerUserModelFromJson(dynamic str) =>
    List<SockerUserModel>.from(
        jsonDecode(jsonEncode(str)).map((x) => SockerUserModel.fromJson(x)));

String sockerUserModelToJson(List<SockerUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SockerUserModel {
  dynamic socketId;
  dynamic userId;

  SockerUserModel({
    this.socketId,
    this.userId,
  });

  factory SockerUserModel.fromJson(Map<String, dynamic> json) =>
      SockerUserModel(
        socketId: json['socketId'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        'socketId': socketId,
        'userId': userId,
      };
}

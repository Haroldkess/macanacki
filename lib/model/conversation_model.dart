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
    this.userOneMode,
    this.userOneProfilePhoto,
    this.userTwo,
    this.userTwoMode,
    this.userTwoProfilePhoto,
    this.conversations,
  });

  int? id;
  int? status;
  dynamic blockedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userOne;
  String? userOneMode;
  String? userOneProfilePhoto;
  String? userTwo;
  String? userTwoMode;
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
             userOneMode: json["user_one_mode"],
        userOneProfilePhoto: json["user_one_profile_photo"],
        userTwo: json["user_two"],
         userTwoMode: json["user_two_mode"],
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
         "user_one_mode": userOneMode,
        "user_one_profile_photo": userOneProfilePhoto,
        "user_two": userTwo,
           "user_two_mode": userTwoMode,
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
  });

  int? id;
  String? body;
  dynamic read;
  int? senderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? sender;
  String? media;

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
      };
}

class SendMsgModel {
  String? body;
  File? media;
  String? username;

  SendMsgModel({this.body, this.media, this.username});
}

// To parse this JSON data, do
//
//     final likededModel = likededModelFromJson(jsonString);

import 'dart:convert';

LikededModel likededModelFromJson(String str) => LikededModel.fromJson(json.decode(str));

String likededModelToJson(LikededModel data) => json.encode(data.toJson());

class LikededModel {
    LikededModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<AllLikedData>? data;

    factory LikededModel.fromJson(Map<String, dynamic> json) => LikededModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<AllLikedData>.from(json["data"]!.map((x) => AllLikedData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class AllLikedData {
    AllLikedData({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.username,
        this.profilePhoto,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? username;
    String? profilePhoto;

    factory AllLikedData.fromJson(Map<String, dynamic> json) => AllLikedData(
        id: json["post_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        username: json["username"],
        profilePhoto: json["profile_photo"],
    );

    Map<String, dynamic> toJson() => {
        "post_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "profile_photo": profilePhoto,
    };
}

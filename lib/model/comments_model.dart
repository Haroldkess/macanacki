// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

CommentsModel commentsModelFromJson(String str) =>
    CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  CommentsModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  CommentData? data;

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : CommentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class CommentData {
  CommentData({
    this.id,
    this.description,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.creator,
    this.media,
    this.comments,
    this.user,
  });

  int? id;
  String? description;
  int? published;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? creator;
  List<String>? media;
  List<CommentInfo>? comments;
  User? user;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        creator: json["creator"],
             media: json["media"] == null ? [] : List<String>.from(json["media"]!.map((x) => x)),
        comments: json["comments"] == null
            ? []
            : List<CommentInfo>.from(
                json["comments"]!.map((x) => CommentInfo.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "creator": creator,
         "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}

class CommentInfo {
  CommentInfo({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.profilePhoto,
    this.noOfLikes,
  });

  int? id;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? username;
  String? profilePhoto;
  int? noOfLikes;

  factory CommentInfo.fromJson(Map<String, dynamic> json) => CommentInfo(
        id: json["id"],
        body: json["body"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        username: json["username"],
        profilePhoto: json["profile_photo"],
        noOfLikes: json["no_of_likes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "profile_photo": profilePhoto,
        "no_of_likes": noOfLikes,
      };
}

class User {
  User({
    this.id,
    this.email,
    this.username,
    this.faceVerification,
    this.dob,
    this.emailVerified,
    this.registrationComplete,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.gender,
    this.verified,
    this.profilephoto,
    this.noOfFollowers,
    this.noOfFollowing,
  });

  int? id;
  String? email;
  String? username;
  int? faceVerification;
  String? dob;
  int? emailVerified;
  int? registrationComplete;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? gender;
    dynamic verified;
  String? profilephoto;
  int? noOfFollowers;
  int? noOfFollowing;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        faceVerification: json["face_verification"],
        dob: json["dob"],
        emailVerified: json["email_verified"],
        registrationComplete: json["registration_complete"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        gender: json["gender"],
            verified: json["verified"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "face_verification": faceVerification,
        "dob": dob,
        "email_verified": emailVerified,
        "registration_complete": registrationComplete,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "gender": gender,
          "verified": verified,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
      };
}






class LikedCommentModel {
    LikedCommentModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<LikedCommentData>? data;

    factory LikedCommentModel.fromJson(Map<String, dynamic> json) => LikedCommentModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<LikedCommentData>.from(json["data"]!.map((x) => LikedCommentData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class LikedCommentData {
    LikedCommentData({
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

    factory LikedCommentData.fromJson(Map<String, dynamic> json) => LikedCommentData(
        id: json["comment_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        username: json["username"],
        profilePhoto: json["profile_photo"],
    );

    Map<String, dynamic> toJson() => {
        "comment_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "profile_photo": profilePhoto,
    };
}

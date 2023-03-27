// To parse this JSON data, do
//
//     final followingModel = followingModelFromJson(jsonString);

import 'dart:convert';

FollowingModel followingModelFromJson(String str) => FollowingModel.fromJson(json.decode(str));

String followingModelToJson(FollowingModel data) => json.encode(data.toJson());

class FollowingModel {
    FollowingModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<FollowingData>? data;

    factory FollowingModel.fromJson(Map<String, dynamic> json) => FollowingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FollowingData>.from(json["data"]!.map((x) => FollowingData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class FollowingData {
    FollowingData({
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
    String? profilephoto;
    int? noOfFollowers;
    int? noOfFollowing;

    factory FollowingData.fromJson(Map<String, dynamic> json) => FollowingData(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        faceVerification: json["face_verification"],
        dob: json["dob"],
        emailVerified: json["email_verified"],
        registrationComplete: json["registration_complete"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        gender: json["gender"],
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
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
    };
}

// To parse this JSON data, do
//
//     final publicProfileModel = publicProfileModelFromJson(jsonString);

import 'dart:convert';

PublicProfileModel publicProfileModelFromJson(String str) =>
    PublicProfileModel.fromJson(json.decode(str));

String publicProfileModelToJson(PublicProfileModel data) =>
    json.encode(data.toJson());

class PublicProfileModel {
  PublicProfileModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  PublicUserData? data;

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) =>
      PublicProfileModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : PublicUserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PublicUserPost {
  PublicUserPost({
    this.id,
    this.description,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.btnLink,
    this.creator,
    this.media,
    this.comments,
    this.noOfLikes,
    this.viewCount,
    this.button,
    this.user,
  });

  int? id;
  String? description;
  int? published;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? btnLink;
  String? creator;
  String? media;
  List<PublicComment>? comments;
  int? noOfLikes;
  int? viewCount;
  String? button;
  PublicUserData? user;

  factory PublicUserPost.fromJson(Map<String, dynamic> json) => PublicUserPost(
        id: json["id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        btnLink: json["btn_link"],
        creator: json["creator"],
        media: json["media"],
        comments: json["comments"] == null
            ? []
            : List<PublicComment>.from(
                json["comments"]!.map((x) => PublicComment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        viewCount: json["view_count"],
        button: json["button"],
        user:
            json["user"] == null ? null : PublicUserData.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "btn_link": btnLink,
        "creator": creator,
        "media": media,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "no_of_likes": noOfLikes,
        "view_count": viewCount,
        "button": button,
        "user": user?.toJson(),
      };
}

class PublicUserData {
  PublicUserData({
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
    this.firebaseId,
    this.longitude,
    this.latitude,
    this.mode,
    this.ageLowerBound,
    this.ageUpperBound,
    this.useCurrentLocation,
    this.useGlobalLocationSearch,
    this.enablePushNotification,
    this.enableEmailNotification,
    this.setMaxDistSearch,
    this.twitter,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.telegram,
    this.fullName,
    this.nationality,
    this.idType,
    this.idNumber,
    this.verified,
    this.aboutMe,
    this.phone,
    this.posts,
    this.followers,
    this.followings,
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
  String? firebaseId;
  String? longitude;
  String? latitude;
  String? mode;
  dynamic ageLowerBound;
  dynamic ageUpperBound;
  int? useCurrentLocation;
  int? useGlobalLocationSearch;
  int? enablePushNotification;
  int? enableEmailNotification;
  String? setMaxDistSearch;
  String? twitter;
  String? facebook;
  String? instagram;
  String? linkedin;
  String? telegram;
  String? fullName;
  String? nationality;
  String? idType;
  String? idNumber;
  int? verified;
  String? aboutMe;
  String? phone;
  List<PublicUserPost>? posts;
  List<PublicUserData>? followers;
  List<PublicUserData>? followings;
  String? gender;
  String? profilephoto;
  int? noOfFollowers;
  int? noOfFollowing;

  factory PublicUserData.fromJson(Map<String, dynamic> json) => PublicUserData(
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
        firebaseId: json["firebase_id"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        mode: json["mode"],
        ageLowerBound: json["age_lower_bound"],
        ageUpperBound: json["age_upper_bound"],
        useCurrentLocation: json["use_current_location"],
        useGlobalLocationSearch: json["use_global_location_search"],
        enablePushNotification: json["enable_push_notification"],
        enableEmailNotification: json["enable_email_notification"],
        setMaxDistSearch: json["set_max_dist_search"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        telegram: json["telegram"],
        fullName: json["full_name"],
        nationality: json["nationality"],
        idType: json["id_type"],
        idNumber: json["id_number"],
        verified: json["verified"],
        aboutMe: json["about_me"],
        phone: json["phone"],
        posts: json["posts"] == null
            ? []
            : List<PublicUserPost>.from(
                json["posts"]!.map((x) => PublicUserPost.fromJson(x))),
        followers: json["followers"] == null
            ? []
            : List<PublicUserData>.from(
                json["followers"]!.map((x) => PublicUserData.fromJson(x))),
        followings: json["followings"] == null
            ? []
            : List<PublicUserData>.from(
                json["followings"]!.map((x) => PublicUserData.fromJson(x))),
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
        "firebase_id": firebaseId,
        "longitude": longitude,
        "latitude": latitude,
        "mode": mode,
        "age_lower_bound": ageLowerBound,
        "age_upper_bound": ageUpperBound,
        "use_current_location": useCurrentLocation,
        "use_global_location_search": useGlobalLocationSearch,
        "enable_push_notification": enablePushNotification,
        "enable_email_notification": enableEmailNotification,
        "set_max_dist_search": setMaxDistSearch,
        "twitter": twitter,
        "facebook": facebook,
        "instagram": instagram,
        "linkedin": linkedin,
        "telegram": telegram,
        "full_name": fullName,
        "nationality": nationality,
        "id_type": idType,
        "id_number": idNumber,
        "verified": verified,
        "about_me": aboutMe,
        "phone": phone,
        "posts": posts == null
            ? []
            : List<dynamic>.from(posts!.map((x) => x.toJson())),
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x.toJson())),
        "followings": followings == null
            ? []
            : List<dynamic>.from(followings!.map((x) => x.toJson())),
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
      };
}

class PublicComment {
  PublicComment({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.profilePhoto,
    this.noOfLikes,
    this.postId,
  });

  int? id;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? username;
  String? profilePhoto;
  int? noOfLikes;
  int? postId;

  factory PublicComment.fromJson(Map<String, dynamic> json) => PublicComment(
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
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "profile_photo": profilePhoto,
        "no_of_likes": noOfLikes,
        "post_id": postId,
      };
}

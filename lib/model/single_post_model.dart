// To parse this JSON data, do
//
//     final singleFeedPostModel = singleFeedPostModelFromJson(jsonString);

import 'dart:convert';

SingleFeedPostModel singleFeedPostModelFromJson(String str) =>
    SingleFeedPostModel.fromJson(json.decode(str));

String singleFeedPostModelToJson(SingleFeedPostModel data) =>
    json.encode(data.toJson());

class SingleFeedPostModel {
  bool? status;
  String? message;
  Data? data;

  SingleFeedPostModel({
    this.status,
    this.message,
    this.data,
  });

  factory SingleFeedPostModel.fromJson(Map<String, dynamic> json) =>
      SingleFeedPostModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? userId;
  String? description;
  dynamic published;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic btnLink;
  dynamic btnId;
  String? creator;
  List<String>? media;
  List<String>? mux;
  List<dynamic>? vod;
  List<dynamic>? thumbnails;
  List<Comment>? comments;
  int? noOfLikes;
  int? viewCount;
  dynamic button;
  SingleUser? user;
  String? promoted;

  Data({
    this.id,
    this.userId,
    this.description,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.btnLink,
    this.btnId,
    this.creator,
    this.media,
    this.mux,
    this.vod,
    this.thumbnails,
    this.comments,
    this.noOfLikes,
    this.viewCount,
    this.button,
    this.user,
    this.promoted,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        btnLink: json["btn_link"],
        btnId: json["btn_id"],
        creator: json["creator"],
        media: json["media"] == null
            ? []
            : List<String>.from(json["media"]!.map((x) => x)),
        mux: json["mux"] == null
            ? []
            : List<String>.from(json["mux"]!.map((x) => x)),
        vod: json["vod"] == null
            ? []
            : List<dynamic>.from(json["vod"]!.map((x) => x)),
        thumbnails: json["thumbnails"] == null
            ? []
            : List<dynamic>.from(json["thumbnails"]!.map((x) => x)),
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        viewCount: json["view_count"],
        button: json["button"],
        user: json["user"] == null ? null : SingleUser.fromJson(json["user"]),
        promoted: json["promoted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "description": description,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "btn_link": btnLink,
        "btn_id": btnId,
        "creator": creator,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "mux": mux == null ? [] : List<dynamic>.from(mux!.map((x) => x)),
        "vod": vod == null ? [] : List<dynamic>.from(vod!.map((x) => x)),
        "thumbnails": thumbnails == null
            ? []
            : List<dynamic>.from(thumbnails!.map((x) => x)),
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "no_of_likes": noOfLikes,
        "view_count": viewCount,
        "button": button,
        "user": user?.toJson(),
        "promoted": promoted,
      };
}

class SingleUser {
  int? id;
  String? email;
  String? username;
  dynamic faceVerification;
  String? dob;
  dynamic emailVerified;
  dynamic registrationComplete;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? firebaseId;
  String? longitude;
  String? latitude;
  String? mode;
  dynamic ageLowerBound;
  dynamic ageUpperBound;
  dynamic useCurrentLocation;
  dynamic useGlobalLocationSearch;
  dynamic enablePushNotification;
  dynamic enableEmailNotification;
  dynamic setMaxDistSearch;
  dynamic twitter;
  dynamic facebook;
  dynamic instagram;
  dynamic linkedin;
  dynamic telegram;
  dynamic fullName;
  dynamic nationality;
  dynamic idType;
  dynamic idNumber;
  dynamic idFrontCapture;
  dynamic idBackCapture;
  dynamic selfie;
  dynamic verified;
  String? aboutMe;
  String? phone;
  dynamic admin;
  dynamic isSuperAdmin;
  dynamic status;
  String? country;
  String? state;
  String? city;
  dynamic subscriptionExpires;
  dynamic device;
  dynamic celeb;
  dynamic walletBalance;
  String? website;
  String? gender;
  String? profilephoto;
  dynamic noOfFollowers;
  dynamic noOfFollowing;
  String? activePlan;
  dynamic idFront;
  dynamic idBack;
  dynamic verification;
  String? category;
  dynamic promotedProfile;

  SingleUser({
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
    this.idFrontCapture,
    this.idBackCapture,
    this.selfie,
    this.verified,
    this.aboutMe,
    this.phone,
    this.admin,
    this.isSuperAdmin,
    this.status,
    this.country,
    this.state,
    this.city,
    this.subscriptionExpires,
    this.device,
    this.celeb,
    this.walletBalance,
    this.website,
    this.gender,
    this.profilephoto,
    this.noOfFollowers,
    this.noOfFollowing,
    this.activePlan,
    this.idFront,
    this.idBack,
    this.verification,
    this.category,
    this.promotedProfile,
  });

  factory SingleUser.fromJson(Map<String, dynamic> json) => SingleUser(
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
        idFrontCapture: json["id_front_capture"],
        idBackCapture: json["id_back_capture"],
        selfie: json["selfie"],
        verified: json["verified"],
        aboutMe: json["about_me"],
        phone: json["phone"],
        admin: json["admin"],
        isSuperAdmin: json["is_super_admin"],
        status: json["status"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        subscriptionExpires: json["subscription_expires"],
        device: json["device"],
        celeb: json["celeb"],
        walletBalance: json["wallet_balance"],
        website: json["website"],
        gender: json["gender"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"],
        idFront: json["id_front"],
        idBack: json["id_back"],
        verification: json["verification"],
        category: json["category"],
        promotedProfile: json["promoted_profile"],
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
        "id_front_capture": idFrontCapture,
        "id_back_capture": idBackCapture,
        "selfie": selfie,
        "verified": verified,
        "about_me": aboutMe,
        "phone": phone,
        "admin": admin,
        "is_super_admin": isSuperAdmin,
        "status": status,
        "country": country,
        "state": state,
        "city": city,
        "subscription_expires": subscriptionExpires,
        "device": device,
        "celeb": celeb,
        "wallet_balance": walletBalance,
        "website": website,
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
        "active_plan": activePlan,
        "id_front": idFront,
        "id_back": idBack,
        "verification": verification,
        "category": category,
        "promoted_profile": promotedProfile,
      };
}

class Comment {
  Comment({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.profilePhoto,
    this.noOfLikes,
    this.postId,
    this.isVerified,
  });

  int? id;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? username;
  String? profilePhoto;
  int? noOfLikes;
  int? postId;
  int? isVerified;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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
        isVerified: json["user_verified"],
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
        "user_verified": isVerified
      };
}

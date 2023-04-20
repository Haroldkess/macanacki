// To parse this JSON data, do
//
//     final feedPostModel = feedPostModelFromJson(jsonString);

import 'dart:convert';

FeedPostModel feedPostModelFromJson(String str) =>
    FeedPostModel.fromJson(json.decode(str));

String feedPostModelToJson(FeedPostModel data) => json.encode(data.toJson());

class FeedPostModel {
  FeedPostModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  FeedData? data;

  factory FeedPostModel.fromJson(Map<String, dynamic> json) => FeedPostModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : FeedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class FeedData {
  FeedData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<FeedPost>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<FeedPost>.from(
                json["data"]!.map((x) => FeedPost.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class FeedPost {
  FeedPost({
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
  List<Comment>? comments;
  int? noOfLikes;
  int? viewCount;
  String? button;
  User? user;

  factory FeedPost.fromJson(Map<String, dynamic> json) => FeedPost(
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
        creator: json["creator"]!,
        media: json["media"],
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        button: json["button"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
  });

  int? id;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? username;
  String? profilePhoto;
  int? noOfLikes;
  int? postId;

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
    this.gender,
    this.profilephoto,
    this.noOfFollowers,
    this.noOfFollowing,
    this.activePlan,
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
  String? ageLowerBound;
  String? ageUpperBound;
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
  String? gender;
  String? profilephoto;
  int? noOfFollowers;
  int? noOfFollowing;
  dynamic activePlan;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"]!,
        username: json["username"]!,
        faceVerification: json["face_verification"],
        dob: json["dob"]!,
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
        mode: json["mode"]!,
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
        gender: json["gender"]!,
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"],
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
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
        "active_plan": activePlan,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

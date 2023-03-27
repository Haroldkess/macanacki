// To parse this JSON data, do
//
//     final publicProfileModel = publicProfileModelFromJson(jsonString);

import 'dart:convert';

PublicProfileModel publicProfileModelFromJson(String str) => PublicProfileModel.fromJson(json.decode(str));

String publicProfileModelToJson(PublicProfileModel data) => json.encode(data.toJson());

class PublicProfileModel {
    PublicProfileModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    PublicUserData? data;

    factory PublicProfileModel.fromJson(Map<String, dynamic> json) => PublicProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : PublicUserData.fromJson(json["data"]),
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
        this.creator,
        this.media,
        this.comments,
        this.noOfLikes,
        this.user,
    });

    int? id;
    String? description;
    int? published;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? creator;
    String? media;
    List<Comment>? comments;
    int? noOfLikes;
    PublicUserData? user;

    factory PublicUserPost.fromJson(Map<String, dynamic> json) => PublicUserPost(
        id: json["id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        creator: json["creator"],
        media: json["media"],
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        user: json["user"] == null ? null : PublicUserData.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "creator": creator,
        "media": media,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "no_of_likes": noOfLikes,
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
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        posts: json["posts"] == null ? [] : List<PublicUserPost>.from(json["posts"]!.map((x) => PublicUserPost.fromJson(x))),
        followers: json["followers"] == null ? [] : List<PublicUserData>.from(json["followers"]!.map((x) => PublicUserData.fromJson(x))),
        followings: json["followings"] == null ? [] : List<PublicUserData>.from(json["followings"]!.map((x) => PublicUserData.fromJson(x))),
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
        "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
                "followers": followers == null ? [] : List<dynamic>.from(followers!.map((x) => x.toJson())),
        "followings": followings == null ? [] : List<dynamic>.from(followings!.map((x) => x.toJson())),
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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


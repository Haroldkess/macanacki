// To parse this JSON data, do
//
//     final friendsPostModel = friendsPostModelFromJson(jsonString);

import 'dart:convert';

FriendsPostModel friendsPostModelFromJson(String str) => FriendsPostModel.fromJson(json.decode(str));

String friendsPostModelToJson(FriendsPostModel data) => json.encode(data.toJson());

class FriendsPostModel {
    bool? status;
    String? message;
    Data? data;

    FriendsPostModel({
        this.status,
        this.message,
        this.data,
    });

    factory FriendsPostModel.fromJson(Map<String, dynamic> json) => FriendsPostModel(
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
    int? currentPage;
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    List<Link>? links;
    String? nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    int? id;
    int? userId;
    String? description;
    int? published;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? btnLink;
    int? btnId;
    String? creator;
    List<String>? media;
    List<String>? mux;
    List<String?>? thumbnails;
    List<Comment>? comments;
    int? noOfLikes;
    int? viewCount;
    String? button;
    User? user;
    String? promoted;

    Datum({
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
        this.thumbnails,
        this.comments,
        this.noOfLikes,
        this.viewCount,
        this.button,
        this.user,
        this.promoted,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        btnLink: json["btn_link"],
        btnId: json["btn_id"],
        creator: json["creator"],
        media: json["media"] == null ? [] : List<String>.from(json["media"]!.map((x) => x)),
        mux: json["mux"] == null ? [] : List<String>.from(json["mux"]!.map((x) => x)),
        thumbnails: json["thumbnails"] == null ? [] : List<String?>.from(json["thumbnails"]!.map((x) => x)),
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        viewCount: json["view_count"],
        button: json["button"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
        "thumbnails": thumbnails == null ? [] : List<dynamic>.from(thumbnails!.map((x) => x)),
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "no_of_likes": noOfLikes,
        "view_count": viewCount,
        "button": button,
        "user": user?.toJson(),
        "promoted": promoted,
    };
}

class Comment {
    int? id;
    String? body;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? username;
    String? profilePhoto;
    int? noOfLikes;
    int? postId;
    int? userVerified;

    Comment({
        this.id,
        this.body,
        this.createdAt,
        this.updatedAt,
        this.username,
        this.profilePhoto,
        this.noOfLikes,
        this.postId,
        this.userVerified,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        body: json["body"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        username: json["username"],
        profilePhoto: json["profile_photo"],
        noOfLikes: json["no_of_likes"],
        postId: json["post_id"],
        userVerified: json["user_verified"],
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
        "user_verified": userVerified,
    };
}

class User {
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
    int? verified;
    String? aboutMe;
    String? phone;
    int? admin;
    int? isSuperAdmin;
    int? status;
    String? country;
    String? state;
    String? city;
    DateTime? subscriptionExpires;
    String? device;
    int? celeb;
    int? walletBalance;
    String? gender;
    String? profilephoto;
    int? noOfFollowers;
    int? noOfFollowing;
    String? activePlan;
    dynamic idFront;
    dynamic idBack;
    Verification? verification;
    String? category;

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
        this.gender,
        this.profilephoto,
        this.noOfFollowers,
        this.noOfFollowing,
        this.activePlan,
        this.idFront,
        this.idBack,
        this.verification,
        this.category,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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
        subscriptionExpires: json["subscription_expires"] == null ? null : DateTime.parse(json["subscription_expires"]),
        device: json["device"],
        celeb: json["celeb"],
        walletBalance: json["wallet_balance"],
        gender: json["gender"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"],
        idFront: json["id_front"],
        idBack: json["id_back"],
        verification: json["verification"] == null ? null : Verification.fromJson(json["verification"]),
        category: json["category"],
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
        "subscription_expires": "${subscriptionExpires!.year.toString().padLeft(4, '0')}-${subscriptionExpires!.month.toString().padLeft(2, '0')}-${subscriptionExpires!.day.toString().padLeft(2, '0')}",
        "device": device,
        "celeb": celeb,
        "wallet_balance": walletBalance,
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
        "active_plan": activePlan,
        "id_front": idFront,
        "id_back": idBack,
        "verification": verification?.toJson(),
        "category": category,
    };
}

class Verification {
    int? id;
    int? userId;
    String? name;
    dynamic businessName;
    dynamic businessEmail;
    dynamic phone;
    dynamic description;
    dynamic isRegistered;
    dynamic country;
    String? registrationNo;
    dynamic address;
    String? idType;
    String? idNo;
    int? verified;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic businessAddress;
    String? photo;
    dynamic evidence;

    Verification({
        this.id,
        this.userId,
        this.name,
        this.businessName,
        this.businessEmail,
        this.phone,
        this.description,
        this.isRegistered,
        this.country,
        this.registrationNo,
        this.address,
        this.idType,
        this.idNo,
        this.verified,
        this.createdAt,
        this.updatedAt,
        this.businessAddress,
        this.photo,
        this.evidence,
    });

    factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        businessName: json["business_name"],
        businessEmail: json["business_email"],
        phone: json["phone"],
        description: json["description"],
        isRegistered: json["is_registered"],
        country: json["country"],
        registrationNo: json["registration_no"],
        address: json["address"],
        idType: json["id_type"],
        idNo: json["id_no"],
        verified: json["verified"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        businessAddress: json["business_address"],
        photo: json["photo"],
        evidence: json["evidence"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "business_name": businessName,
        "business_email": businessEmail,
        "phone": phone,
        "description": description,
        "is_registered": isRegistered,
        "country": country,
        "registration_no": registrationNo,
        "address": address,
        "id_type": idType,
        "id_no": idNo,
        "verified": verified,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "business_address": businessAddress,
        "photo": photo,
        "evidence": evidence,
    };
}

class Link {
    String? url;
    String? label;
    bool? active;

    Link({
        this.url,
        this.label,
        this.active,
    });

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

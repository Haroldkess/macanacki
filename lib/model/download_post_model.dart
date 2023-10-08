// To parse this JSON data, do
//
//     final downloadModel = downloadModelFromJson(jsonString);

import 'dart:convert';

DownloadModel downloadModelFromJson(String str) => DownloadModel.fromJson(json.decode(str));

String downloadModelToJson(DownloadModel data) => json.encode(data.toJson());

class DownloadModel {
    bool? status;
    String? message;
    Data? data;

    DownloadModel({
        this.status,
        this.message,
        this.data,
    });

    DownloadModel copyWith({
        bool? status,
        String? message,
        Data? data,
    }) => 
        DownloadModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory DownloadModel.fromJson(Map<String, dynamic> json) => DownloadModel(
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
    List<dynamic>? thumbnails;
    List<dynamic>? comments;
   dynamic noOfLikes;
    dynamic viewCount;
    dynamic button;
    User? user;
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
        this.thumbnails,
        this.comments,
        this.noOfLikes,
        this.viewCount,
        this.button,
        this.user,
        this.promoted,
    });

    Data copyWith({
        int? id,
        int? userId,
        String? description,
        int? published,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic btnLink,
        dynamic btnId,
        String? creator,
        List<String>? media,
        List<String>? mux,
        List<dynamic>? thumbnails,
        List<dynamic>? comments,
        int? noOfLikes,
        int? viewCount,
        dynamic button,
        User? user,
        String? promoted,
    }) => 
        Data(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            description: description ?? this.description,
            published: published ?? this.published,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            btnLink: btnLink ?? this.btnLink,
            btnId: btnId ?? this.btnId,
            creator: creator ?? this.creator,
            media: media ?? this.media,
            mux: mux ?? this.mux,
            thumbnails: thumbnails ?? this.thumbnails,
            comments: comments ?? this.comments,
            noOfLikes: noOfLikes ?? this.noOfLikes,
            viewCount: viewCount ?? this.viewCount,
            button: button ?? this.button,
            user: user ?? this.user,
            promoted: promoted ?? this.promoted,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        thumbnails: json["thumbnails"] == null ? [] : List<dynamic>.from(json["thumbnails"]!.map((x) => x)),
        comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
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
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
        "no_of_likes": noOfLikes,
        "view_count": viewCount,
        "button": button,
        "user": user?.toJson(),
        "promoted": promoted,
    };
}

class User {
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
   dynamic  enableEmailNotification;
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
    dynamic  admin;
   dynamic isSuperAdmin;
   dynamic status;
    String? country;
    String? state;
    String? city;
    dynamic subscriptionExpires;
    dynamic device;
    dynamic celeb;
    dynamic walletBalance;
    String? gender;
    String? profilephoto;
    dynamic noOfFollowers;
    dynamic  noOfFollowing;
    String? activePlan;
    dynamic idFront;
    dynamic idBack;
    dynamic verification;
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

    User copyWith({
        int? id,
        String? email,
        String? username,
       dynamic faceVerification,
        String? dob,
       dynamic  emailVerified,
       dynamic registrationComplete,
        DateTime? emailVerifiedAt,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? firebaseId,
        String? longitude,
        String? latitude,
        String? mode,
        dynamic ageLowerBound,
        dynamic ageUpperBound,
        dynamic useCurrentLocation,
       dynamic useGlobalLocationSearch,
       dynamic enablePushNotification,
        dynamic enableEmailNotification,
        dynamic setMaxDistSearch,
        dynamic twitter,
        dynamic facebook,
        dynamic instagram,
        dynamic linkedin,
        dynamic telegram,
        dynamic fullName,
        dynamic nationality,
        dynamic idType,
        dynamic idNumber,
        dynamic idFrontCapture,
        dynamic idBackCapture,
        dynamic selfie,
        int? verified,
        String? aboutMe,
        String? phone,
        int? admin,
        int? isSuperAdmin,
        int? status,
        String? country,
        String? state,
        String? city,
        dynamic subscriptionExpires,
        dynamic device,
        dynamic celeb,
       dynamic walletBalance,
        String? gender,
        String? profilephoto,
      dynamic noOfFollowers,
        dynamic noOfFollowing,
        String? activePlan,
        dynamic idFront,
        dynamic idBack,
        dynamic verification,
        String? category,
    }) => 
        User(
            id: id ?? this.id,
            email: email ?? this.email,
            username: username ?? this.username,
            faceVerification: faceVerification ?? this.faceVerification,
            dob: dob ?? this.dob,
            emailVerified: emailVerified ?? this.emailVerified,
            registrationComplete: registrationComplete ?? this.registrationComplete,
            emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            firebaseId: firebaseId ?? this.firebaseId,
            longitude: longitude ?? this.longitude,
            latitude: latitude ?? this.latitude,
            mode: mode ?? this.mode,
            ageLowerBound: ageLowerBound ?? this.ageLowerBound,
            ageUpperBound: ageUpperBound ?? this.ageUpperBound,
            useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
            useGlobalLocationSearch: useGlobalLocationSearch ?? this.useGlobalLocationSearch,
            enablePushNotification: enablePushNotification ?? this.enablePushNotification,
            enableEmailNotification: enableEmailNotification ?? this.enableEmailNotification,
            setMaxDistSearch: setMaxDistSearch ?? this.setMaxDistSearch,
            twitter: twitter ?? this.twitter,
            facebook: facebook ?? this.facebook,
            instagram: instagram ?? this.instagram,
            linkedin: linkedin ?? this.linkedin,
            telegram: telegram ?? this.telegram,
            fullName: fullName ?? this.fullName,
            nationality: nationality ?? this.nationality,
            idType: idType ?? this.idType,
            idNumber: idNumber ?? this.idNumber,
            idFrontCapture: idFrontCapture ?? this.idFrontCapture,
            idBackCapture: idBackCapture ?? this.idBackCapture,
            selfie: selfie ?? this.selfie,
            verified: verified ?? this.verified,
            aboutMe: aboutMe ?? this.aboutMe,
            phone: phone ?? this.phone,
            admin: admin ?? this.admin,
            isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
            status: status ?? this.status,
            country: country ?? this.country,
            state: state ?? this.state,
            city: city ?? this.city,
            subscriptionExpires: subscriptionExpires ?? this.subscriptionExpires,
            device: device ?? this.device,
            celeb: celeb ?? this.celeb,
            walletBalance: walletBalance ?? this.walletBalance,
            gender: gender ?? this.gender,
            profilephoto: profilephoto ?? this.profilephoto,
            noOfFollowers: noOfFollowers ?? this.noOfFollowers,
            noOfFollowing: noOfFollowing ?? this.noOfFollowing,
            activePlan: activePlan ?? this.activePlan,
            idFront: idFront ?? this.idFront,
            idBack: idBack ?? this.idBack,
            verification: verification ?? this.verification,
            category: category ?? this.category,
        );

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
        subscriptionExpires: json["subscription_expires"],
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
        verification: json["verification"],
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
        "subscription_expires": subscriptionExpires,
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
        "verification": verification,
        "category": category,
    };
}

// To parse this JSON data, do
//
//     final giftDiamondHistory = giftDiamondHistoryFromJson(jsonString);

import 'dart:convert';

GiftDiamondHistory giftDiamondHistoryFromJson(String str) =>
    GiftDiamondHistory.fromJson(json.decode(str));

String giftDiamondHistoryToJson(GiftDiamondHistory data) =>
    json.encode(data.toJson());

class GiftDiamondHistory {
  bool? status;
  String? message;
  List<GifterInfo>? data;

  GiftDiamondHistory({
    this.status,
    this.message,
    this.data,
  });

  factory GiftDiamondHistory.fromJson(Map<String, dynamic> json) =>
      GiftDiamondHistory(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GifterInfo>.from(json["data"]!.map((x) => GifterInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GifterInfo {
  int? id;
  dynamic sourceWalletId;
  dynamic beneficiaryWalletId;
  String? referenceNo;
  String? narration;
  String? other;
  dynamic value;
  int? senderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Sender? sender;

  GifterInfo({
    this.id,
    this.sourceWalletId,
    this.beneficiaryWalletId,
    this.referenceNo,
    this.narration,
    this.other,
    this.value,
    this.senderId,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  factory GifterInfo.fromJson(Map<String, dynamic> json) => GifterInfo(
        id: json["id"],
        sourceWalletId: json["source_wallet_id"],
        beneficiaryWalletId: json["beneficiary_wallet_id"],
        referenceNo: json["reference_no"],
        narration: json["narration"],
        other: json["other"],
        value: json["value"],
        senderId: json["sender_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source_wallet_id": sourceWalletId,
        "beneficiary_wallet_id": beneficiaryWalletId,
        "reference_no": referenceNo,
        "narration": narration,
        "other": other,
        "value": value,
        "sender_id": senderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sender": sender?.toJson(),
      };
}

class Sender {
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
  DateTime? subscriptionExpires;
  String? device;
  dynamic celeb;
  dynamic walletBalance;
  String? gender;
  String? profilephoto;
  dynamic noOfFollowers;
  dynamic noOfFollowing;
  DateTime? activePlan;
  dynamic idFront;
  dynamic idBack;
  dynamic verification;
  String? category;

  Sender({
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

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
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
        subscriptionExpires: json["subscription_expires"] == null
            ? null
            : DateTime.parse(json["subscription_expires"]),
        device: json["device"],
        celeb: json["celeb"],
        walletBalance: json["wallet_balance"],
        gender: json["gender"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"] == null
            ? null
            : DateTime.parse(json["active_plan"]),
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
        "subscription_expires":
            "${subscriptionExpires!.year.toString().padLeft(4, '0')}-${subscriptionExpires!.month.toString().padLeft(2, '0')}-${subscriptionExpires!.day.toString().padLeft(2, '0')}",
        "device": device,
        "celeb": celeb,
        "wallet_balance": walletBalance,
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
        "active_plan":
            "${activePlan!.year.toString().padLeft(4, '0')}-${activePlan!.month.toString().padLeft(2, '0')}-${activePlan!.day.toString().padLeft(2, '0')}",
        "id_front": idFront,
        "id_back": idBack,
        "verification": verification,
        "category": category,
      };
}

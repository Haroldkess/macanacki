// To parse this JSON data, do
//
//     final royalty = royaltyFromJson(jsonString);

import 'dart:convert';

Royalty royaltyFromJson(String str) => Royalty.fromJson(json.decode(str));

String royaltyToJson(Royalty data) => json.encode(data.toJson());

class Royalty {
  bool? status;
  String? message;
  RoyalData? data;

  Royalty({
    this.status,
    this.message,
    this.data,
  });

  factory Royalty.fromJson(Map<String, dynamic> json) => Royalty(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : RoyalData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class RoyalData {
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
  int? celeb;
  int? walletBalance;
  String? website;
  String? gender;
  String? profilephoto;
  dynamic noOfFollowers;
  dynamic noOfFollowing;
  String? activePlan;
  dynamic idFront;
  dynamic idBack;
  Verification? verification;
  String? category;
  dynamic promotedProfile;

  RoyalData({
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

  factory RoyalData.fromJson(Map<String, dynamic> json) => RoyalData(
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
        website: json["website"],
        gender: json["gender"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"],
        idFront: json["id_front"],
        idBack: json["id_back"],
        verification: json["verification"] == null
            ? null
            : Verification.fromJson(json["verification"]),
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
        "subscription_expires":
            "${subscriptionExpires!.year.toString().padLeft(4, '0')}-${subscriptionExpires!.month.toString().padLeft(2, '0')}-${subscriptionExpires!.day.toString().padLeft(2, '0')}",
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
        "verification": verification?.toJson(),
        "category": category,
        "promoted_profile": promotedProfile,
      };
}

class Verification {
  int? id;
  dynamic userId;
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
  dynamic verified;
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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

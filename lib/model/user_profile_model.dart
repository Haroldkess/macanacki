// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  UserData? data;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserData {
  UserData(
      {this.id,
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
      this.gender,
      this.profilephoto,
      this.noOfFollowers,
      this.noOfFollowing,
      this.activePlan,
      this.verification,
      this.country,
      this.state,
      this.city});

  int? id;
  String? email;
  dynamic username;
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
  dynamic verified;
  String? aboutMe;
  String? phone;
  String? gender;
  String? profilephoto;
  int? noOfFollowers;
  int? noOfFollowing;
  dynamic activePlan;
  Verification? verification;
  String? country, state, city;
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
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
        gender: json["gender"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
        activePlan: json["active_plan"],
        verification: json["verification"] == null
            ? null
            : Verification.fromJson(json["verification"]),
        country: json["country"],
        state: json["state"],
        city: json["city"],
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
        "gender": gender,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
        "active_plan": activePlan,
        "verification": verification?.toJson(),
      };
}

class Verification {
  int? id;
  dynamic userId;
  String? name;
  String? businessName;
  String? businessEmail;
  String? phone;
  String? description;
  String? isRegistered;
  String? country;
  String? registrationNo;
  String? address;
  String? idType;
  String? idNo;
  dynamic verified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? businessAddress;
  String? photo;
  String? evidence;

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

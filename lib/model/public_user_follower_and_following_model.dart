class PublicUserFollowerAndFollowingModel {
  int? id;
  String? email;
  String? username;
  int? faceVerification;
  String? dob;
  int? emailVerified;
  int? registrationComplete;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
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
  dynamic aboutMe;
  dynamic phone;
  int? admin;
  int? isSuperAdmin;
  int? status;
  String? country;
  String? state;
  String? city;
  dynamic subscriptionExpires;
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
  dynamic verification;
  String? category;

  PublicUserFollowerAndFollowingModel(
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
      this.category});

  PublicUserFollowerAndFollowingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    faceVerification = json['face_verification'];
    dob = json['dob'];
    emailVerified = json['email_verified'];
    registrationComplete = json['registration_complete'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firebaseId = json['firebase_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    mode = json['mode'];
    ageLowerBound = json['age_lower_bound'];
    ageUpperBound = json['age_upper_bound'];
    useCurrentLocation = json['use_current_location'];
    useGlobalLocationSearch = json['use_global_location_search'];
    enablePushNotification = json['enable_push_notification'];
    enableEmailNotification = json['enable_email_notification'];
    setMaxDistSearch = json['set_max_dist_search'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    linkedin = json['linkedin'];
    telegram = json['telegram'];
    fullName = json['full_name'];
    nationality = json['nationality'];
    idType = json['id_type'];
    idNumber = json['id_number'];
    idFrontCapture = json['id_front_capture'];
    idBackCapture = json['id_back_capture'];
    selfie = json['selfie'];
    verified = json['verified'];
    aboutMe = json['about_me'];
    phone = json['phone'];
    admin = json['admin'];
    isSuperAdmin = json['is_super_admin'];
    status = json['status'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    subscriptionExpires = json['subscription_expires'];
    device = json['device'];
    celeb = json['celeb'];
    walletBalance = json['wallet_balance'];
    gender = json['gender'];
    profilephoto = json['profilephoto'];
    noOfFollowers = json['no_of_followers'];
    noOfFollowing = json['no_of_following'];
    activePlan = json['active_plan'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    verification = json['verification'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['face_verification'] = this.faceVerification;
    data['dob'] = this.dob;
    data['email_verified'] = this.emailVerified;
    data['registration_complete'] = this.registrationComplete;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['firebase_id'] = this.firebaseId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['mode'] = this.mode;
    data['age_lower_bound'] = this.ageLowerBound;
    data['age_upper_bound'] = this.ageUpperBound;
    data['use_current_location'] = this.useCurrentLocation;
    data['use_global_location_search'] = this.useGlobalLocationSearch;
    data['enable_push_notification'] = this.enablePushNotification;
    data['enable_email_notification'] = this.enableEmailNotification;
    data['set_max_dist_search'] = this.setMaxDistSearch;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['linkedin'] = this.linkedin;
    data['telegram'] = this.telegram;
    data['full_name'] = this.fullName;
    data['nationality'] = this.nationality;
    data['id_type'] = this.idType;
    data['id_number'] = this.idNumber;
    data['id_front_capture'] = this.idFrontCapture;
    data['id_back_capture'] = this.idBackCapture;
    data['selfie'] = this.selfie;
    data['verified'] = this.verified;
    data['about_me'] = this.aboutMe;
    data['phone'] = this.phone;
    data['admin'] = this.admin;
    data['is_super_admin'] = this.isSuperAdmin;
    data['status'] = this.status;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['subscription_expires'] = this.subscriptionExpires;
    data['device'] = this.device;
    data['celeb'] = this.celeb;
    data['wallet_balance'] = this.walletBalance;
    data['gender'] = this.gender;
    data['profilephoto'] = this.profilephoto;
    data['no_of_followers'] = this.noOfFollowers;
    data['no_of_following'] = this.noOfFollowing;
    data['active_plan'] = this.activePlan;
    data['id_front'] = this.idFront;
    data['id_back'] = this.idBack;
    data['verification'] = this.verification;
    data['category'] = this.category;
    return data;
  }
}

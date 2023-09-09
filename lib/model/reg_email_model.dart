import 'dart:io';

class SendEmailModel {
  String? email;

  SendEmailModel({required this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    return data;
  }
}

class SendUserNameModel {
  String? email;
  String? userName;

  SendUserNameModel({required this.email, required this.userName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["username"] = userName;
    data["email"] = email;
    return data;
  }
}

class SendLoginModel {
  String? userName;
  String? password;
  String? token;
  String? latitude;
  String? longitude;

  SendLoginModel(
      {required this.userName,
      required this.password,
      required this.token,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["username"] = userName;
    data["password"] = password;
    data["firebase_id"] = token;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["device"] = Platform.isIOS
        ? "IOS"
        : Platform.isAndroid
            ? "ANDROID"
            : Platform.isFuchsia
                ? "Fuchsia".toUpperCase()
                : "";
    return data;
  }
}

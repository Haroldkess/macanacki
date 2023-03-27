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

  SendLoginModel({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["username"] = userName;
    data["password"] = password;
    return data;
  }
}


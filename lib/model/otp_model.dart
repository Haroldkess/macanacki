class OtpModel {
  String? email;
  String? otp;

  OtpModel({required this.otp, required this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["otp"] = otp;

    return data;
  }
}

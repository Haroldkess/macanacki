// To parse this JSON data, do
//
//     final dethroneModel = dethroneModelFromJson(jsonString);

import 'dart:convert';

VerificationLink verificationLinkModelFromJson(String str) =>
    VerificationLink.fromJson(json.decode(str));

String verificationLinkModelToJson(VerificationLink data) =>
    json.encode(data.toJson());

class VerificationLink {
  bool? status;
  String? message;
  String? paymentLink;

  VerificationLink({
    this.status,
    this.message,
    this.paymentLink,
  });

  factory VerificationLink.fromJson(Map<String, dynamic> json) =>
      VerificationLink(
        status: json["status"],
        message: json["message"],
        paymentLink: json["payment_link"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payment_link": paymentLink,
      };
}

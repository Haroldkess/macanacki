// To parse this JSON data, do
//
//     final dethroneModel = dethroneModelFromJson(jsonString);

import 'dart:convert';

DiamondLink diamondLinkModelFromJson(String str) =>
    DiamondLink.fromJson(json.decode(str));

String diamondLinkModelToJson(DiamondLink data) => json.encode(data.toJson());

class DiamondLink {
  bool? status;
  String? message;
  String? paymentLink;

  DiamondLink({
    this.status,
    this.message,
    this.paymentLink,
  });

  factory DiamondLink.fromJson(Map<String, dynamic> json) => DiamondLink(
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

// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
    PlanModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<PlanData>? data;

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PlanData>.from(json["data"]!.map((x) => PlanData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PlanData {
    PlanData({
        this.id,
        this.amount,
        this.duration,
        this.status,
        this.mostPopular,
        this.createdAt,
        this.updatedAt,
        this.amountInNaira,
    });

    int? id;
    double? amount;
    int? duration;
    int? status;
    int? mostPopular;
    DateTime? createdAt;
    DateTime? updatedAt;
    double? amountInNaira;

    factory PlanData.fromJson(Map<String, dynamic> json) => PlanData(
        id: json["id"],
        amount: json["amount"]?.toDouble(),
        duration: json["duration"],
        status: json["status"],
        mostPopular: json["most_popular"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
         amountInNaira: json["amount_in_naira"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "duration": duration,
        "status": status,
        "most_popular": mostPopular,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "amount_in_naira": amountInNaira,
    };
}

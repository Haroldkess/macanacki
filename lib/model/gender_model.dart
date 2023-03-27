import 'dart:convert';

GenderModel genderModelFromJson(String str) =>
    GenderModel.fromJson(json.decode(str));

String genderModelToJson(GenderModel data) => json.encode(data.toJson());

class GenderModel {
  GenderModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<GenderList>? data;

  factory GenderModel.fromJson(Map<String, dynamic> json) => GenderModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GenderList>.from(
                json["data"]!.map((x) => GenderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GenderList {
  GenderList({
    this.id,
    this.name,
    this.selected,
  });

  int? id;
  String? name;
  bool? selected;

  factory GenderList.fromJson(Map<String, dynamic> json) => GenderList(
        id: json["id"],
        name: json["name"],
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

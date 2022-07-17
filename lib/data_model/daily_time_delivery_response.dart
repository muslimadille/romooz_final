// To parse this JSON data, do
//
//     final dailyTimeDeliveryResponse = dailyTimeDeliveryResponseFromJson(jsonString);

import 'dart:convert';

DailyTimeDeliveryResponse dailyTimeDeliveryResponseFromJson(String str) =>
    DailyTimeDeliveryResponse.fromJson(json.decode(str));

String dailyTimeDeliveryResponseToJson(DailyTimeDeliveryResponse data) =>
    json.encode(data.toJson());

class DailyTimeDeliveryResponse {
  DailyTimeDeliveryResponse({
    this.days,
  });

  List<Day> days;

  factory DailyTimeDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      DailyTimeDeliveryResponse(
        days: json["days"] == null
            ? null
            : List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "days": days == null
            ? null
            : List<dynamic>.from(days.map((x) => x.toJson())),
      };
}

class Day {
  Day({
    this.id,
    this.code,
    this.name,
    this.startTime,
    this.endTime,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String code;
  String name;
  String startTime;
  String endTime;
  int active;
  dynamic createdAt;
  DateTime updatedAt;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        startTime: json["start_time"] == null ? null : json["start_time"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        active: json["active"] == null ? null : json["active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "start_time": startTime == null ? null : startTime,
        "end_time": endTime == null ? null : endTime,
        "active": active == null ? null : active,
        "created_at": createdAt,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

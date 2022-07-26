// To parse this JSON data, do
//
//     final subscribedPackageShowResponse = subscribedPackageShowResponseFromJson(jsonString);

import 'dart:convert';

SubscribedPackageShowResponse subscribedPackageShowResponseFromJson(
        String str) =>
    SubscribedPackageShowResponse.fromJson(json.decode(str));

String subscribedPackageShowResponseToJson(
        SubscribedPackageShowResponse data) =>
    json.encode(data.toJson());

class SubscribedPackageShowResponse {
  SubscribedPackageShowResponse({
    this.id,
    this.userId,
    this.packageId,
    this.startDate,
    this.endDate,
    this.remainingVisits,
    this.days,
    this.times,
    this.success,
    this.status,
  });

  int id;
  int userId;
  int packageId;
  DateTime startDate;
  DateTime endDate;
  int remainingVisits;
  String days;
  String times;
  bool success;
  int status;

  factory SubscribedPackageShowResponse.fromJson(Map<String, dynamic> json) =>
      SubscribedPackageShowResponse(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        remainingVisits:
            json["remaining_visits"] == null ? null : json["remaining_visits"],
        days: json["days"] == null ? null : json["days"],
        times: json["times"] == null ? null : json["times"],
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "package_id": packageId == null ? null : packageId,
        "start_date": startDate == null
            ? null
            : "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": endDate == null
            ? null
            : "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "remaining_visits": remainingVisits == null ? null : remainingVisits,
        "days": days == null ? null : days,
        "times": times == null ? null : times,
        "success": success == null ? null : success,
        "status": status == null ? null : status,
      };
}

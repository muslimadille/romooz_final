// To parse this JSON data, do
//
//     final packagesResponseSubscribe = packagesResponseSubscribeFromJson(jsonString);

import 'dart:convert';

PackagesResponseSubscribe packagesResponseSubscribeFromJson(String str) =>
    PackagesResponseSubscribe.fromJson(json.decode(str));

String packagesResponseSubscribeToJson(PackagesResponseSubscribe data) =>
    json.encode(data.toJson());

class PackagesResponseSubscribe {
  PackagesResponseSubscribe({
    this.message,
    this.packageId,
    this.status,
  });

  String message;
  int packageId;
  String status;

  factory PackagesResponseSubscribe.fromJson(Map<String, dynamic> json) =>
      PackagesResponseSubscribe(
        message: json["message"] == null ? null : json["message"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "package_id": packageId == null ? null : packageId,
        "status": status == null ? null : status,
      };
}

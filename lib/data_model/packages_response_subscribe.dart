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
    this.user_package_id,
    this.status,
  });

  String message;
  int user_package_id;
  bool status;

  factory PackagesResponseSubscribe.fromJson(Map<String, dynamic> json) =>
      PackagesResponseSubscribe(
        message: json["message"] == null ? null : json["message"],
        user_package_id:
            json["user_package_id"] == null ? null : json["user_package_id"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "user_package_id": user_package_id == null ? null : user_package_id,
        "status": status == null ? null : status,
      };
}

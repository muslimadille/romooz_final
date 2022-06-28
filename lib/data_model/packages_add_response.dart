// To parse this JSON data, do
//
//     final packageAddResponse = packageAddResponseFromJson(jsonString);

import 'dart:convert';

PackageAddResponse packageAddResponseFromJson(String str) =>
    PackageAddResponse.fromJson(json.decode(str));

String packageAddResponseToJson(PackageAddResponse data) =>
    json.encode(data.toJson());

class PackageAddResponse {
  PackageAddResponse({
    this.message,
    this.packageId,
    this.package,
    this.status,
  });

  String message;
  int packageId;
  Package package;
  String status;

  factory PackageAddResponse.fromJson(Map<String, dynamic> json) =>
      PackageAddResponse(
        message: json["message"],
        packageId: json["package_id"],
        package: Package.fromJson(json["package"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "package_id": packageId,
        "package": package.toJson(),
        "status": status,
      };
}

class Package {
  Package({
    this.name,
    this.desc,
    this.userType,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String name;
  String desc;
  String userType;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        name: json["name"],
        desc: json["desc"],
        userType: json["user_type"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "user_type": userType,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}

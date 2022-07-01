// To parse this JSON data, do
//
//     final wishlistDeleteResponse = wishlistDeleteResponseFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

PackageItemDeleteResponse packageItemDeleteResponseFromJson(String str) =>
    PackageItemDeleteResponse.fromJson(json.decode(str));

String packageItemDeleteResponseToJson(PackageItemDeleteResponse data) =>
    json.encode(data.toJson());

class PackageItemDeleteResponse {
  PackageItemDeleteResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory PackageItemDeleteResponse.fromJson(Map<String, dynamic> json) =>
      PackageItemDeleteResponse(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}

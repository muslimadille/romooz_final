// To parse this JSON data, do

//

//     final productMiniResponse = notifcationCountResponseFromJson(jsonString);

//https://app.quicktype.io/

import 'dart:convert';

NotifcationCountResponse notifcationCountResponseFromJson(String str) =>
    NotifcationCountResponse.fromJson(json.decode(str));

String notificationCountResponseToJson(NotifcationCountResponse data) =>
    json.encode(data.toJson());

class NotifcationCountResponse {
  NotifcationCountResponse({
    this.data,
    this.success,
    this.status,
  });

  NotificationCount data;

  bool success;

  int status;

  factory NotifcationCountResponse.fromJson(Map<String, dynamic> json) =>
      NotifcationCountResponse(
        data: json["data"] == null
            ? null
            : NotificationCount.fromJson(json["data"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
        "success": success,
        "status": status,
      };
}

class NotificationCount {
  NotificationCount({
    this.cart_count,
    this.comparisons_count,
    this.wishlist_count,
  });

  int cart_count;
  int comparisons_count;
  int wishlist_count;

  factory NotificationCount.fromJson(Map<String, dynamic> json) =>
      NotificationCount(
        cart_count: json["cart_count"],
        comparisons_count: json["comparisons_count"],
        wishlist_count: json["wishlist_count"],
      );

  Map<String, dynamic> toJson() => {
        "cart_count": cart_count,
        "comparisons_count": comparisons_count,
        "wishlist_count": wishlist_count,
      };
}

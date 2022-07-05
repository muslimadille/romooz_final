// To parse this JSON data, do
//
//     final packageAddItemResponse = packageAddItemResponseFromJson(jsonString);

import 'dart:convert';

PackageAddItemResponse packageAddItemResponseFromJson(String str) =>
    PackageAddItemResponse.fromJson(json.decode(str));

String packageAddItemResponseToJson(PackageAddItemResponse data) =>
    json.encode(data.toJson());

class PackageAddItemResponse {
  PackageAddItemResponse({
    this.message,
    this.packageItemId,
    this.packageItem,
    this.itemId,
    this.status,
  });

  String message;
  int packageItemId;
  PackageItem packageItem;
  String status;
  int itemId;

  factory PackageAddItemResponse.fromJson(Map<String, dynamic> json) =>
      PackageAddItemResponse(
        message: json["message"] == null ? null : json["message"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        packageItemId:
            json["package_item_id"] == null ? null : json["package_item_id"],
        packageItem: json["package_item"] == null
            ? null
            : PackageItem.fromJson(json["package_item"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "itemId": itemId == null ? null : itemId,
        "package_item_id": packageItemId == null ? null : packageItemId,
        "package_item": packageItem == null ? null : packageItem.toJson(),
        "status": status == null ? null : status,
      };
}

class PackageItem {
  PackageItem({
    this.productId,
    this.packageId,
    this.qty,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String productId;
  String packageId;
  String qty;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
        productId: json["product_id"] == null ? null : json["product_id"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        qty: json["qty"] == null ? null : json["qty"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "package_id": packageId == null ? null : packageId,
        "qty": qty == null ? null : qty,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "id": id == null ? null : id,
      };
}

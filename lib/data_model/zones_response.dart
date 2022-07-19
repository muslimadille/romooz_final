// To parse this JSON data, do
//
//     final zonesResponse = zonesResponseFromJson(jsonString);

import 'dart:convert';

List<ZonesResponse> zonesResponseFromJson(String str) =>
    List<ZonesResponse>.from(
        json.decode(str).map((x) => ZonesResponse.fromJson(x)));

String zonesResponseToJson(List<ZonesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ZonesResponse {
  ZonesResponse({
    this.id,
    this.cityId,
    this.name,
    this.type,
    this.cost,
    this.customerCost,
    this.sellerCost,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int cityId;
  String name;
  String type;
  int cost;
  int customerCost;
  int sellerCost;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory ZonesResponse.fromJson(Map<String, dynamic> json) => ZonesResponse(
        id: json["id"] == null ? null : json["id"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        cost: json["cost"] == null ? null : json["cost"],
        customerCost:
            json["customer_cost"] == null ? null : json["customer_cost"],
        sellerCost: json["seller_cost"] == null ? null : json["seller_cost"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "city_id": cityId == null ? null : cityId,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "cost": cost == null ? null : cost,
        "customer_cost": customerCost == null ? null : customerCost,
        "seller_cost": sellerCost == null ? null : sellerCost,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final zonesResponse = zonesResponseFromJson(jsonString);

import 'dart:convert';

ZonesResponse zonesResponseFromJson(String str) =>
    ZonesResponse.fromJson(json.decode(str));

String zonesResponseToJson(ZonesResponse data) => json.encode(data.toJson());

class ZonesResponse {
  ZonesResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Zone> data;
  bool success;
  int status;

  factory ZonesResponse.fromJson(Map<String, dynamic> json) => ZonesResponse(
        data: json["data"] == null
            ? null
            : List<Zone>.from(json["data"].map((x) => Zone.fromJson(x))),
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success == null ? null : success,
        "status": status == null ? null : status,
      };
}

class Zone {
  Zone({
    this.id,
    this.cityId,
    this.name,
    this.type,
    this.cost,
    this.customerCost,
    this.sellerCost,
  });

  int id;
  int cityId;
  String name;
  String type;
  int cost;
  int customerCost;
  int sellerCost;

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json["id"] == null ? null : json["id"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        cost: json["cost"] == null ? null : json["cost"],
        customerCost:
            json["customer_cost"] == null ? null : json["customer_cost"],
        sellerCost: json["seller_cost"] == null ? null : json["seller_cost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "city_id": cityId == null ? null : cityId,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "cost": cost == null ? null : cost,
        "customer_cost": customerCost == null ? null : customerCost,
        "seller_cost": sellerCost == null ? null : sellerCost,
      };
}

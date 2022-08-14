// To parse this JSON data, do
//
//     final addressAddResponse = addressAddResponseFromJson(jsonString);

import 'dart:convert';

AddressAddResponse addressAddResponseFromJson(String str) =>
    AddressAddResponse.fromJson(json.decode(str));

String addressAddResponseToJson(AddressAddResponse data) =>
    json.encode(data.toJson());

class AddressAddResponse {
  AddressAddResponse({
    this.result,
    this.message,
    this.data,
  });

  bool result;
  String message;
  Data data;

  factory AddressAddResponse.fromJson(Map<String, dynamic> json) =>
      AddressAddResponse(
        result: json["result"] == null ? null : json["result"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
    this.zoneId,
    this.countryName,
    this.stateName,
    this.cityName,
    this.zoneName,
    this.postalCode,
    this.phone,
  });

  int id;
  int userId;
  String address;
  int countryId;
  int stateId;
  int cityId;
  int zoneId;
  String countryName;
  String stateName;
  String cityName;
  String zoneName;
  String postalCode;
  String phone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        address: json["address"] == null ? null : json["address"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        stateId: json["state_id"] == null ? null : json["state_id"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        zoneId: json["zone_id"] == null ? null : json["zone_id"],
        countryName: json["country_name"] == null ? null : json["country_name"],
        stateName: json["state_name"] == null ? null : json["state_name"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        zoneName: json["zone_name"] == null ? null : json["zone_name"],
        postalCode: json["postal_code"] == null ? null : json["postal_code"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "address": address == null ? null : address,
        "country_id": countryId == null ? null : countryId,
        "state_id": stateId == null ? null : stateId,
        "city_id": cityId == null ? null : cityId,
        "zone_id": zoneId == null ? null : zoneId,
        "country_name": countryName == null ? null : countryName,
        "state_name": stateName == null ? null : stateName,
        "city_name": cityName == null ? null : cityName,
        "zone_name": zoneName == null ? null : zoneName,
        "postal_code": postalCode == null ? null : postalCode,
        "phone": phone == null ? null : phone,
      };
}

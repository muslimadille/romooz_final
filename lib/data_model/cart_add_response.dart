// To parse this JSON data, do
//
//     final cartAddResponse = cartAddResponseFromJson(jsonString);

import 'dart:convert';

CartAddResponse cartAddResponseFromJson(String str) => CartAddResponse.fromJson(json.decode(str));

String cartAddResponseToJson(CartAddResponse data) => json.encode(data.toJson());

class CartAddResponse {
  CartAddResponse({
    this.result,
    this.message,
    this.quantity,
    this.upperLimit,
    this.lowerLimit,
  });

  bool result;
  String message;
  int quantity;
  int upperLimit;
  int lowerLimit;



  factory CartAddResponse.fromJson(Map<String, dynamic> json) => CartAddResponse(
    result: json["result"],
    message: json["message"],
    quantity: json["quantity"],
    upperLimit: json["upper_limit"],
    lowerLimit: json["lower_limit"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
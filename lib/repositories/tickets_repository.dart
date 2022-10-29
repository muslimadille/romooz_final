import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/zones_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TicketsRepository {

  static Future<Map<String,dynamic>> getAllTicketss() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/tickets");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("response.body.toString()${response.body.toString()}");
    print('1111111111111111133333333333333333');
    print(response.body);
    return json.decode(response.body);
  }

  static Future<Map<String,dynamic>> getTicketsDetails(String id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/tickets/"+id);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("response.body.toString()${response.body.toString()}");
    print('1111111111111111133333333333333333');
    print(response.body);
    return json.decode(response.body);
  }

  static Future<Map<String,dynamic>> closeTicket(String id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/tickets/"+id+"/close");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("response.body.toString()${response.body.toString()}");
    print('1111111111111111133333333333333333');
    print(response.body);
    return json.decode(response.body);
  }

  static Future<Map<String,dynamic>> addTicket(Map<String,dynamic> data) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/tickets/store");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
      body: jsonEncode(data)
    );
    // print("response.body.toString()${response.body.toString()}");
    print('1111111111111111133333333333333333');
    print(response.body);
    return json.decode(response.body);
  }

  static Future<Map<String,dynamic>> addReply(Map<String,dynamic> data) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/tickets/reply");
    final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: jsonEncode(data)
    );
    // print("response.body.toString()${response.body.toString()}");
    print('1111111111111111133--------------------------33333333');
    print(response.body);
    return json.decode(response.body);
  }

}

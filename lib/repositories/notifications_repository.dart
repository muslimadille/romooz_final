import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/zones_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class NotificationRepository {
  static Future<int> getNotificationCount() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/notifications/unread-count");
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
    return json.decode(response.body)['count'];
  }

  static Future<Map<String,dynamic>> getAllNotifications() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/notifications/all");
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


  static Future<Map<String,dynamic>> markNotificationAsRead(int id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/notifications/mark-read/"+id.toString());
    final response = await http.post(
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

}

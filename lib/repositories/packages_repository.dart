import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/my_subscribed_package_response.dart';
import 'package:active_ecommerce_flutter/data_model/daily_time_delivery_response.dart';
import 'package:active_ecommerce_flutter/data_model/package_add_item_response.dart';
import 'package:active_ecommerce_flutter/data_model/package_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_response_subscribe.dart';
import 'package:active_ecommerce_flutter/data_model/subscribed_package_show_response.dart';
import 'package:active_ecommerce_flutter/data_model/my_subscribed_package_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class PackagesRepository {
  //get all packages
  Future<PackagesResponse> getAdminPackages() async {
    Uri url;
    if (is_logged_in.$ == false) {
      url = Uri.parse(
          "${AppConfig.BASE_URL}/packages/get/all?customer_type=$customer_type");
    } else {
      url = Uri.parse("${AppConfig.BASE_URL}/packages/auth/get/all");
    }

    print('vvvvvvvvvvvvvvvvvvvvvvvv');
    print(access_token.$);
    // Uri url = Uri.parse("${AppConfig.BASE_URL}/get-admin-packages");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    // print('zzzzzzzzzzzzzzzzzzzzzzzz');
    // print(response.body);
    return packagesResponseFromJson(response.body);
  }

  Future<PackageDetailsResponse> getAdminPackagesDetails(int package_id) async {
    // Uri url = Uri.parse("${AppConfig.BASE_URL}/get-admin-package/$package_id");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/packages/get/$package_id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print('wwwwwwsssssssssssssssswwwwwwwwwwwwwwwwwwwwwww');
    print(response.body);
    // print("get-admin-package${response.body}");
    return packageDetailsResponseFromJson(response.body);
  }

  Future<PackagesResponse> getUserPackages() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-packages");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return packagesResponseFromJson(response.body);
  }

  Future<PackageDetailsResponse> getUserPackagesDetails(int package_id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-package/$package_id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return packageDetailsResponseFromJson(response.body);
  }

  Future<PackageAddResponse> createPackage(
      {@required String name, String desc}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/package");

    print(url.toString());
    var post_body = jsonEncode({
      "name": "${name}",
      "desc": "${desc}",
      "shipping_type": "weekly",
      "dates": "3,1,2",
    });
    print("post_body${post_body}");

    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
          "Content-Type": "application/json",
        },
        body: post_body);

    return packageAddResponseFromJson(response.body);
  }

  Future<PackageItemDeleteResponse> delete(
      {@required int item_id = 0, int value}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/user/package/item/remove/${item_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("remove${response.body}");
    return packageItemDeleteResponseFromJson(response.body);
  }

  Future<PackageAddItemResponse> addItemInPackage({
    @required int product_id,
    int package_id,
  }) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/user/package/items?product_id=${product_id}&package_id=${package_id}&qty=1");

    print(url.toString());
    // var post_body = jsonEncode({
    //   "name": "${name}",
    //   "desc": "${desc}",
    // });
    // print("post_body${post_body}");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
        "Content-Type": "application/json",
      },
    );
    print("addItemInPackage${response.body}");
    print(
        "${AppConfig.BASE_URL}/user/package/items?product_id=${product_id}&package_id=${package_id}&qty=1");
    return packageAddItemResponseFromJson(response.body);
  }

  Future<DailyTimeDeliveryResponse> getDailyTimeDeliveryResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-daily-time-delivery");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print('wwwwwwww');

    print(response.body);
    return dailyTimeDeliveryResponseFromJson(response.body);
  }

  Future<SubscribedPackageShowResponse> getSubscribedPackageShowResponse(
      int package_id) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/subscribed-package-show/${package_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return subscribedPackageShowResponseFromJson(response.body);
  }


  Future<MySubscribedPackagesResponse> getMySubscribedPackageResponse() async {
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/packages/my/subscribed");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print('sssssssssssssssssssssssssssssssssssssss');
    print(response.body);
    return mySubscribedPackagesResponseFromJson(response.body);
  }

  Future<PackagesResponseSubscribe> subscribeAdminPackages(
      int package_id, String days, String times) async {
    // print('ssssssssssssssssssssssss');
    // print(package_id);
    // print(days);
    // print(times);
    // String times_=times;
    // int length= days.split(',').length;
    // for(var i=1; i < length; i++){
    //   times_+= ','+times;
    // }
    // print(times_);

    // Uri url = Uri.parse("${AppConfig.BASE_URL}/user/subscribe-package");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/packages/subscribe");

    //  print("post_body${post_body}");

    final response = await http.post(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
      "Accept": "application/json"
    }, body: {
      "package_id": "${package_id}",
      "dates": "${days}",
      // "times": "${times}",
      "times": "${times}",
    });
    print("get-admin-package${response.body}");
    return packagesResponseSubscribeFromJson(response.body);
  }
}

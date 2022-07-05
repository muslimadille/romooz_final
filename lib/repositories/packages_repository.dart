import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/package_add_item_response.dart';
import 'package:active_ecommerce_flutter/data_model/package_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_response.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/wishlist_check_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class PackagesRepository {
  Future<PackagesResponse> getAdminPackages() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-admin-packages");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return packagesFromJson(response.body);
  }

  Future<PackageDetailsResponse> getAdminPackagesDetails(int package_id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-admin-package/$package_id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
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
    return packagesFromJson(response.body);
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
}

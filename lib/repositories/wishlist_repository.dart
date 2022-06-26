import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/wishlist_check_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class WishListRepository {
  Future<WishlistResponse> getUserWishlist(int value) async {
    Uri url = value == 1
        ? Uri.parse("${AppConfig.BASE_URL}/wishlists")
        : Uri.parse("${AppConfig.BASE_URL}/comp_prods");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return wishlistResponseFromJson(response.body);
  }

  Future<WishlistDeleteResponse> delete(
      {@required int wishlist_id = 0, int value}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/wishlists/${wishlist_id}");
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<WishlistDeleteResponse> deleteProducutInComprsion(
      // ignore: invalid_required_named_param
      {@required int product_id = 0,
      int value}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/comp_prods-remove-product?product_id=${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("deleteProducutInComprsion${response.body}");
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<WishListChekResponse> isProductInUserWishList(
      {@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> add({@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}");

    print(url.toString());
    var post_body = jsonEncode({
      "product_id": "${product_id}",
    });

    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
          "Content-Type": "application/json",
        },
        body: post_body);

    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> addToComparsionList(
      {@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/comp_prods-add-product?product_id=${product_id}");

    print(url.toString());
    var post_body = jsonEncode({
      "product_id": "${product_id}",
    });

    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
          "Content-Type": "application/json",
        },
        body: post_body);

    print("addToComparsionList${response.body}");
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> remove({@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return wishListChekResponseFromJson(response.body);
  }
}

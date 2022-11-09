import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/variant_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ProductRepository {

  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    Uri url;
    if (is_logged_in.$ == false) {
      url = Uri.parse(
          "${AppConfig.BASE_URL}/products/featured?page=${page}&customer_type");
    }else{
      print('vvvvvvvvvvvvvvvvvvvvvvvv');
      url = Uri.parse(
          "${AppConfig.BASE_URL}/products/auth/featured?page=${page}");
    }
    print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    print(access_token.$);
    print(url);
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print('11111111111111111111111111111111');
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/best-seller");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(
      {@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {@required int id = 0, name = "", page = 1}) async {
    print("customer_type ----- ${customer_type.$}");


    Uri url;
    // print('***************************');
    // print(is_logged_in.$.toString());
    if (is_logged_in.$ == false) {
       url = Uri.parse("${AppConfig.BASE_URL}/products/category/" +
          id.toString() +
          "?page=${page}&name=${name}");
    } else {
       url = Uri.parse("${AppConfig.BASE_URL}/products/auth/category/" +
          id.toString() +
          "?page=${page}&name=${name}");
    }


    // url = Uri.parse("${AppConfig.BASE_URL}/products/category/" +
    //     id.toString() +
    //     "?page=${page}&name=${name}");




    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {

    Map<String,dynamic>body={
      "categories":"$categories",
      "brands":"$brands",
      "sort_key":"$sort_key",
      "name":"$name",
      "min":"$min",
      "max":"$max"
    };
    String url="" ;
    if (is_logged_in.$ == false) {
      url   = "${AppConfig.BASE_URL}/products/search";
    }else {
      url="${AppConfig.BASE_URL}/products/auth/search";
    }

    final response = await http.post(Uri.parse(url),
        body: body,
        headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails(
      {@required int id = 0}) async {
    Uri url;
    // print('1111111111111111111111111111111111111111111');
    // // print();
    // print(is_logged_in.$.toString());
    // print(access_token.$.toString());
    // if (access_token.$ == "") {
    if (is_logged_in.$ == false) {
      url = Uri.parse("${AppConfig.BASE_URL}/products/get/" + id.toString());
    } else {
      url = Uri.parse("${AppConfig.BASE_URL}/products/" + id.toString());
    }

    print(url.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    print(response.body.toString());
    print("Bearer ${access_token.$}");
    return productDetailsResponseFromJson(response.body);
  }


  Future<ProductMiniResponse> getRelatedProducts({@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/products/related/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${variants}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });

    return variantResponseFromJson(response.body);
  }
}

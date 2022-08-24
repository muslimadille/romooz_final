import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/zones_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/address_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_location_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_make_default_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_in_cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/shipping_cost_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class AddressRepository {
  Future<AddressResponse> getAddressList() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/address");
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
    return addressResponseFromJson(response.body);
  }

  Future<AddressAddResponse> getAddressAddResponse(
      {@required String address,
        // @required int country_id,
        @required int state_id,
        // @required int city_id,
        @required String postal_code,
        @required String phone}) async {
    var post_body = jsonEncode({
      // "user_id": "${user_id.$}",
      "id": "${user_id.$}",
      "address": "$address",
      // "country_id": "$country_id",
      "state_id": "$state_id",
      // "city_id": "$city_id",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/create");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressAddResponseFromJson(response.body);
  }

  Future<AddressUpdateResponse> getAddressUpdateResponse(
      {@required int id,
        @required String address,
        // @required int country_id,
        @required int state_id,
        // @required int city_id,
        @required String postal_code,
        @required String phone}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "address": "$address",
      // "country_id": "$country_id",
      "state_id": "$state_id",
      // "city_id": "$city_id",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressUpdateResponseFromJson(response.body);
  }

  Future<AddressUpdateLocationResponse> getAddressUpdateLocationResponse(
      @required int id,
      @required double latitude,
      @required double longitude,
      ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "latitude": "$latitude",
      "longitude": "$longitude"
    });
    print("Location update${post_body}");

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update-location");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressUpdateLocationResponseFromJson(response.body);
  }

  Future<AddressMakeDefaultResponse> getAddressMakeDefaultResponse(
      @required int id,
      ) async {
    var post_body = jsonEncode({
      "address_id": "$id",
    });

    print('qqqqqqqqqqqqqqqqqqqqq');
    print("$id");
    print("Bearer ${access_token.$}");
    print("${AppConfig.BASE_URL}");


    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/make_default");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          // "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);
    print('111111111111111111111111111');
    print(url);
    print(response.body);
    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<AddressDeleteResponse> getAddressDeleteResponse(
      @required int id,
      ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/delete/$id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    return addressDeleteResponseFromJson(response.body);
  }

  Future<CityResponse> getCityListByState({state_id = 0, name = ""}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/cities-by-state/${state_id}?name=${name}");
    final response = await http.get(url);

    print(url.toString());
    print(response.body.toString());

    return cityResponseFromJson(response.body);
  }

  Future<MyStateResponse> getStateListByCountry(
      {country_id = "191", name = ""}) async {
    // print('000000000000000000000000000');
    // print(country_id);
    // print(name);
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/states-by-country/${country_id}?name=${name}");
    final response = await http.get(url);
    // print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    // print(response.body);
    return myStateResponseFromJson(response.body);
  }

  Future<ZonesResponse> getZoneList() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/zones");
    final response = await http.get(url);
    return zonesResponseFromJson(response.body);
  }

  Future<CountryResponse> getCountryList({name = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/countries?name=${name}");
    final response = await http.get(url);
    return countryResponseFromJson(response.body);
  }

  Future<ShippingCostResponse> getShippingCostResponse(
      {@required int user_id,
        int address_id = 0,
        int pick_up_id = 0,
        shipping_type = "home_delivery"}) async {
    var post_body = jsonEncode({
      "address_id": "$address_id",
      "pickup_point_id": "$pick_up_id",
      "shipping_type": "$shipping_type"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/shipping_cost/$address_id");
    print('------------------------------------------');
    print(url);
    print(access_token.$);
    final response = await http.get(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        // body: post_body
    );



    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    print(response.body);
    return shippingCostResponseFromJson(response.body);
  }

  Future<AddressUpdateInCartResponse> getAddressUpdateInCartResponse(
      {int address_id = 0, int pickup_point_id = 0}) async {
    var post_body = jsonEncode({
      "address_id": "${address_id}",
      "pickup_point_id": "${pickup_point_id}",
      "user_id": "${user_id.$}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/update-address-in-cart");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
      print('aaaaaaaaaaaa');
      print(response.body);
    return addressUpdateInCartResponseFromJson(response.body);
  }
}

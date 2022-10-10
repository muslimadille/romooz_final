import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/login_response.dart';
import 'package:active_ecommerce_flutter/data_model/logout_response.dart';
import 'package:active_ecommerce_flutter/data_model/signup_response.dart';
import 'package:active_ecommerce_flutter/data_model/resend_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_code_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_forget_response.dart';
import 'package:active_ecommerce_flutter/data_model/password_confirm_response.dart';
import 'package:active_ecommerce_flutter/data_model/user_by_token.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      @required String email, String password,
      String userType) async {
    print("email${email}");
    var post_body = jsonEncode({
      "phone": "${email}",
      // "password": "$password",
      "user_type": "${userType}",
      "identity_matrix": AppConfig.purchase_code
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print('ppppppppppppppppppppppppppppppppppppp');
    print(response.body);
    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(@required String social_provider,
      @required String name, @required String email, @required String provider,
      {access_token = ""}) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode({
      "name": "${name}",
      "email": email,
      "provider": "$provider",
      "social_provider": "$social_provider",
      "access_token": "$access_token"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(post_body);
    print(response.body.toString());
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    print(response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
    Map<String, dynamic> data,
    // @required String name,
    // @required String email_or_phone,
    // @required String customer_type,
    // // @required String password,
    // // @required String passowrd_confirmation,
    // // @required String register_by,
    // @required String owner_name,
    // @required String commercial_name,
    // @required String commercial_registration_no,
    // @required String commercial_registry,
    // @required String tax_number,
    // @required String tax_number_certificate,
    // @required String state_id,
  ) async {
    // var data = {
    //   "name": "$name",
    //   "email_or_phone": "${email_or_phone}",
    //   "user_type": "customer",
    //   "customer_type": "$customer_type",
    // };
    //
    // if(customer_type== "wholesale"){
    //   data.addAll({
    //     // "password": "$password",
    //     // "password_confirmation": "${passowrd_confirmation}",
    //     // "register_by": "$register_by",
    //     "owner_name": "$owner_name",
    //     "commercial_name": "$commercial_name",
    //     "commercial_registration_no": "$commercial_registration_no",
    //     "commercial_registry": "$commercial_registry",
    //     "tax_number": "$tax_number",
    //     "tax_number_certificate": "$tax_number_certificate",
    //     "state_id": state_id,
    //     // "long": "45.039",
    //     // "lat": "34.2093",
    //   });
    // }

    var post_body = jsonEncode(data);

    //var  post_body = jsonEncode({
    //   "name": "$name",
    //   "email_or_phone": "${email_or_phone}",
    //   "user_type": "customer",
    //   "password": "$password",
    //   "password_confirmation": "${passowrd_confirmation}",
    //   "register_by": "$register_by",
    //   "customer_type": "$customer_type",
    //   "owner_name": "$owner_name",
    //   "commercial_name": "$commercial_name",
    //   "commercial_registration_no": "$commercial_registration_no",
    //   "commercial_registry": "$commercial_registry",
    //   "tax_number_certificate": "$tax_number_certificate",
    //   "tax_number": "$tax_number",
    //   "city_id": city_id,
    //   "long": "45.039",
    //   "lat": "34.2093",
    // });

    print("response sign up${post_body}");

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print('00000000000000000000000000000000000000000000000000000000');
    print("response sign up${response.body} ${post_body}");

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int user_id, @required String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<LoginResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print('1111111111111111111111111111111111111111');
    print(user_id.toString());
    print(verification_code);
    print('1111111111111111111111111111111111111111');
    print(response.body);
    return loginResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String email_or_phone, @required String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/forget_request",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verification_code, @required String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    print("===== post_body ${post_body} ${user_id.$}");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}

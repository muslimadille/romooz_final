import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../../app_config.dart';
import '../shared_value_helper.dart';

class NewCheckoutScreen extends StatefulWidget {
  const NewCheckoutScreen({Key key}) : super(key: key);

  @override
  State<NewCheckoutScreen> createState() => _NewCheckoutScreenState();
}

class _NewCheckoutScreenState extends State<NewCheckoutScreen> {
  static const platform = MethodChannel('hyperPayChannel');
@override
  void initState() {
    super.initState();
    _getPaymentResponse();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<String> get getCheckoutIdServer async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/hyperpay-get-checkoutId");
    final response = await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization": "Bearer ${access_token.$}",
        },
        body: {
          "payment_method_key":"mada" //TODO make method dynamic
        }
    );
    final Map _resBody = json.decode(response.body);
    return _resBody['checkout_id'];
  }
  Future<void> _getPaymentResponse() async {
    /// get checkoutId from your server
    String checkoutId= await getCheckoutIdServer;
    try {
      /// send checkoutId to native method which get payment response
      var result=await platform.invokeMethod("getPaymentMethod",<String,dynamic>{
        "checkoutId":checkoutId
      });
      print("${result.toString()}");//TODO REMOVE PRINT
    } on PlatformException catch (e) {
      ToastComponent.showDialog(
          'Failed to get payment response  ${e.message}',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }

  }

}

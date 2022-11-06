import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/hyperpay/constants.dart';
import 'package:active_ecommerce_flutter/helpers/hyperpay/formatters.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/subscribed_packages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


import '../../app_config.dart';
import 'new_checkout_view.dart';

/// this screen replaced with integrated hyperpay sdk view which handled in checkout.dart screen

// Kindly find the Live credentials as requested for "Romooz":

// Links used in the integration in the code:  https://oppwa.com/

// Access Token (Authorization): OGFjZGE0Yzg3NThkYzY3NTAxNzU5NzdlMWI2ZTZlZjF8RGpLZHM0dG5Tdw==
// Entity ID  (VISA, MASTER ): 8acda4c8758dc6750175977e90726ef8
// Entity ID (MADA): 8acda4c8758dc6750175977f0d676eff
// Entity ID (APPLEPAY):8acda4ca7646bafb017661b532c3047b

// Currency: SAR only
// PaymentType: DB only
// Payment Methods: VISA, MASTER, MADA ,APPLEPAY

class CheckoutView extends StatefulWidget {
  CheckoutView({Key key, this.order_id = "0", this.order_type, this.payment_type})
      : super(key: key);
  final String order_id;
  final String order_type;
  final String payment_type;

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  /// PAYMENT NATIVE CHANNEL
  static const platform = MethodChannel('hyperPayChannel');

  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;
  CardParams _cardParams=CardParams();
  String _checkoutId="";

  @override
  void initState() {
    super.initState();
    _getPaymentResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: checkoutFormUi(),
    );
  }

  InputDecoration _inputDecoration({String label, String hint, dynamic icon}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: TextStyle(
        color: MyTheme.accent_color,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: MyTheme.accent_color,
          width: 2.0,
        ),
      ),
      prefixIcon: icon is IconData
          ? Icon(
              icon,
              color: MyTheme.accent_color,
            )
          : Container(
              padding: const EdgeInsets.all(6),
              width: 10,
              child: Image.asset(icon),
            ),
    );
  }
  void setBrandType(){
    switch(widget.payment_type){
      case "mada":{}
        break;
      case "visa":{}
      break;
      case "appl":{}
      break;

    }
  }

  ///============= PAYMENT METHODS ================================


  Future<void> _getPaymentResponse() async {
    /// get checkoutId from your server
    try {
      _checkoutId=await getCheckoutIdServer;
      /// send checkoutId to native method which get payment response
      var result=await platform.invokeMethod("getPaymentMethod",<String,dynamic>{
        "checkoutId":_checkoutId
      });
      print("${result.toString()}");//TODO REMOVE PRINT
      ToastComponent.showDialog(
          ' payment response  ${"${result.toString()}"}',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    } on PlatformException catch (e) {
      ToastComponent.showDialog(
          'Failed to get payment response  ${e.message}',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }

  }
  void _onPayClicked() async{
    // 1-get checkoutId
    setCheckoutId();
    // 2- set cardParams
    setCardParams();
    //3- innit payment channel

  }
  Future<void> initPaymentData()async {

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
  Widget checkoutFormUi(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode: autovalidateMode,
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  // Holder
                  TextFormField(
                    controller: holderNameController,
                    decoration: _inputDecoration(
                      label: AppLocalizations.of(context).card_holder,
                      hint: "Jane Jones",
                      icon: Icons.account_circle_rounded,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //     "value .....${EnumToString.convertToString(brandType)}"),
                  // Number
                  TextFormField(
                    controller: cardNumberController,
                    decoration: _inputDecoration(
                      label: AppLocalizations.of(context).card_number,
                      hint: "0000 0000 0000 0000",
                      icon: Icons.credit_card/*brandType == BrandType.none
                            ? Icons.credit_card
                            : "assets/${EnumToString.convertToString(brandType)}.png"*/,
                    ),
                    onChanged: (value) {
                      setState(() {
                        //brandType = value.detectBrand;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      //LengthLimitingTextInputFormatter(brandType.maxLength),
                      CardNumberInputFormatter()
                    ],
                    validator: (String number) {},
                    //brandType.validateNumber(number ?? ""),
                  ),
                  const SizedBox(height: 10),
                  // Expiry date
                  TextFormField(
                      controller: expiryController,
                      decoration: _inputDecoration(
                        label: AppLocalizations.of(context).expiry_date,
                        hint: "MM/YY",
                        icon: Icons.date_range_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (String date){}
                    //CardInfo.validateDate(date ?? ""),
                  ),
                  const SizedBox(height: 10),
                  // CVV
                  TextFormField(
                      controller: cvvController,
                      decoration: _inputDecoration(
                        label: AppLocalizations.of(context).cvv,
                        hint: "000",
                        icon: Icons.confirmation_number_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (String cvv) {}
                    //CardInfo.validateCVV(cvv ?? ""),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: MyTheme.accent_color,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: isLoading ? null : /*() => onPay(context)*/(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return NewCheckoutScreen();
                        }));
                      },
                      child: Text(
                        isLoading
                            ? AppLocalizations.of(context).payment_procccing
                            : AppLocalizations.of(context).pay,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  void setCardParams(){
    _cardParams.holder=holderNameController.text??"";
    _cardParams.brand=widget.payment_type;
    _cardParams.number=cardNumberController.text??"";
    _cardParams.cvv=cvvController.text??"";
    _cardParams.expiryMonth=(expiryController.text??"").split("/")[0];
    _cardParams.expiryYear=(expiryController.text??"").split("/")[1];
    _cardParams.checkoutId=_checkoutId;
  }
  void setCheckoutId()async{
    if(_checkoutId.isEmpty){
      _checkoutId=await getCheckoutIdServer;
    }
  }

}
class CardParams{
  String checkoutId;
  String brand;
  String number;
  String holder;
  String expiryMonth;
  String expiryYear;
  String cvv;
  CardParams({
    this.checkoutId,
    this.number,
    this.cvv,
    this.holder,
    this.brand,
    this.expiryYear,
    this.expiryMonth
  });
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    title: Column(
      children: [
        Text(
          AppLocalizations.of(context).checkout_info,
          style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
        ),
      ],
    ),
    elevation: 0.0,
    titleSpacing: 0,
  );
}

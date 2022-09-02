import 'package:active_ecommerce_flutter/helpers/hyperpay/constants.dart';
import 'package:active_ecommerce_flutter/helpers/hyperpay/formatters.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  CheckoutView({Key key, this.order_id = "0", this.order_type})
      : super(key: key);

  final String order_id;
  final String order_type;

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  BrandType brandType = BrandType.none;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;
  String sessionCheckoutID = '';

  HyperpayPlugin hyperpay;

  @override
  void initState() {
    super.initState();
    //print("orderCreateResponse${widget.order_id}");
    setup();
  }

  setup() async {
    // hyperpay = await HyperpayPlugin.setup(config: TestConfig());
    hyperpay = await HyperpayPlugin.setup(config: LiveConfig());
    print("hyperpay ==${hyperpay}");
  }

  /// Initialize HyperPay session
  Future<void> initPaymentSession(
    BrandType brandType,
    double amount,
  ) async {
    CheckoutSettings _checkoutSettings = CheckoutSettings(
      brand: brandType,
      amount: amount,
      orderType: widget.order_type ?? "0",
      orderId: widget.order_id ?? "0",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${access_token.$}"
      },
      additionalParams: {
        'merchantTransactionId': '#123456',
      },
    );
    print(
        "initPaymentSession ---$brandType --- ${_checkoutSettings.orderId} ===${widget.order_type}");

    hyperpay.initSession(checkoutSetting: _checkoutSettings);
    print("sessionCheckoutID --- ==${_checkoutSettings.amount} ");

    sessionCheckoutID = await hyperpay.getCheckoutID;
    print("sessionCheckoutID ---$sessionCheckoutID ");
  }

  Future<void> onPay(context) async {
    final bool valid = Form.of(context)?.validate() ?? false;

    if (valid) {
      setState(() {
        isLoading = true;
      });

      // Make a CardInfo from the controllers
      CardInfo card = CardInfo(
        holder: holderNameController.text,
        cardNumber: cardNumberController.text.replaceAll(' ', ''),
        cvv: cvvController.text,
        expiryMonth: expiryController.text.split('/')[0],
        expiryYear: '20' + expiryController.text.split('/')[1],
      );
      print("card ==== ${cardNumberController.text.replaceAll(' ', '')}");

      try {
        // Start transaction
        if (sessionCheckoutID.isEmpty) {
          print("sessionCheckoutID ==== empty");
          // Only get a new checkoutID if there is no previous session pending now
          await initPaymentSession(brandType, 1);
        }

        final result = await hyperpay.pay(card);
        print("result${result}");

        switch (result) {
          case PaymentStatus.init:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment session is still in progress'),
                backgroundColor: Colors.amber,
              ),
            );
            break;
          // For the sake of the example, the 2 cases are shown explicitly
          // but in real world it's better to merge pending with successful
          // and delegate the job from there to the server, using webhooks
          // to get notified about the final status and do some action.
          case PaymentStatus.pending:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment pending ⏳'),
                backgroundColor: Colors.amber,
              ),
            );
            break;
          case PaymentStatus.successful:
            sessionCheckoutID = '';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment approved 🎉'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList(from_checkout: true);
            }));

            /////// pushing
            break;

          default:
        }
      } on HyperpayException catch (exception) {
        sessionCheckoutID = '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception.details ?? exception.message),
            backgroundColor: Colors.red,
          ),
        );
      } catch (exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$exception'),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
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
                        icon: brandType == BrandType.none
                            ? Icons.credit_card
                            : "assets/${EnumToString.convertToString(brandType)}.png",
                      ),
                      onChanged: (value) {
                        setState(() {
                          brandType = value.detectBrand;
                        });
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(brandType.maxLength),
                        CardNumberInputFormatter()
                      ],
                      validator: (String number) =>
                          brandType.validateNumber(number ?? ""),
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
                      validator: (String date) =>
                          CardInfo.validateDate(date ?? ""),
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
                      validator: (String cvv) =>
                          CardInfo.validateCVV(cvv ?? ""),
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
                        onPressed: isLoading ? null : () => onPay(context),
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
      ),
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

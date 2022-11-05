
// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

// String _host = 'eu-test.oppwa.com';
// String _host = 'https://oppwa.com/';

// Kindly find the Live credentials as requested for "Romooz":

// Links used in the integration in the code:  https://oppwa.com/

// Access Token (Authorization): OGFjZGE0Yzg3NThkYzY3NTAxNzU5NzdlMWI2ZTZlZjF8RGpLZHM0dG5Tdw==
// Entity ID  (VISA, MASTER ): 8acda4c8758dc6750175977e90726ef8
// Entity ID (MADA): 8acda4c8758dc6750175977f0d676eff
// Entity ID (APPLEPAY):8acda4ca7646bafb017661b532c3047b

// Currency: SAR only
// PaymentType: DB only
// Payment Methods: VISA, MASTER, MADA ,APPLEPAY
//import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8a8294174b7ecb28014b9699220015ca';
  @override
  String madaEntityID = '8a8294174b7ecb28014b9699220015ca';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  //@override
  //PaymentMode paymentMode = PaymentMode.test;

  @override
  String applePayEntityID;
}

class LiveConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8acda4c8758dc6750175977e90726ef8';
  @override
  String madaEntityID = '8acda4c8758dc6750175977f0d676eff';
  @override
  String applePayEntityID="8acda4ca7646bafb017661b532c3047b";
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  //@override
  //PaymentMode paymentMode = PaymentMode.live;

}

class HyperpayConfig {
}


String _host = 'romooz.tech';

Uri _checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/api/v2/hyperpay-get-checkoutId',
);

Uri _statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/api/v2/hyperpay-get-paymentStatus',
);

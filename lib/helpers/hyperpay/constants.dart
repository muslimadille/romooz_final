import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8acda4c8758dc6750175977e90726ef8';
  @override
  String madaEntityID = '8acda4c8758dc6750175977f0d676eff';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8acda4c8758dc6750175977e90726ef8';
  @override
  String madaEntityID = '8acda4c8758dc6750175977f0d676eff';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.live;
}

// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

// String _host = 'eu-test.oppwa.com';
// String _host = 'https://oppwa.com/';
String _host = 'oppwa.com';

Uri _checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/v1/checkouts',
);

Uri _statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/v1/checkouts',
);

import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8a8294174b7ecb28014b9699220015ca';
  @override
  String madaEntityID = '8a8294174b7ecb28014b9699220015ca';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '';
  @override
  String madaEntityID = '';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.live;
}

// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

String _host = 'eu-test.oppwa.com';

Uri _checkoutEndpoint = Uri(
  scheme: 'http',
  host: _host,
  path: '/v1/pay',
);

Uri _statusEndpoint = Uri(
  scheme: 'http',
  host: _host,
  path: '/v1/checkouts',
);

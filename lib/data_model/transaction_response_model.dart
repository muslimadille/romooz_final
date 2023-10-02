// To parse this JSON data, do
//
//     final transactionResponsModel = transactionResponsModelFromJson(jsonString);

import 'dart:convert';

TransactionResponsModel transactionResponsModelFromJson(String str) => TransactionResponsModel.fromJson(json.decode(str));

String transactionResponsModelToJson(TransactionResponsModel data) => json.encode(data.toJson());

class TransactionResponsModel {
  final String id;
  final String paymentType;
  final String paymentBrand;
  final String amount;
  final String currency;
  final String descriptor;
  final Result result;
  final ResultDetails resultDetails;
  final Card card;
  final Customer customer;
  final ThreeDSecure threeDSecure;
  final CustomParameters customParameters;
  final Risk risk;
  final String buildNumber;
  final String timestamp;
  final String ndc;

  TransactionResponsModel({
     this.id,
       this.paymentType,
       this.paymentBrand,
       this.amount,
       this.currency,
       this.descriptor,
       this.result,
       this.resultDetails,
       this.card,
       this.customer,
       this.threeDSecure,
       this.customParameters,
       this.risk,
       this.buildNumber,
       this.timestamp,
       this.ndc,
  });

  factory TransactionResponsModel.fromJson(Map<String, dynamic> json) => TransactionResponsModel(
    id: json["id"],
    paymentType: json["paymentType"],
    paymentBrand: json["paymentBrand"],
    amount: json["amount"],
    currency: json["currency"],
    descriptor: json["descriptor"],
    result: Result.fromJson(json["result"]),
    resultDetails: ResultDetails.fromJson(json["resultDetails"]),
    card: Card.fromJson(json["card"]),
    customer: Customer.fromJson(json["customer"]),
    threeDSecure: ThreeDSecure.fromJson(json["threeDSecure"]),
    customParameters: CustomParameters.fromJson(json["customParameters"]),
    risk: Risk.fromJson(json["risk"]),
    buildNumber: json["buildNumber"],
    timestamp: json["timestamp"],
    ndc: json["ndc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "paymentType": paymentType,
    "paymentBrand": paymentBrand,
    "amount": amount,
    "currency": currency,
    "descriptor": descriptor,
    "result": result.toJson(),
    "resultDetails": resultDetails.toJson(),
    "card": card.toJson(),
    "customer": customer.toJson(),
    "threeDSecure": threeDSecure.toJson(),
    "customParameters": customParameters.toJson(),
    "risk": risk.toJson(),
    "buildNumber": buildNumber,
    "timestamp": timestamp,
    "ndc": ndc,
  };
}

class Card {
  final String bin;
  final String binCountry;
  final String last4Digits;
  final String holder;
  final String expiryMonth;
  final String expiryYear;
  final Issuer issuer;
  final String country;
  final String numberType;

  Card({
       this.bin,
       this.binCountry,
       this.last4Digits,
       this.holder,
       this.expiryMonth,
       this.expiryYear,
       this.issuer,
       this.country,
       this.numberType,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    bin: json["bin"],
    binCountry: json["binCountry"],
    last4Digits: json["last4Digits"],
    holder: json["holder"],
    expiryMonth: json["expiryMonth"],
    expiryYear: json["expiryYear"],
    issuer: Issuer.fromJson(json["issuer"]),
    country: json["country"],
    numberType: json["numberType"],
  );

  Map<String, dynamic> toJson() => {
    "bin": bin,
    "binCountry": binCountry,
    "last4Digits": last4Digits,
    "holder": holder,
    "expiryMonth": expiryMonth,
    "expiryYear": expiryYear,
    "issuer": issuer.toJson(),
    "country": country,
    "numberType": numberType,
  };
}

class Issuer {
  final String bank;

  Issuer({
       this.bank,
  });

  factory Issuer.fromJson(Map<String, dynamic> json) => Issuer(
    bank: json["bank"],
  );

  Map<String, dynamic> toJson() => {
    "bank": bank,
  };
}

class CustomParameters {
  final String shopperMsdkIntegrationType;
  final String shopperDevice;
  final String applepaySource;
  final String ctpeDescriptorTemplate;
  final String shopperOs;
  final String tokenSource;
  final String applepayTokenVersion;
  final String shopperMsdkVersion;

  CustomParameters({
       this.shopperMsdkIntegrationType,
       this.shopperDevice,
       this.applepaySource,
       this.ctpeDescriptorTemplate,
       this.shopperOs,
       this.tokenSource,
       this.applepayTokenVersion,
       this.shopperMsdkVersion,
  });

  factory CustomParameters.fromJson(Map<String, dynamic> json) => CustomParameters(
    shopperMsdkIntegrationType: json["SHOPPER_MSDKIntegrationType"],
    shopperDevice: json["SHOPPER_device"],
    applepaySource: json["APPLEPAY_Source"],
    ctpeDescriptorTemplate: json["CTPE_DESCRIPTOR_TEMPLATE"],
    shopperOs: json["SHOPPER_OS"],
    tokenSource: json["tokenSource"],
    applepayTokenVersion: json["APPLEPAY_TokenVersion"],
    shopperMsdkVersion: json["SHOPPER_MSDKVersion"],
  );

  Map<String, dynamic> toJson() => {
    "SHOPPER_MSDKIntegrationType": shopperMsdkIntegrationType,
    "SHOPPER_device": shopperDevice,
    "APPLEPAY_Source": applepaySource,
    "CTPE_DESCRIPTOR_TEMPLATE": ctpeDescriptorTemplate,
    "SHOPPER_OS": shopperOs,
    "tokenSource": tokenSource,
    "APPLEPAY_TokenVersion": applepayTokenVersion,
    "SHOPPER_MSDKVersion": shopperMsdkVersion,
  };
}

class Customer {
  final String ip;

  Customer({
       this.ip,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    ip: json["ip"],
  );

  Map<String, dynamic> toJson() => {
    "ip": ip,
  };
}

class Result {
  final String code;
  final String description;

  Result({
       this.code,
       this.description,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    code: json["code"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
  };
}

class ResultDetails {
  final String connectorTxId1;
  final String connectorId;
  final String connectorTxId2;
  final String responseAcquirerCode;
  final String extendedDescription;
  final String clearingInstituteName;
  final String authorizationResponseStan;
  final String transactionReceipt;
  final String merchantCategoryCode;
  final DateTime transactionAcquirerSettlementDate;
  final String acquirerResponse;
  final String reconciliationId;
  final String responseAcquirerMessage;

  ResultDetails({
       this.connectorTxId1,
       this.connectorId,
       this.connectorTxId2,
       this.responseAcquirerCode,
       this.extendedDescription,
       this.clearingInstituteName,
       this.authorizationResponseStan,
       this.transactionReceipt,
       this.merchantCategoryCode,
       this.transactionAcquirerSettlementDate,
       this.acquirerResponse,
       this.reconciliationId,
       this.responseAcquirerMessage,
  });

  factory ResultDetails.fromJson(Map<String, dynamic> json) => ResultDetails(
    connectorTxId1: json["ConnectorTxID1"],
    connectorId: json["connectorId"],
    connectorTxId2: json["ConnectorTxID2"],
    responseAcquirerCode: json["response.acquirerCode"],
    extendedDescription: json["ExtendedDescription"],
    clearingInstituteName: json["clearingInstituteName"],
    authorizationResponseStan: json["authorizationResponse.stan"],
    transactionReceipt: json["transaction.receipt"],
    merchantCategoryCode: json["merchantCategoryCode"],
    transactionAcquirerSettlementDate: DateTime.parse(json["transaction.acquirer.settlementDate"]),
    acquirerResponse: json["AcquirerResponse"],
    reconciliationId: json["reconciliationId"],
    responseAcquirerMessage: json["response.acquirerMessage"],
  );

  Map<String, dynamic> toJson() => {
    "ConnectorTxID1": connectorTxId1,
    "connectorId": connectorId,
    "ConnectorTxID2": connectorTxId2,
    "response.acquirerCode": responseAcquirerCode,
    "ExtendedDescription": extendedDescription,
    "clearingInstituteName": clearingInstituteName,
    "authorizationResponse.stan": authorizationResponseStan,
    "transaction.receipt": transactionReceipt,
    "merchantCategoryCode": merchantCategoryCode,
    "transaction.acquirer.settlementDate": "${transactionAcquirerSettlementDate.year.toString().padLeft(4, '0')}-${transactionAcquirerSettlementDate.month.toString().padLeft(2, '0')}-${transactionAcquirerSettlementDate.day.toString().padLeft(2, '0')}",
    "AcquirerResponse": acquirerResponse,
    "reconciliationId": reconciliationId,
    "response.acquirerMessage": responseAcquirerMessage,
  };
}

class Risk {
  final String score;

  Risk({
       this.score,
  });

  factory Risk.fromJson(Map<String, dynamic> json) => Risk(
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "score": score,
  };
}

class ThreeDSecure {
  final String eci;
  final String verificationId;

  ThreeDSecure({
       this.eci,
       this.verificationId,
  });

  factory ThreeDSecure.fromJson(Map<String, dynamic> json) => ThreeDSecure(
    eci: json["eci"],
    verificationId: json["verificationId"],
  );

  Map<String, dynamic> toJson() => {
    "eci": eci,
    "verificationId": verificationId,
  };
}

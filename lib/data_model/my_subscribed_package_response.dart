// To parse this JSON data, do
//
//     final MySubscribedPackagesResponse = MySubscribedPackagesResponseFromJson(jsonString);

import 'dart:convert';

MySubscribedPackagesResponse mySubscribedPackagesResponseFromJson(
        String str) =>
    MySubscribedPackagesResponse.fromJson(json.decode(str));

// String mySubscribedPackagesResponseToJson(
//         MySubscribedPackagesResponse data) =>
//     json.encode(data.toJson());

class MySubscribedPackagesResponse {
  MySubscribedPackagesResponse({
    this.result,
    this.packages,
  });

  bool result;
  List<SubscribedPackage> packages;

  factory MySubscribedPackagesResponse.fromJson(Map<String, dynamic> json) =>
      MySubscribedPackagesResponse(
        result: json["result"] == null ? null : json["result"],
          packages: json["data"] == null
          ? []
              : List<SubscribedPackage>.from(
      json["data"].map((x) => SubscribedPackage.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id == null ? null : id,
  //       "user_id": userId == null ? null : userId,
  //       "package_id": packageId == null ? null : packageId,
  //       "start_date": startDate == null
  //           ? null
  //           : "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
  //       "end_date": endDate == null
  //           ? null
  //           : "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
  //       "remaining_visits": remainingVisits == null ? null : remainingVisits,
  //       "dates": dates == null ? null : dates,
  //       "times": times == null ? null : times,
  //       "success": success == null ? null : success,
  //       "status": status == null ? null : status,
  //     };
}

class SubscribedPackage {
  SubscribedPackage({
    this.id,
    this.name,
    this.price,
    this.logo,
    this.remainingVisits,
    this.dates,
    this.times,
    this.paymentStatus,
  });
  // int qty;
  // int userId;
  // int packageId;
  // DateTime startDate;
  // DateTime endDate;
  // bool success;
  // int status;

  int id;
  String name;
  String price;
  String logo;
  int remainingVisits;
  String dates;
  String times;
  String paymentStatus;
  factory SubscribedPackage.fromJson(Map<String, dynamic> json) =>
      SubscribedPackage(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        logo: json["logo"] == null ? null : json["logo"],
        remainingVisits: json["remaining_visits"] == null ? null : json["remaining_visits"],
        dates: json["dates"] == null ? null : json["dates"],
        times: json["times"] == null ? null : json["times"],
        paymentStatus: json["payment_status"] == null ? null : json["payment_status"],
      );
}

// To parse this JSON data, do
//
//     final packagesResponse = packagesResponseFromJson(jsonString);

import 'dart:convert';

PackagesResponse packagesResponseFromJson(String str) =>
    PackagesResponse.fromJson(json.decode(str));

String packagesResponseToJson(PackagesResponse data) =>
    json.encode(data.toJson());

class PackagesResponse {
  PackagesResponse({
    this.data,
    this.links,
    this.meta,
    this.result,
    // this.status,
  });

  List<Package> data;
  PackagesResponseLinks links;
  Meta meta;
  bool result;

  // int status;

  factory PackagesResponse.fromJson(Map<String, dynamic> json) =>
      PackagesResponse(
        data: json["data"] == null
            ? null : List<Package>.from(json["data"].map((x) => Package.fromJson(x))),
        links: json["links"] == null
            ? null : PackagesResponseLinks.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        result: json["result"] == null ? null : json["result"],
        // status: json["status"] == null ? null : json["status"],
      );


  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links == null ? null : links.toJson(),
        "meta": meta == null ? null : meta.toJson(),
        "result": result == null ? null : result,
        // "status": status == null ? null : status,
      };
}

class Package {
  Package({
    this.id,
    this.name,
    this.desc,
    // this.addedBy,
    this.customerType,
    this.logo,
    this.showPrice,
    this.qty,
    this.shippingType,
    this.duration,
    this.visitsNum,
    // this.packageItems,
    // this.createdAt,
    this.links,
  });

  int id;
  String name;
  String desc;
  // String addedBy;
  String customerType;
  String logo;
  String showPrice;
  int qty;
  String shippingType;
  int duration;
  int visitsNum;
  // List<PackageItem> packageItems;
  // DateTime createdAt;
  DatumLinks links;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        desc: json["desc"] == null ? null : json["desc"],
        // addedBy: json["added_by"] == null ? null : json["added_by"],
        customerType: json["customer_type"] == null ? null : json["customer_type"],
        logo: json["logo"] == null ? null : json["logo"],
        showPrice: json["show_price"] == null ? null : json["show_price"],
        qty: json["qty"] == null ? null : json["qty"],
        shippingType: json["shipping_type"] == null ? null : json["shipping_type"],
        duration: json["duration"] == null ? null : json["duration"],
        visitsNum: json["visits_num"] == null ? null : json["visits_num"],
        // packageItems: json["package_items"] == null
        //     ? null : List<PackageItem>.from(json["package_items"].map((x) => PackageItem.fromJson(x))),
        // createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        links:  json["links"] == null ? null : DatumLinks.fromJson(json["links"]),
      );


  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "desc": desc == null ? null : desc,
        // "added_by": addedBy == null ? null : addedBy,
        "customer_type": customerType == null ? null : customerType,
        "showPrice": showPrice == null ? null : showPrice,
        "qty": qty == null ? null : qty,
        "shipping_type": shippingType == null ? null : shippingType,
        "duration": duration == null ? null : duration,
        "visits_num": visitsNum == null ? null : visitsNum,
        // "package_items": packageItems == null
        //     ? null
        //     : List<dynamic>.from(packageItems.map((x) => x.toJson())),
        // "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "links": links == null ? null : links.toJson(),
      };
}

class DatumLinks {
  DatumLinks({
    this.package,
  });

  String package;

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        package: json["package"] == null ? null : json["package"],
      );

  Map<String, dynamic> toJson() => {
        "package": package == null ? null : package,
      };
}

class PackageItem {
  PackageItem({
    this.id,
    this.packageId,
    this.productId,
    this.qty,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int packageId;
  int productId;
  int qty;
  dynamic createdAt;
  dynamic updatedAt;

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
        id: json["id"] == null ? null : json["id"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        qty: json["qty"] == null ? null : json["qty"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "package_id": packageId == null ? null : packageId,
        "product_id": productId == null ? null : productId,
        "qty": qty == null ? null : qty,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class PackagesResponseLinks {
  PackagesResponseLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory PackagesResponseLinks.fromJson(Map<String, dynamic> json) =>
      PackagesResponseLinks(
        first: json["first"] == null ? null : json["first"],
        last: json["last"] == null ? null : json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first == null ? null : first,
        "last": last == null ? null : last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        links: json["links"] == null
            ? null
            : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "from": from == null ? null : from,
        "last_page": lastPage == null ? null : lastPage,
        "links": links == null
            ? null
            : List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "to": to == null ? null : to,
        "total": total == null ? null : total,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"] == null ? null : json["label"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label == null ? null : label,
        "active": active == null ? null : active,
      };
}

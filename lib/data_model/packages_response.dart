// To parse this JSON data, do
//
//     final packages = packagesFromJson(jsonString);

import 'dart:convert';

PackagesResponse packagesFromJson(String str) =>
    PackagesResponse.fromJson(json.decode(str));

String packagesToJson(PackagesResponse data) => json.encode(data.toJson());

class PackagesResponse {
  PackagesResponse({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<Package> data;
  PackagesLinks links;
  Meta meta;
  bool success;
  int status;

  factory PackagesResponse.fromJson(Map<String, dynamic> json) =>
      PackagesResponse(
        data: List<Package>.from(json["data"].map((x) => Package.fromJson(x))),
        links: PackagesLinks.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "success": success,
        "status": status,
      };
}

class Package {
  Package({
    this.id,
    this.name,
    this.desc,
    this.userType,
    this.userId,
    this.price,
    this.qty,
    this.createdAt,
    this.packageItems,
    this.links,
  });

  int id;
  String name;
  String desc;
  String userType;
  int userId;
  String price;
  int qty;
  dynamic createdAt;
  List<PackageItem> packageItems;
  DatumLinks links;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        userType: json["user_type"],
        userId: json["user_id"],
        price: json["price"],
        qty: json["qty"],
        createdAt: json["created_at"],
        packageItems: List<PackageItem>.from(
            json["package_items"].map((x) => PackageItem.fromJson(x))),
        links: DatumLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "user_type": userType,
        "user_id": userId,
        "price": price,
        "qty": qty,
        "created_at": createdAt,
        "package_items":
            List<dynamic>.from(packageItems.map((x) => x.toJson())),
        "links": links.toJson(),
      };
}

class DatumLinks {
  DatumLinks({
    this.package,
  });

  String package;

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        package: json["package"],
      );

  Map<String, dynamic> toJson() => {
        "package": package,
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
        id: json["id"],
        packageId: json["package_id"],
        productId: json["product_id"],
        qty: json["qty"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "product_id": productId,
        "qty": qty,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class PackagesLinks {
  PackagesLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory PackagesLinks.fromJson(Map<String, dynamic> json) => PackagesLinks(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
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
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
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
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}

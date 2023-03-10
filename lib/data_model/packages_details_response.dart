// To parse this JSON data, do
//
//     final packageDetailsResponse = packageDetailsResponseFromJson(jsonString);

import 'dart:convert';

PackageDetailsResponse packageDetailsResponseFromJson(String str) =>
    PackageDetailsResponse.fromJson(json.decode(str));

// String packageDetailsResponseToJson(PackageDetailsResponse data) =>
//     json.encode(data.toJson());

class PackageDetailsResponse {
  PackageDetailsResponse({
    this.id,
    this.name,
    this.desc,
    this.customerType,
    this.showPrice,
    this.qty,
    this.shippingType,
    this.duration,
    this.visitsNum,
    this.packageItems,
    this.packageVisits,
    this.result,
  });

  int id;
  String name;
  String desc;

  String customerType;
  String showPrice;
  int qty;
  String shippingType;
  int duration;
  int visitsNum;

  List<PackageItem> packageItems;
  List<PackageVisit> packageVisits;

  bool result;
  // int status;

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) =>
      PackageDetailsResponse(
        id: json["data"]["id"],
        name: json["data"]["name"],
        desc: json["data"]["desc"],

        customerType: json["data"]["customer_type"],
        showPrice: json["data"]["show_price"],
        qty: json["data"]["qty"],
        shippingType: json["data"]["shipping_type"],
        duration: json["data"]["duration"],
        visitsNum: json["data"]["visits_num"],

        packageItems: json["data"]["products"] == null
            ? []
            : List<PackageItem>.from(
                json["data"]["products"].map((x) => PackageItem.fromJson(x))),
        packageVisits: json["data"]["dates"] == null
            ? []
            : List<PackageVisit>.from(
                json["data"]["dates"].map((x) => PackageVisit.fromJson(x))),
        result: json["data"]["result"] == null ? null : json["data"]["result"],
        // status: json["data"]["status"],
        // price: json["price"],
      );

  //
  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name,
  //       "desc": desc,
  //       "user_type": userType,
  //       "user_id": userId,
  //       "price": price,
  //       "qty": qty,
  //       "created_at": createdAt,
  //       "package_items": packageItems == null
  //           ? []
  //           : List<dynamic>.from(packageItems.map((x) => x.toJson())),
  //       "result": result == null ? null : result,
  //       "status": status,
  //     };
}

class PackageItem {
  PackageItem({
    this.id,
    // this.packageId,
    // this.productId,
    this.name,
    this.price,
    this.qty,
    this.logo,
    this.unit,
    // this.createdAt,
    // this.updatedAt,
    // this.product,
  });

  int id;
  // int packageId;
  // int productId;
  String name;
  String price;
  int qty;
  String logo;
  String unit;
  // dynamic createdAt;
  // dynamic updatedAt;
  // Product product;

  // factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
  //       id: json["id"],
  //       packageId: json["package_id"],
  //       productId: json["product_id"],
  //       qty: json["qty"],
  //       price: json["price"],
  //       // createdAt: json["created_at"],
  //       // updatedAt: json["updated_at"],
  //       product: Product.fromJson(json["product"]),
  //     );

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    // print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    // print(json);
    return PackageItem(
      id: json["id"],
      // packageId: json["package_id"],
      // productId: json["product_id"],
      name: json['name'],
      price: json["price"],
      qty: json["qty"],
      logo: json["logo"],
      unit: json["unit"],
      // createdAt: json["created_at"],
      // updatedAt: json["updated_at"],
      // product: Product.fromJson(json["product"]),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "package_id": packageId,
  //       "product_id": productId,
  //       "qty": qty,
  //       // "created_at": createdAt,
  //       // "updated_at": updatedAt,
  //       "product": product.toJson(),
  //     };
}

class PackageVisit {
  PackageVisit({
    this.date,
    this.name,
    this.startTime,
    this.endTime,
    this.isSelected,
  });

  String date;
  String name;
  String startTime;
  String endTime;
  bool isSelected;

  factory PackageVisit.fromJson(Map<String, dynamic> json) {
    print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    print(json);
    return PackageVisit(
      date: json["date"],
      name: json['name'],
      startTime: json["start_time"],
      endTime: json["end_time"],
      isSelected: json["is_selected"],
    );
  }

// Map<String, dynamic> toJson() => {
//       "id": id,
//       "package_id": packageId,
//       "product_id": productId,
//       "qty": qty,
//       // "created_at": createdAt,
//       // "updated_at": updatedAt,
//       "product": product.toJson(),
//     };
}

class Product {
  Product({
    this.id,
    this.name,
    this.addedBy,
    this.wholesaleProduct,
    this.thumbnailImage,
    this.hasDiscount,
    this.strokedPrice,
    this.mainPrice,
    this.rating,
    this.sales,
    this.unit,
    this.returnPolicy,
    this.zones,
    // this.category,
    // this.brand,
    // this.links,
  });

  int id;
  String name;
  String addedBy;
  String wholesaleProduct;
  String thumbnailImage;
  bool hasDiscount;
  String strokedPrice;
  String mainPrice;
  int rating;
  int sales;
  dynamic unit;
  dynamic returnPolicy;
  List<dynamic> zones;
  // Category category;
  // Brand brand;
  // Links links;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        wholesaleProduct: json["wholesale_product"] == null
            ? null
            : json["wholesale_product"],
        thumbnailImage:
            json["thumbnail_image"] == null ? null : json["thumbnail_image"],
        hasDiscount: json["has_discount"] == null ? null : json["has_discount"],
        strokedPrice:
            json["stroked_price"] == null ? null : json["discounted_price"],
        mainPrice: json["main_price"] == null ? null : json["main_price"],
        rating: json["rating"] == null ? null : json["rating"],
        sales: json["sales"] == null ? null : json["sales"],
        unit: json["unit"],
        returnPolicy: json["return_policy"],
        zones: json["zones"] == null
            ? null
            : List<dynamic>.from(json["zones"].map((x) => x)),
        // category: json["category"] == null ? null : Category.fromJson(json["category"]),
        // brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        // links: json["links"] == null ? null : Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "added_by": addedBy == null ? null : addedBy,
        "wholesale_product": wholesaleProduct == null ? null : wholesaleProduct,
        "thumbnail_image": thumbnailImage == null ? null : thumbnailImage,
        "has_discount": hasDiscount == null ? null : hasDiscount,
        "stroked_price": strokedPrice == null ? null : strokedPrice,
        "main_price": mainPrice == null ? null : mainPrice,
        "rating": rating == null ? null : rating,
        "sales": sales == null ? null : sales,
        "unit": unit,
        "return_policy": returnPolicy,
        "zones": zones == null ? null : List<dynamic>.from(zones.map((x) => x)),
        // "category": category == null ? null : category.toJson(),
        // "brand": brand == null ? null : brand.toJson(),
        // "links": links == null ? null : links.toJson(),
      };
}

class ProductTranslation {
  ProductTranslation({
    this.id,
    this.productId,
    this.name,
    this.unit,
    this.description,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int productId;
  String name;
  String unit;
  String description;
  String lang;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductTranslation.fromJson(Map<String, dynamic> json) =>
      ProductTranslation(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        unit: json["unit"],
        description: json["description"],
        lang: json["lang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "unit": unit,
        "description": description,
        "lang": lang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Tax {
  Tax({
    this.id,
    this.productId,
    this.taxId,
    this.tax,
    this.taxType,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int productId;
  int taxId;
  int tax;
  String taxType;
  DateTime createdAt;
  DateTime updatedAt;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"],
        productId: json["product_id"],
        taxId: json["tax_id"],
        tax: json["tax"],
        taxType: json["tax_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "tax_id": taxId,
        "tax": tax,
        "tax_type": taxType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

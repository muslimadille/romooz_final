// To parse this JSON data, do

//

//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);

// https://app.quicktype.io/

import 'dart:convert';

ProductDetailsResponse productDetailsResponseFromJson(String str) =>
    ProductDetailsResponse.fromJson(json.decode(str));

String productDetailsResponseToJson(ProductDetailsResponse data) =>
    json.encode(data.toJson());

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.detailed_products,
    this.success,
    this.status,
    this.result,
    this.message,
  });

  List<DetailedProduct> detailed_products;

  bool success;

  int status;

  bool result;
  String message;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailsResponse(
        detailed_products: json["data"] == null
            ? null
            : List<DetailedProduct>.from(
                json["data"].map((x) => DetailedProduct.fromJson(x))),
        success: json["success"],
        status: json["status"],
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": detailed_products == null
            ? null
            : List<dynamic>.from(detailed_products.map((x) => x.toJson())),
        "success": success,
        "status": status,
        "result": result,
        "message": message,
      };
}

class DetailedProduct {
  DetailedProduct(
      {this.id,
      this.name,
      this.added_by,
      this.seller_id,
      this.shop_id,
      this.shop_name,
      this.shop_logo,
      this.photos,
      this.thumbnail_image,
      this.tags,
      this.price_high_low,
      this.choice_options,
      this.colors,
      this.has_discount,
      this.stroked_price,
      this.main_price,
      this.calculable_price,
      this.currency_symbol,
      this.current_stock,
      //this.unit,
      this.rating,
      this.rating_count,
      this.earn_point,
      this.description,
      this.video_link,
      this.link,
      this.brand});

  int id;

  String name;

  String added_by;

  int seller_id;

  int shop_id;

  String shop_name;

  String shop_logo;

  List<Photo> photos;

  String thumbnail_image;

  List<String> tags;

  String price_high_low;

  List<ChoiceOption> choice_options;

  List<dynamic> colors;

  bool has_discount;

  String stroked_price;

  String main_price;

  var calculable_price;

  String currency_symbol;

  int current_stock;

  Unit unit;

  int rating;

  int rating_count;

  int earn_point;

  String description;

  String video_link;

  String link;

  Brand brand;

  factory DetailedProduct.fromJson(Map<String, dynamic> json) =>
      DetailedProduct(
        id: json["id"],
        name: json["name"],
        added_by: json["added_by"],
        seller_id: json["seller_id"],
        shop_id: json["shop_id"],
        shop_name: json["shop_name"],
        shop_logo: json["shop_logo"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        thumbnail_image: json["thumbnail_image"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        price_high_low: json["price_high_low"],
        choice_options: List<ChoiceOption>.from(
            json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
        colors: List<String>.from(json["colors"].map((x) => x)),
        has_discount: json["has_discount"],
        stroked_price: json["stroked_price"],
        main_price: json["main_price"],
        calculable_price: json["calculable_price"],
        currency_symbol: json["currency_symbol"],
        current_stock: json["current_stock"],
        // unit: Unit.fromJson(json["unit"]),
        rating: json["rating"].toInt(),
        rating_count: json["rating_count"],
        earn_point: json["earn_point"].toInt(),
        description: json["description"] == null || json["description"] == ""
            ? "No Description is available"
            : json['description'],
        video_link: json["video_link"],
        link: json["link"],
        brand: Brand.fromJson(json["brand"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "added_by": added_by,
        "seller_id": seller_id,
        "shop_id": shop_id,
        "shop_name": shop_name,
        "shop_logo": shop_logo,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "thumbnail_image": thumbnail_image,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "price_high_low": price_high_low,
        "choice_options":
            List<dynamic>.from(choice_options.map((x) => x.toJson())),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "has_discount": has_discount,
        "stroked_price": stroked_price,
        "main_price": main_price,
        "calculable_price": calculable_price,
        "currency_symbol": currency_symbol,
        "current_stock": current_stock,
        //"unit": unit.toJson(),
        "rating": rating,
        "rating_count": rating_count,
        "earn_point": earn_point,
        "description": description,
        "video_link": video_link,
        "link": link,
        "brand": brand.toJson(),
      };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.logo,
  });

  int id;

  String name;

  String logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String variant;

  String path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        variant: json["variant"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "variant": variant,
        "path": path,
      };
}

/////unit

class Unit {
  Unit({this.id, this.name});

  int id;

  String name;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    this.options,
  });

  String name;

  String title;

  List<String> options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}

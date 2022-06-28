// To parse this JSON data, do
//
//     final packageDetailsResponse = packageDetailsResponseFromJson(jsonString);

import 'dart:convert';

PackageDetailsResponse packageDetailsResponseFromJson(String str) =>
    PackageDetailsResponse.fromJson(json.decode(str));

String packageDetailsResponseToJson(PackageDetailsResponse data) =>
    json.encode(data.toJson());

class PackageDetailsResponse {
  PackageDetailsResponse({
    this.id,
    this.name,
    this.desc,
    this.userType,
    this.userId,
    this.price,
    this.qty,
    this.createdAt,
    this.packageItems,
    this.success,
    this.status,
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
  bool success;
  int status;

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) =>
      PackageDetailsResponse(
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
        success: json["success"],
        status: json["status"],
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
        "success": success,
        "status": status,
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
    this.product,
  });

  int id;
  int packageId;
  int productId;
  int qty;
  dynamic createdAt;
  dynamic updatedAt;
  Product product;

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
        id: json["id"],
        packageId: json["package_id"],
        productId: json["product_id"],
        qty: json["qty"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "product_id": productId,
        "qty": qty,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "product": product.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.addedBy,
    this.userId,
    this.categoryId,
    this.brandId,
    this.photos,
    this.thumbnailImg,
    this.videoProvider,
    this.videoLink,
    this.tags,
    this.description,
    this.unitPrice,
    this.purchasePrice,
    this.variantProduct,
    this.attributes,
    this.choiceOptions,
    this.colors,
    this.variations,
    this.todaysDeal,
    this.published,
    this.approved,
    this.stockVisibilityState,
    this.cashOnDelivery,
    this.featured,
    this.sellerFeatured,
    this.currentStock,
    this.unitId,
    this.minQty,
    this.lowStockQuantity,
    this.discount,
    this.discountType,
    this.discountStartDate,
    this.discountEndDate,
    this.startingBid,
    this.auctionStartDate,
    this.auctionEndDate,
    this.tax,
    this.taxType,
    this.shippingType,
    this.shippingCost,
    this.isQuantityMultiplied,
    this.estShippingDays,
    this.numOfSale,
    this.metaTitle,
    this.metaDescription,
    this.metaImg,
    this.pdf,
    this.slug,
    this.refundable,
    this.earnPoint,
    this.rating,
    this.barcode,
    this.digital,
    this.auctionProduct,
    this.fileName,
    this.filePath,
    this.externalLink,
    this.externalLinkBtn,
    this.wholesaleProduct,
    this.createdAt,
    this.updatedAt,
    this.productTranslations,
    this.taxes,
  });

  int id;
  String name;
  String addedBy;
  int userId;
  int categoryId;
  int brandId;
  String photos;
  String thumbnailImg;
  String videoProvider;
  String videoLink;
  String tags;
  String description;
  int unitPrice;
  int purchasePrice;
  int variantProduct;
  String attributes;
  String choiceOptions;
  String colors;
  dynamic variations;
  int todaysDeal;
  int published;
  int approved;
  String stockVisibilityState;
  int cashOnDelivery;
  int featured;
  int sellerFeatured;
  int currentStock;
  int unitId;
  int minQty;
  dynamic lowStockQuantity;
  int discount;
  String discountType;
  int discountStartDate;
  int discountEndDate;
  int startingBid;
  dynamic auctionStartDate;
  dynamic auctionEndDate;
  int tax;
  String taxType;
  String shippingType;
  String shippingCost;
  int isQuantityMultiplied;
  dynamic estShippingDays;
  int numOfSale;
  String metaTitle;
  String metaDescription;
  String metaImg;
  dynamic pdf;
  String slug;
  int refundable;
  int earnPoint;
  int rating;
  dynamic barcode;
  int digital;
  int auctionProduct;
  dynamic fileName;
  dynamic filePath;
  dynamic externalLink;
  String externalLinkBtn;
  int wholesaleProduct;
  DateTime createdAt;
  DateTime updatedAt;
  List<ProductTranslation> productTranslations;
  List<Tax> taxes;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        addedBy: json["added_by"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        brandId: json["brand_id"],
        photos: json["photos"],
        thumbnailImg: json["thumbnail_img"],
        videoProvider: json["video_provider"],
        videoLink: json["video_link"],
        tags: json["tags"],
        description: json["description"],
        unitPrice: json["unit_price"],
        purchasePrice: json["purchase_price"],
        variantProduct: json["variant_product"],
        attributes: json["attributes"],
        choiceOptions: json["choice_options"],
        colors: json["colors"],
        variations: json["variations"],
        todaysDeal: json["todays_deal"],
        published: json["published"],
        approved: json["approved"],
        stockVisibilityState: json["stock_visibility_state"],
        cashOnDelivery: json["cash_on_delivery"],
        featured: json["featured"],
        sellerFeatured: json["seller_featured"],
        currentStock: json["current_stock"],
        unitId: json["unit_id"],
        minQty: json["min_qty"],
        lowStockQuantity: json["low_stock_quantity"],
        discount: json["discount"],
        discountType: json["discount_type"],
        discountStartDate: json["discount_start_date"] == null
            ? null
            : json["discount_start_date"],
        discountEndDate: json["discount_end_date"] == null
            ? null
            : json["discount_end_date"],
        startingBid: json["starting_bid"],
        auctionStartDate: json["auction_start_date"],
        auctionEndDate: json["auction_end_date"],
        tax: json["tax"],
        taxType: json["tax_type"],
        shippingType: json["shipping_type"],
        shippingCost: json["shipping_cost"],
        isQuantityMultiplied: json["is_quantity_multiplied"],
        estShippingDays: json["est_shipping_days"],
        numOfSale: json["num_of_sale"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaImg: json["meta_img"],
        pdf: json["pdf"],
        slug: json["slug"],
        refundable: json["refundable"],
        earnPoint: json["earn_point"],
        rating: json["rating"],
        barcode: json["barcode"],
        digital: json["digital"],
        auctionProduct: json["auction_product"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        externalLink: json["external_link"],
        externalLinkBtn: json["external_link_btn"],
        wholesaleProduct: json["wholesale_product"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productTranslations: List<ProductTranslation>.from(
            json["product_translations"]
                .map((x) => ProductTranslation.fromJson(x))),
        taxes: List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "added_by": addedBy,
        "user_id": userId,
        "category_id": categoryId,
        "brand_id": brandId,
        "photos": photos,
        "thumbnail_img": thumbnailImg,
        "video_provider": videoProvider,
        "video_link": videoLink,
        "tags": tags,
        "description": description,
        "unit_price": unitPrice,
        "purchase_price": purchasePrice,
        "variant_product": variantProduct,
        "attributes": attributes,
        "choice_options": choiceOptions,
        "colors": colors,
        "variations": variations,
        "todays_deal": todaysDeal,
        "published": published,
        "approved": approved,
        "stock_visibility_state": stockVisibilityState,
        "cash_on_delivery": cashOnDelivery,
        "featured": featured,
        "seller_featured": sellerFeatured,
        "current_stock": currentStock,
        "unit_id": unitId,
        "min_qty": minQty,
        "low_stock_quantity": lowStockQuantity,
        "discount": discount,
        "discount_type": discountType,
        "discount_start_date":
            discountStartDate == null ? null : discountStartDate,
        "discount_end_date": discountEndDate == null ? null : discountEndDate,
        "starting_bid": startingBid,
        "auction_start_date": auctionStartDate,
        "auction_end_date": auctionEndDate,
        "tax": tax,
        "tax_type": taxType,
        "shipping_type": shippingType,
        "shipping_cost": shippingCost,
        "is_quantity_multiplied": isQuantityMultiplied,
        "est_shipping_days": estShippingDays,
        "num_of_sale": numOfSale,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_img": metaImg,
        "pdf": pdf,
        "slug": slug,
        "refundable": refundable,
        "earn_point": earnPoint,
        "rating": rating,
        "barcode": barcode,
        "digital": digital,
        "auction_product": auctionProduct,
        "file_name": fileName,
        "file_path": filePath,
        "external_link": externalLink,
        "external_link_btn": externalLinkBtn,
        "wholesale_product": wholesaleProduct,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_translations":
            List<dynamic>.from(productTranslations.map((x) => x.toJson())),
        "taxes": List<dynamic>.from(taxes.map((x) => x.toJson())),
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

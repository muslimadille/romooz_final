import 'package:active_ecommerce_flutter/data_model/packages_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/package_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PackageCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String main_price;
  String desc;
  String type;
  bool has_discount;
  Package data;

  PackageCard(
      {Key key,
      this.id,
      this.image,
      this.name,
      this.main_price,
      this.desc,
      this.data,
      this.type,
      this.has_discount})
      : super(key: key);

  @override
  _PackageCardState createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48) / 2);
    return InkWell(
      onTap: () {
        print("ProductCard ${widget.id}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PackageItems(
                has_bottomnav: false,
                packageId: widget.id,
                packageType: widget.type,
                packageName: widget.name,
              );
            },
          ),
        );
      },
      child: Card(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                // width: double.infinity,
                //height: 158,
                height: ((MediaQuery.of(context).size.width - 28) / 3),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16), bottom: Radius.zero),
                  child: widget.image!=null?
                  Image.network(widget.image):
                   Image.asset('assets/placeholder.png'),
                ),
              ),
              Text(
                widget.name,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.main_price,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app_language.$ == 'ar'?
                        "مدة الباقة":"Package duration",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        app_language.$ == 'ar'?
                        "تصنيف الباقة":"Package type",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        app_language.$ == 'ar'?
                        "عدد الزيارت":"number of visits",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.data.duration} شهور",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color2,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.data.shippingType}",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color2,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.data.visitsNum}",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color2,
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

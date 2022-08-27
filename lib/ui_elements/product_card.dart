import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  bool has_discount;

  ProductCard(
      {Key key,
      this.id,
      this.image,
      this.name,
      this.main_price,
      this.stroked_price,
      this.has_discount})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    // print((MediaQuery.of(context).size.width - 48) / );
    return InkWell(
      onTap: () {
        print("ProductCard ${widget.id}");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
          );
        }));
      },
      child: Card(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                //height: 158,
                height: ((MediaQuery.of(context).size.width - 28) / 2) + 2,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16), bottom: Radius.zero),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: widget.image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            widget.main_price,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        widget.has_discount
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Text(
                                  widget.stroked_price,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: MyTheme.medium_grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  // suffixIcon: Container(
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: new IconButton(
                        icon: new Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 17,
                        ),
                        onPressed: () async {
                          if (is_logged_in.$ == false) {
                            ToastComponent.showDialog(
                                AppLocalizations.of(context)
                                    .common_login_warning,
                                context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                            return;
                          }

                          // print(widget.id);
                          // print(_variant);
                          // print(user_id.$);
                          // print(_quantity);

                          var cartAddResponse = await CartRepository()
                              .getCartAddResponse(
                                  widget.id, "", user_id.$, "1");

                          if (cartAddResponse.result == false) {
                            ToastComponent.showDialog(
                                cartAddResponse.message, context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);
                            return;
                          } else {
                            // ToastComponent.showDialog(cartAddResponse.message, context,
                            //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                AppLocalizations.of(context)
                                    .product_details_screen_snackbar_added_to_cart,
                                style: TextStyle(color: MyTheme.font_grey),
                              ),
                              backgroundColor: MyTheme.soft_accent_color,
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: AppLocalizations.of(context)
                                    .product_details_screen_snackbar_show_cart,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Cart(has_bottomnav: false);
                                  }));
                                },
                                textColor: MyTheme.accent_color,
                                disabledTextColor: Colors.grey,
                              ),
                            ));
                            // ,
                            //  if (snackbar != null && context != null) {
                            //    Scaffold.of(context).showSnackBar(snackbar);
                            //  }
                          }
                        }),
                  )
                ],
              ),
            ]),
      ),
    );
  }
}

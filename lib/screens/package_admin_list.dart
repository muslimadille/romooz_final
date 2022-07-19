import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/reg_ex_inpur_formatter.dart';
import 'package:active_ecommerce_flutter/repositories/packages_repository.dart';
import 'package:active_ecommerce_flutter/screens/package_user_list.dart';
import 'package:active_ecommerce_flutter/ui_elements/package_card.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class PackagesList extends StatefulWidget {
  @override
  _PackagesListState createState() => _PackagesListState();
}

class _PackagesListState extends State<PackagesList> {
  ScrollController _scrollController;
  TextEditingController _packageController = TextEditingController();
  TextEditingController _packageDescController = TextEditingController();

  final _packageValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  onPressProceed() async {
    var title = _packageController.text.toString();
    var desc = _packageDescController.text.toString();

    if (title == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).packages_screen_name_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (desc == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).packages_screen_desc_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addPackageReponse =
        await PackagesRepository().createPackage(name: title, desc: desc);

    if (addPackageReponse.package == null) {
      ToastComponent.showDialog(addPackageReponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    print("addPackageReponse${addPackageReponse.packageId}");

    ToastComponent.showDialog(addPackageReponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    Navigator.of(context, rootNavigator: true).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PackagesUserList();
        },
      ),
    );
  }

  // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //   return RechargeWallet(amount: amount );
  //

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).home_screen_packges,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          contentPadding:
              EdgeInsets.only(top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
          content: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(AppLocalizations.of(context).title_packges,
                        style:
                            TextStyle(color: MyTheme.font_grey, fontSize: 12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 40,
                      child: TextField(
                        controller: _packageController,
                        autofocus: false,
                        // keyboardType:
                        //     TextInputType.numberWithOptions(decimal: true),
                        // inputFormatters: [_packageValidator],
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).title_add_packges,
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: MyTheme.textfield_grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.textfield_grey, width: 0.5),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.textfield_grey, width: 1.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0),
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 40,
                      child: TextField(
                        controller: _packageDescController,
                        autofocus: false,
                        // keyboardType:
                        //     TextInputType.numberWithOptions(decimal: true),
                        // inputFormatters: [_packageValidator],
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).desc_add_packges,
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: MyTheme.textfield_grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.textfield_grey, width: 0.5),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.textfield_grey, width: 1.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0),
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlatButton(
                    minWidth: 75,
                    height: 30,
                    color: Color.fromRGBO(253, 253, 253, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            BorderSide(color: MyTheme.light_grey, width: 1.0)),
                    child: Text(
                      AppLocalizations.of(context).common_close_in_all_capital,
                      style: TextStyle(
                        color: MyTheme.font_grey,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: FlatButton(
                    minWidth: 75,
                    height: 30,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side:
                            BorderSide(color: MyTheme.light_grey, width: 1.0)),
                    child: Text(
                      AppLocalizations.of(context).common_proceed,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (is_logged_in.$ == true) {
                        onPressProceed();
                      } else {
                        ToastComponent.showDialog(
                            AppLocalizations.of(context).common_login_warning,
                            context,
                            gravity: Toast.CENTER,
                            duration: Toast.LENGTH_LONG);
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: PackagesRepository().getAdminPackages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            /*print("product error");
            print(snapshot.error.toString());*/
            return Container();
          } else if (snapshot.hasData) {
            var packageResponse = snapshot.data;
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16.0,
                    16.0,
                    16.0,
                    0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).romooz_packges,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: packageResponse.data.length,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print("PackageCard${packageResponse.data[index].id}");
                    return PackageCard(
                      id: packageResponse.data[index].id,
                      data: packageResponse.data[index],
                      image: "",
                      type: "admin",
                      name: packageResponse.data[index].name,
                      main_price: packageResponse.data[index].price,
                      desc: packageResponse.data[index].desc,
                      has_discount: false,
                    );
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: Color.fromRGBO(252, 252, 252, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context).add_packges,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        buildShowAddFormDialog(context);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}

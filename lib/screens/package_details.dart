import 'package:active_ecommerce_flutter/data_model/daily_time_delivery_response.dart';
import 'package:active_ecommerce_flutter/data_model/packages_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/subscribed_package_show_response.dart';
import 'package:active_ecommerce_flutter/helpers/hyperpay/checkout_view.dart';
import 'package:active_ecommerce_flutter/repositories/packages_repository.dart';
import 'package:active_ecommerce_flutter/screens/shipping_info.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart' as intllll;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PackageItems extends StatefulWidget {
  PackageItems(
      {Key key,
      this.has_bottomnav,
      this.packageId,
      this.packageType,
      this.packageName,
      this.numberOfVisits})
      : super(key: key);
  final bool has_bottomnav;

  final int packageId;
  final String packageType;

  final String packageName;

  final int numberOfVisits;
  @override
  _PackageItemsState createState() => _PackageItemsState();
}

class _PackageItemsState extends State<PackageItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  TimeOfDay selectedTime = TimeOfDay.now();
  // var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  List<PackageItem> _shopList = [];

  List<Day> _dayList = [];

  List<Day> _selectedDay = [];
  String _selectedDayString = null;
  String _selectedDayStringName = null;

  SubscribedPackageShowResponse subscribed_package_show_response =
      SubscribedPackageShowResponse();

  // time and date new style   --Muhammad--
  final _currentDate = DateTime.now();
  var formatter = new intllll.DateFormat('yyyy-MM-dd h:mm a');
  var dayNameFormatter = new intllll.DateFormat('EEEE');
  var timeFormatter = new intllll.DateFormat('h:mm a');

  // List<DateTime> dates = [];
  List<bool> checkedDays = [];
  List<DateTime> visits = [];

  int numberOfSelectedDays = 0;
  String chosenDaysStr, chosenTimesStr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeDateDelivery();
    getSubscribedPackageShow();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/
    print("package --- ${widget.packageType} ${widget.packageId}");

    if (is_logged_in.$ == true && widget.packageType == 'user') {
      fetchData2();
    } else {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchData() async {
    var cartResponseData =
        await PackagesRepository().getAdminPackagesDetails(widget.packageId);
    var cartResponseList = cartResponseData.packageItems;
    _cartTotalString = cartResponseData.showPrice;
    print("cartResponseList${_cartTotalString}");
    // if (cartResponseData != null) {
    //   _shopList = cartResponseList;
    // }
    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
    }
    _isInitial = false;
    _cartTotal = 0.00;
    // getSetCartTotal();
    setState(() {});
  }

  fetchData2() async {
    var cartResponseData =
        await PackagesRepository().getUserPackagesDetails(widget.packageId);
    var cartResponseList = cartResponseData.packageItems;
    _cartTotalString = cartResponseData.showPrice;

    print("cartResponseList${cartResponseData.showPrice}");
    // if (cartResponseData != null) {
    //   _shopList = cartResponseList;
    // }
    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
    }
    _isInitial = false;
    _cartTotal = 0.00;
    // getSetCartTotal();
    setState(() {});
  }

  getTimeDateDelivery() async {
    var timeResponseData =
        await PackagesRepository().getDailyTimeDeliveryResponse();
    var timeResponseDataList = timeResponseData.days;

    print("timeResponseDataList${timeResponseDataList}");
    // if (cartResponseData != null) {
    //   _shopList = cartResponseList;
    // }
    if (timeResponseDataList != null && timeResponseDataList.length > 0) {
      _dayList = timeResponseDataList;
      checkedDays = [];
      numberOfSelectedDays = 0;
      for (int i = 0; i < _dayList.length; i++) {
        //dates.add(_currentDate.add(Duration(days: i)));
        checkedDays.add(false);
        // print(DateTime.parse(formatter.format(_currentDate)+' '+_dayList[i].startTime));
        // print();

        //must be _dayList[index].date
        visits.add(DateTime(
            _currentDate.year, _currentDate.month, _currentDate.day, 10, 0));
        // visits.add(DateTime.parse(formatter.format(_currentDate)+' '+_dayList[i].startTime));
      }
    }

    // getSetCartTotal();
    setState(() {});
  }

  getSubscribedPackageShow() async {
    var packgeResponseData = await PackagesRepository()
        .getSubscribedPackageShowResponse(widget.packageId);

    print("packgeResponseData${packgeResponseData.id} ${widget.packageId}");

    // getSetCartTotal();
    setState(() {
      subscribed_package_show_response = packgeResponseData;
    });

    print(
        "packgeResponseData${packgeResponseData.id} ${widget.packageId} ${subscribed_package_show_response.id}");
  }

  getSetCartTotal() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((package_item) {
        // _cartTotal += double.parse(
        //     ((package_item.product. + cart_item.tax) * cart_item.quantity)
        //         .toStringAsFixed(2));
        // _cartTotalString =
        //     "${package_item.currency_symbol}${_cartTotal.toStringAsFixed(2)}";
      });
    }

    setState(() {});
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    // if (_shopList[index].cart_items.length > 0) {
    //   _shopList[index].cart_items.forEach((cart_item) {
    //     partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
    //     partialTotalString =
    //         "${cart_item.currency_symbol}${partialTotal.toStringAsFixed(2)}";
    //   });
    // }

    return partialTotalString;
  }

  onQuantityIncrease(item_index) {
    if (_shopList[item_index].qty < 200) {
      _shopList[item_index].qty++;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context).package_screen_cannot_order_more_than} 200 ${AppLocalizations.of(context).package_screen_items_of_this}",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
    // ${_shopList[item_index].upper_limit}
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[item_index].qty > 1) {
      _shopList[item_index].qty--;
      getSetCartTotal();
      setState(() {});
    } else {
      //_shopList[item_index].lower_limit

      //_shopList[item_index].upper_limit

      ToastComponent.showDialog(
          "${AppLocalizations.of(context).package_screen_cannot_order_more_than} 1 ${AppLocalizations.of(context).package_screen_items_of_this}",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onPressDelete(cart_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context).package_screen_sure_remove_item,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).package_screen_cancel,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                FlatButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context).package_screen_confirm,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(cart_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(cart_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      reset();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  onPressSubscribeAdminPackages() async {
    var replacingTime = selectedTime.replacing(
        hour: selectedTime.hour, minute: selectedTime.minute);

    String formattedTime =
        replacingTime.hour.toString() + ":" + replacingTime.minute.toString();

    print("_selectedDay${_selectedDay} ${formattedTime}");

    print("selectedTime${formattedTime} ${widget.packageId}");
    var subscribeProcessResponse = await PackagesRepository()
        .subscribeAdminPackages(
            widget.packageId, _selectedDayString, formattedTime);

    if (subscribeProcessResponse.result == false) {
      ToastComponent.showDialog(subscribeProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(subscribeProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CheckoutView(
            order_id: subscribeProcessResponse.user_package_id.toString());
      }));
    }
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    // if (_shopList.length > 0) {
    //   _shopList.forEach((shop) {
    //     if (shop.cart_items.length > 0) {
    //       shop.cart_items.forEach((cart_item) {
    //         cart_ids.add(cart_item.id);
    //         cart_quantities.add(cart_item.quantity);
    //       });
    //     }
    //   });
    // }

    // if (cart_ids.length == 0) {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context).package_screen_cart_empty, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShippingInfo();
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  bool validChoices() {
    chosenDaysStr = chosenTimesStr = "";
    if (numberOfSelectedDays != widget.numberOfVisits) return false;
    for (var index = 0; index < visits.length; index++) {
      if (checkedDays[index]) {
        if (chosenDaysStr.isNotEmpty) chosenDaysStr += ',';
        chosenDaysStr += _dayList[index].id.toString();

        if (chosenTimesStr.isNotEmpty) chosenTimesStr += ',';
        chosenTimesStr += visits[index].hour.toString() +
            ':' +
            visits[index].minute.toString();
      }
    }
    print('fffffffffffffffffffffffffff');
    print(chosenDaysStr);
    print(chosenTimesStr);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.has_bottomnav);
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildCartSellerList(),
                        ),
                        Container(
                          height: widget.has_bottomnav ? 140 : 100,
                        )
                      ]),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomContainer(),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          )),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      // height: widget.has_bottomnav ? 230 : 180,
      height: widget.has_bottomnav ? 190 : 140,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container(
            //   height: 40,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(8.0),
            //       color: MyTheme.soft_accent_color),
            //   child: Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: Row(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //           child: Text(
            //             "${selectedTime.format(context)}",
            //             style:
            //                 TextStyle(color: MyTheme.font_grey, fontSize: 14),
            //           ),
            //         ),
            //         Spacer(),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //           child: Text("${_selectedDayStringName ?? ""}",
            //               style: TextStyle(
            //                   color: MyTheme.accent_color,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: MyTheme.soft_accent_color),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .package_screen_total_amount,
                        style:
                            TextStyle(color: MyTheme.font_grey, fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("$_cartTotalString",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                    height: 38,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius: app_language_rtl.$
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: Colors.greenAccent,
                      shape: app_language_rtl.$
                          ? RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(0.0),
                              bottomLeft: const Radius.circular(0.0),
                              topRight: const Radius.circular(8.0),
                              bottomRight: const Radius.circular(8.0),
                            ))
                          : RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              bottomLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(0.0),
                              bottomRight: const Radius.circular(0.0),
                            )),
                      child: Text(
                        AppLocalizations.of(context).package_screen_time_choose,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        //onPressUpdate();
                        await selectVisits();
                        // _showMultiSelect(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius: app_language_rtl.$
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: subscribed_package_show_response.id != null
                          ? MyTheme.accent_color
                          : MyTheme.accent_color2,
                      shape: app_language_rtl.$
                          ? RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              bottomLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(0.0),
                              bottomRight: const Radius.circular(0.0),
                            ))
                          : RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(0.0),
                              bottomLeft: const Radius.circular(0.0),
                              topRight: const Radius.circular(8.0),
                              bottomRight: const Radius.circular(8.0),
                            )),
                      child: Text(
                        subscribed_package_show_response.id != null
                            ? AppLocalizations.of(context)
                                .package_screen_proceed_to_shipping_exist
                            : AppLocalizations.of(context)
                                .package_screen_proceed_to_shipping,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        if (validChoices()) {
                          var subscribeProcessResponse =
                              await PackagesRepository().subscribeAdminPackages(
                                  widget.packageId,
                                  chosenDaysStr,
                                  chosenTimesStr);

                          if (subscribeProcessResponse.status == false ||
                              subscribeProcessResponse.result == false) {
                            ToastComponent.showDialog(
                                subscribeProcessResponse.message, context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);
                          } else if (subscribeProcessResponse.result == true) {
                            ToastComponent.showDialog(
                                subscribeProcessResponse.message, context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CheckoutView(
                                order_id: subscribeProcessResponse
                                    .user_package_id
                                    .toString(),
                                order_type: "2",
                              );
                            }));
                          }
                        } else
                          ToastComponent.showDialog(
                              'يجب تحديب ' +
                                  widget.numberOfVisits.toString() +
                                  ' من الايام للزيارة',
                              context,
                              gravity: Toast.CENTER,
                              duration: Toast.LENGTH_LONG);
                      },
                      // onPressed: subscribed_package_show_response.id != null
                      //     ? () {
                      //         onPressSubscribeAdminPackages();
                      //         print(
                      //             "subscribed_package_show_response${subscribed_package_show_response}");
                      //       }
                      //     : () {
                      //         onPressSubscribeAdminPackages();
                      //         print(
                      //             "subscribed_package_show_response${subscribed_package_show_response.id}");
                      //       },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> selectVisits() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                  // height: mainHeight * .7,
                  height: 600,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('تحديد الزيارات', style: TextStyle(fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Expanded(
                          child: ListView.builder(
                              itemCount: _dayList.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Checkbox(
                                      value: checkedDays[index],
                                      onChanged: (bool value) {
                                        setState(() {
                                          if (value == true &&
                                              numberOfSelectedDays ==
                                                  widget.numberOfVisits) {
                                            ToastComponent.showDialog(
                                                'يجب الاتتعدي ' +
                                                    widget.numberOfVisits
                                                        .toString() +
                                                    ' من الايام للزيارة',
                                                context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_LONG);
                                            return;
                                          }

                                          if (value == true) {
                                            numberOfSelectedDays++;
                                          } else {
                                            numberOfSelectedDays--;
                                          }

                                          checkedDays[index] = value;
                                        });
                                      },
                                    ),
                                    Text(_dayList[index].name),
                                    Text(formatter.format(visits[index])),
                                    // Text(visits[index]),
                                    FlatButton(
                                      textColor: MyTheme.accent_color,
                                      child: Text('تغيير الوقت'),
                                      onPressed: () async {
                                        await DatePicker.showTime12hPicker(
                                            context,
                                            showTitleActions: true,
                                            onChanged: (date) {
                                          print('change $date in time zone ' +
                                              date.timeZoneOffset.inHours
                                                  .toString());
                                        }, onConfirm: (date) {
                                          if (date.hour < 10 ||
                                              date.hour > 22) {
                                            ToastComponent.showDialog(
                                                'يجب تحديد موعد مابين 10 صباخا و 10 مساءا',
                                                context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_LONG);
                                            return;
                                          }
                                          setState(() {
                                            visits[index] = new DateTime(
                                                visits[index].year,
                                                visits[index].month,
                                                visits[index].day,
                                                date.hour,
                                                date.minute);
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: app_language.$ == 'ar'
                                                ? LocaleType.ar
                                                : LocaleType.en);
                                      },
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                      RaisedButton(
                        elevation: 5.0,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'تم',
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.3,
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: MultiSelectDialogField<Day>(
                      buttonText: Text(
                        AppLocalizations.of(context)
                            .package_screen_time_day_choose,
                        style: TextStyle(color: MyTheme.accent_color),
                      ),
                      separateSelectedItems: true,
                      items: _dayList
                          .map((e) => MultiSelectItem(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      selectedColor: MyTheme.accent_color,
                      onConfirm: (values) {
                        _selectedDay = values;
                        print("_selectedDay${_selectedDay}");
                        var concatenate = StringBuffer();
                        var _selectedDayString2 = StringBuffer();
                        print("concatenate${concatenate}");
                        _selectedDay.forEach((item) {
                          concatenate.write(",${item.name}");
                          _selectedDayString2.write(",${item.id}");

                          print("item.name${item.name}");
                        });

                        this._selectedDayString =
                            _selectedDayString2.toString().substring(1);
                        this._selectedDayStringName =
                            concatenate.toString().substring(1);

                        print(
                            "_selectedDayString${this._selectedDayString}${this._selectedDayStringName}");
                      },
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(
                        AppLocalizations.of(context).package_screen_time_choose,
                        style: TextStyle(color: MyTheme.accent_color),
                      ),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: MyTheme.accent_color2, // <-- SEE HERE
                onPrimary: MyTheme.accent_color, // <-- SEE HERE
                onSurface: MyTheme.accent_color, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: MyTheme.accent_color2, // button text color
                ),
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child,
            ),
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        Navigator.pop(context);
        selectedTime = picked_s;
      });
  }

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
        "${AppLocalizations.of(context).home_screen_packges_item} ${widget.packageName ?? ""}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).package_screen_please_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shopList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildCartSellerItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).package_screen_cart_empty,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  buildCartSellerItemCard(item_index) {
    print('1111111111111111111111111111111111111111111111');
    print(_shopList[item_index].logo);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 100,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                // child: Image(image: AssetImage('assets/placeholder.png')),
                child: _shopList[item_index].logo == null
                    ? Image.asset('assets/placeholder.png')
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: "${_shopList[item_index].logo}",
                        fit: BoxFit.fitWidth,
                      ))),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "${_shopList[item_index].name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w400),
          ),
        ),
        Spacer(),
        Row(
          children: [
            Text(
              _shopList[item_index].qty.toString(),
              style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              _shopList[item_index].unit,
              style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
            ),
          ],
        ),
      ]),
    );
  }
}

// ignore_for_file: missing_return

import 'package:active_ecommerce_flutter/screens/order_details.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';

import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/my_theme.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'package:active_ecommerce_flutter/repositories/packages_repository.dart';
import 'package:active_ecommerce_flutter/data_model/my_subscribed_package_response.dart';

import 'package:shimmer/shimmer.dart';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:one_context/one_context.dart';

class PaymentStatusOrder {
  String option_key;

  String name;

  PaymentStatusOrder(this.option_key, this.name);

  static List<PaymentStatusOrder> getPaymentStatusList() {
    return <PaymentStatusOrder>[
      PaymentStatusOrder(
          '', AppLocalizations.of(OneContext().context).order_list_screen_all),
      PaymentStatusOrder('paid',
          AppLocalizations.of(OneContext().context).order_list_screen_paid),
      PaymentStatusOrder('unpaid',
          AppLocalizations.of(OneContext().context).order_list_screen_unpaid),
    ];
  }
}

class DeliveryStatus {
  String option_key;

  String name;

  DeliveryStatus(this.option_key, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus(
          '', AppLocalizations.of(OneContext().context).order_list_screen_all),
      DeliveryStatus(
          'confirmed',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_confirmed),
      DeliveryStatus(
          'on_delivery',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_on_delivery),
      DeliveryStatus(
          'delivered',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_delivered),
    ];
  }
}

class SubscribedPackages extends StatefulWidget {
  SubscribedPackages({Key key, this.from_checkout = false}) : super(key: key);

  final bool from_checkout;

  @override
  _SubscribedPackagesState createState() => _SubscribedPackagesState();
}

class _SubscribedPackagesState extends State<SubscribedPackages> {
  ScrollController _scrollController = ScrollController();

  ScrollController _xcrollController = ScrollController();

  List<PaymentStatusOrder> _paymentStatusList =
  PaymentStatusOrder.getPaymentStatusList();

  List<DeliveryStatus> _deliveryStatusList =
  DeliveryStatus.getDeliveryStatusList();

  PaymentStatusOrder _selectedPaymentStatus;

  DeliveryStatus _selectedDeliveryStatus;

  List<DropdownMenuItem<PaymentStatusOrder>> _dropdownPaymentStatusItems;

  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;

  //------------------------------------

  List<SubscribedPackage> _packagesList = [];

  bool _isInitial = true;

  int _page = 1;

  int _totalData = 0;

  bool _showLoadingContainer = false;

  String _defaultPaymentStatusKey = '';

  String _defaultDeliveryStatusKey = '';

  @override
  void initState() {
    init();

    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());

      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });

        _showLoadingContainer = true;

        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _scrollController.dispose();

    _xcrollController.dispose();

    super.dispose();
  }

  init() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
  }

  reset() {
    _packagesList.clear();

    _isInitial = true;

    _page = 1;

    _totalData = 0;

    _showLoadingContainer = false;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';

    _defaultDeliveryStatusKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();

    resetFilterKeys();

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }

    setState(() {});

    fetchData();
  }

  fetchData() async {
    var subscribedPackagesResponse = await PackagesRepository().getMySubscribedPackageResponse();

    //print("or:"+orderResponse.toJson().toString());

    _packagesList.addAll(subscribedPackagesResponse.packages);

    _isInitial = false;

    // _totalData = orderResponse.meta.total;

    _showLoadingContainer = false;

    setState(() {});
  }

  List<DropdownMenuItem<PaymentStatusOrder>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatusOrder>> items = List();

    for (PaymentStatusOrder item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }

    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = List();

    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (widget.from_checkout) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Main();
            }));
          }
        },
        child: Directionality(
          textDirection:
          app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar(context),
              body: Stack(
                children: [
                  buildPackagesListList(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildLoadingContainer())
                ],
              )),
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _packagesList.length
            ? AppLocalizations.of(context).order_list_screen_no_more_orders
            : AppLocalizations.of(context)
            .order_list_screen_loading_more_orders),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                    BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            child: new DropdownButton<PaymentStatusOrder>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedPaymentStatus,
              items: _dropdownPaymentStatusItems,
              onChanged: (PaymentStatusOrder selectedFilter) {
                setState(() {
                  _selectedPaymentStatus = selectedFilter;
                });

                reset();

                fetchData();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.credit_card,
              color: MyTheme.font_grey,
              size: 16,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.local_shipping_outlined,
              color: MyTheme.font_grey,
              size: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                    BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .35,
            child: new DropdownButton<DeliveryStatus>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDeliveryStatus,
              items: _dropdownDeliveryStatusItems,
              onChanged: (DeliveryStatus selectedFilter) {
                setState(() {
                  _selectedDeliveryStatus = selectedFilter;
                });

                reset();

                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(104.0),
      child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            new Container(),
          ],
          elevation: 0.0,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                      30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty

                      ? const EdgeInsets.only(top: 36.0)
                      : const EdgeInsets.only(top: 14.0),
                  child: buildTopAppBarContainer(),
                ),
                // buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Container buildTopAppBarContainer() {
    return Container(
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
              onPressed: () {
                if (widget.from_checkout) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Main();
                  }));
                } else {
                  return Navigator.of(context).pop();
                }
              },
            ),
          ),
          Text(
            app_language.$ == 'ar'?
            "باقاتي":"My Packages",
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
        ],
      ),
    );
  }

  buildPackagesListList() {
    if (_isInitial && _packagesList.length == 0) {
      return SingleChildScrollView(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 10,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ));
    } else if (_packagesList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _packagesList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //       return OrderDetails(
                      //         id: _packagesList[index].id,
                      //       );
                      //     }));
                    },
                    child: buildSubscribedPackageCard(index),
                  ));
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).common_no_data_available));
    } else {
      return Container(); // should never be happening

    }
  }
  Future showVisitsDetails(int packageIndex) async {
    List<String> times = _packagesList[packageIndex].times.split(',');
    await showDialog(
        context: context,
        builder: (context) {
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
                    Text('موعيد الزيارات', style: TextStyle(fontSize: 25)),
                    SizedBox(
                      height: 10,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Expanded(
                        child: ListView.builder(
                            itemCount: times.length,
                            itemBuilder: (context, index) {
                              // print('111111111111111111111111111');
                              // print(imes.length);
                              // print();
                              // print();
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Checkbox(
                                    value: index < times.length-_packagesList[packageIndex].remainingVisits,
                                    // onChanged: (bool value) {
                                    // },
                                  ),
                                  Text('السبت'),
                                  Text('20-10-2022'),
                                  Text(times[index]),
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
                        'رجوع',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
  Card buildSubscribedPackageCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Container(
          width: 70,
          height: 70,
          child:  _packagesList[index].logo == null
              ? Image.asset('assets/placeholder.png')
              : FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder.png',
            image: "${_packagesList[index].logo}",
            fit: BoxFit.fitWidth,
          )
          ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _packagesList[index].name,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  _packagesList[index].price,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlatButton(
                  child: Row(
                    children: [
                      Padding(
                        padding: app_language_rtl.$
                            ? const EdgeInsets.only(left: 8.0)
                            : const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.credit_card,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context).order_list_screen_payment_status} - ",
                            style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                          ),
                          Text(
                            _packagesList[index].paymentStatus,
                            style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                          ),
                          // Padding(
                          //   padding: app_language_rtl.$
                          //       ? const EdgeInsets.only(right: 8.0)
                          //       : const EdgeInsets.only(left: 8.0),
                          //   child: buildPaymentStatusCheckContainer(
                          //       _packagesList[index].paymentStatus),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  onPressed: ()async {
                    showVisitsDetails(index);
                  },
                ),


                FlatButton(
                  child:  Row(
                    children: [
                      Padding(
                        padding: app_language_rtl.$
                            ? const EdgeInsets.only(left: 8.0)
                            : const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Text(
                          app_language.$ == 'ar'?
                          "مواعيد الزيارات":"Visits Dates ",
                          style: TextStyle(color: MyTheme.accent_color, fontSize: 13)),

                    ],
                  ),
                  onPressed: ()async {
                    showVisitsDetails(index);
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}

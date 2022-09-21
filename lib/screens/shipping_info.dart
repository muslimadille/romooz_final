import 'package:active_ecommerce_flutter/custom/scroll_to_hide_widget.dart';
import 'package:active_ecommerce_flutter/data_model/daily_time_delivery_response.dart';
import 'package:active_ecommerce_flutter/data_model/pickup_points_response.dart';
import 'package:active_ecommerce_flutter/repositories/packages_repository.dart';
import 'package:active_ecommerce_flutter/repositories/pickup_points_repository.dart';
import 'package:active_ecommerce_flutter/screens/checkout.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart' as intlTime;


class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class ShippingInfo extends StatefulWidget {
  int owner_id;

  ShippingInfo({Key key, this.owner_id}) : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  ScrollController _mainScrollController = ScrollController();

  // integer type variables
  int _seleted_shipping_address = 0;
  int _seleted_shipping_pickup_point = 0;

  // list type variables
  List<dynamic> _shippingAddressList = [];
  List<PickupPoint> _pickupList = [];
  List<City> _cityList = [];
  // List<Country> _countryList = [];

  String _shipping_cost_string = ". . .";

  // Boolean variables
  bool isVisible = true;
  bool _isInitial = true;
  bool _shippingOptionIsAddress = true;

  DateTime _shippingSelectedDate = null;
  bool _shippingSelectedValid = false;

  //double variables
  double mWidth = 0;
  double mHeight = 0;

  List<Day> _dayList = [];

  Day _selectedDay = null;
  String _selectedDayString = null;
  String _selectedDayStringName = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchAll();
    }
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
    }

    // getSetCartTotal();
    setState(() {});
  }

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
      getTimeDateDelivery();

      if (pick_up_status.$) {
        fetchPickupPoints();
      }
      //fetchPickupPoints();
    }
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1 && _shippingOptionIsAddress) {
          _seleted_shipping_address = address.id;
        }
      });
    }
    _isInitial = false;
    setState(() {});

    getSetShippingCost();
  }

  fetchPickupPoints() async {
    var pickupPointsResponse =
        await PickupPointRepository().getPickupPointListResponse();
    _pickupList.addAll(pickupPointsResponse.data);
    if (!_shippingOptionIsAddress) {
      _seleted_shipping_pickup_point = _pickupList.first.id;
    }
    getSetShippingCost();
  }

  getSetShippingCost() async {
    var shippingCostResponse;
    if (_shippingOptionIsAddress) {
      shippingCostResponse = await AddressRepository().getShippingCostResponse(
          user_id: user_id.$, address_id: _seleted_shipping_address);
    } else {
      shippingCostResponse = await AddressRepository().getShippingCostResponse(
          user_id: user_id.$,
          pick_up_id: _seleted_shipping_pickup_point,
          shipping_type: "pickup_point");
    }

    if (shippingCostResponse.result == true) {
      _shipping_cost_string = shippingCostResponse.value_string;
      setState(() {});
    }
  }

  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _pickupList.clear();
    // _countryList.clear();
    _shipping_cost_string = ". . .";
    _shipping_cost_string = ". . .";
    _isInitial = true;
    _shippingOptionIsAddress = true;
    _seleted_shipping_pickup_point = 0;
    _seleted_shipping_address = 0;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch() async {
    _shipping_cost_string = ". . .";
    setState(() {});
    getSetShippingCost();
  }

  changeShippingOption(bool option) {
    if (option) {
      _seleted_shipping_pickup_point = 0;

      _shippingAddressList.length > 0
          ? _seleted_shipping_address = _shippingAddressList.first.id
          : _seleted_shipping_address = 0;
    } else {
      _seleted_shipping_address = 0;
      _pickupList.length > 0
          ? _seleted_shipping_pickup_point = _pickupList.first.id
          : _seleted_shipping_pickup_point = 0;
    }
    _shippingOptionIsAddress = option;
    getSetShippingCost();
    setState(() {});
  }

  onPressProceed(context) async {
    // detectShippingOption();

    //pickup point is not enable so address must be added
    if (!pick_up_status.$) {
      if (_seleted_shipping_address == 0) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)
                .shipping_info_screen_address_choice_warning,
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
        return;
      }
    }
    print('----------------11111111111111111111111');
    // pickup point is enable now we want to check address or pickup point is selected
    if (_seleted_shipping_address == 0 && _seleted_shipping_pickup_point == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .shipping_info_screen_address_or_pickup_choice_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    print('----------------222222222222222222222222222222222222');
    var addressUpdateInCartResponse;

    if (_seleted_shipping_address != 0) {
      addressUpdateInCartResponse = await AddressRepository()
          .getAddressUpdateInCartResponse(
              address_id: _seleted_shipping_address);
    } else {
      addressUpdateInCartResponse = await AddressRepository()
          .getAddressUpdateInCartResponse(
              pickup_point_id: _seleted_shipping_pickup_point);
    }
    print('----------------33333333333333333333333333333333333333');
    if (addressUpdateInCartResponse.result == false) {
      ToastComponent.showDialog(addressUpdateInCartResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_shippingSelectedDate == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).shipping_info_screen_delivery_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    print('----------------444444444444444444444444444444');
    print("_shippingSelectedDate${_shippingSelectedDate}");

    ToastComponent.showDialog(addressUpdateInCartResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        title: AppLocalizations.of(context).checkout_screen_checkout,
        isWalletRecharge: false,
        shippingSelectedDate: _shippingSelectedDate,
      );
    })).then((value) {
      onPopped(value);
    });
    // } else if (_seleted_shipping_pickup_point != 0) {
    //   print("Selected pickup point ");
    // } else {
    //   print("..........something is wrong...........");
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  // TimeOfDay selectedTime = TimeOfDay.now();
  // DateTime selectedDate = DateTime.now();
  final dateFormat = intlTime.DateFormat('yyyy - MM - dd – h:mm a');

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: buildBottomAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            displacement: 0,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 70),
                    child: CustomScrollView(
                      controller: _mainScrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _shippingOptionIsAddress
                                ? buildShippingInfoList()
                                : buildPickupPoint(),
                          ),
                          _shippingOptionIsAddress
                              ? Container(
                                  height: 40,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Address(
                                            from_shipping_info: true,
                                          );
                                        })).then((value) {
                                          onPopped(value);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .shipping_info_screen_go_to_address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: MyTheme.accent_color),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _shippingOptionIsAddress
                              ? Container(
                                  height: 40,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () async{
                                        print(
                                            "DateTime.now()${DateTime.now().year} ${app_language.$}");

                                        await DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            theme: DatePickerTheme(
                                                backgroundColor: MyTheme.white),
                                            minTime: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                10,
                                                00
                                            ),
                                            maxTime: DateTime(
                                                DateTime.now().year,
                                                (DateTime.now().month + 1) >= 12
                                                    ? 12
                                                    : (DateTime.now().month +
                                                        1),
                                                DateTime.now().day,
                                                19,
                                                59),
                                            onChanged: (date) {
                                          print(
                                              'onChanged ${_shippingSelectedDate}');
                                          var day_name = intl.DateFormat('EEEE')
                                              .format(date)
                                              .toString()
                                              .toUpperCase()
                                              .substring(0, 2);

                                          final index = _dayList.indexWhere(
                                              (element) =>
                                                  element.code == day_name);
                                          if (index >= 0) {
                                            print(
                                                'Using indexWhere: ${_dayList[index]}');
                                            setState(() {
                                              _shippingSelectedDate = date;
                                              _shippingSelectedValid = true;
                                            });
                                          } else {
                                            ToastComponent.showDialog(
                                                AppLocalizations.of(context)
                                                    .shipping_info_screen_delivery_not_valid_warning,
                                                context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_LONG);

                                            setState(() {
                                              _shippingSelectedDate = null;
                                              _shippingSelectedValid = false;
                                            });
                                          }
                                        }, onConfirm: (date) {
                                          print(
                                              'confirm ${_shippingSelectedDate}');
                                          var day_name = intl.DateFormat('EEEE')
                                              .format(date)
                                              .toString()
                                              .toUpperCase()
                                              .substring(0, 2);

                                          final index = _dayList.indexWhere(
                                              (element) =>
                                                  element.code == day_name);
                                          if (index >= 0) {
                                            print(
                                                'Using indexWhere: ${_dayList[index]}');
                                            setState(() {
                                              _shippingSelectedDate = date;
                                              _shippingSelectedValid = true;
                                            });
                                          } else {
                                            ToastComponent.showDialog(
                                                AppLocalizations.of(context)
                                                    .shipping_info_screen_delivery_not_valid_warning,
                                                context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_LONG);

                                            setState(() {
                                              _shippingSelectedDate = null;
                                              _shippingSelectedValid = false;
                                            });
                                          }
                                        },
                                            locale: app_language.$ == 'ar'
                                                ? LocaleType.ar
                                                : LocaleType.en);
                                        await DatePicker.showTime12hPicker(context, showTitleActions: true,
                                            onChanged: (date) {
                                              print('change $date in time zone ' +
                                                  date.timeZoneOffset.inHours.toString());
                                            },
                                            onConfirm: (date) {
                                              setState(() {
                                                _shippingSelectedDate = DateTime(
                                                    _shippingSelectedDate.year,
                                                    _shippingSelectedDate.month,
                                                    _shippingSelectedDate.day,
                                                    date.hour,
                                                    date.minute
                                                );
                                                _shippingSelectedValid = true;
                                              });
                                              print('confirm $date');
                                            },
                                            currentTime: DateTime.now(),
                                            locale: app_language.$ == 'ar'
                                                ? LocaleType.ar
                                                : LocaleType.en
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .shipping_info_screen_go_to_address_delivey_time,
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: MyTheme.accent_color),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _shippingSelectedDate == null
                                    ? AppLocalizations.of(context)
                                        .shipping_info_screen_delivery_warning
                                    : "${dateFormat.format(DateTime.parse(_shippingSelectedDate.toString()))}",

                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    color: MyTheme.dark_grey),
                                textDirection: app_language_rtl.$
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ]))
                      ],
                    ),
                  ),
                  Positioned(top: 0.0, child: customAppBar(context)),
                ],
              ),
            ),
          )),
    );
  }

  // Future<void> _selectTime(BuildContext context) async {
  //   print('2222222222222222222');
  //   final TimeOfDay picked_s = await showTimePicker(
  //       context: context,
  //       initialTime: selectedTime, builder: (BuildContext context, Widget child) {
  //     return MediaQuery(
  //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
  //       child: child,
  //     );});
  //
  //   if (picked_s != null && picked_s != selectedTime )
  //     setState(() {
  //       selectedTime = picked_s;
  //     });
  // }
  //
  // Future<void> _selectDate(BuildContext context) async {
  //   print('11111111111111111111');
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

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
        "${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_no_address_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          _seleted_shipping_address = _shippingAddressList[index].id;

          onAddressSwitch();
        }
        //detectShippingOption();
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_address,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _shippingAddressList[index].address,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_address ==
                            _shippingAddressList[index].id)
                  ],
                ),
              ),

              //city
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         width: 75,
              //         child: Text(
              //           AppLocalizations.of(context).shipping_info_screen_city,
              //           style: TextStyle(
              //             color: MyTheme.grey_153,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: 200,
              //         child: Text(
              //           _shippingAddressList[index].city_name,
              //           maxLines: 2,
              //           style: TextStyle(
              //               color: MyTheme.dark_grey,
              //               fontWeight: FontWeight.w600),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // state
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_state,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].state_name,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              //country
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         width: 75,
              //         child: Text(
              //           AppLocalizations.of(context)
              //               .shipping_info_screen_country,
              //           style: TextStyle(
              //             color: MyTheme.grey_153,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: 200,
              //         child: Text(
              //           _shippingAddressList[index].country_name,
              //           maxLines: 2,
              //           style: TextStyle(
              //               color: MyTheme.dark_grey,
              //               fontWeight: FontWeight.w600),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),


              // postal code
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .order_details_screen_postal_code,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].postal_code,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),


              //phone
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_phone,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].phone,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPickupPoint() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _pickupList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_pickupList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _pickupList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildPickupInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _pickupList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).no_pickup_point,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPickupInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_pickup_point != _pickupList[index].id) {
          _seleted_shipping_pickup_point = _pickupList[index].id;
          onAddressSwitch();
        }
        //detectShippingOption();
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_pickup_point == _pickupList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_address,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _pickupList[index].address,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_pickup_point == _pickupList[index].id)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).address_screen_phone,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _pickupList[index].phone,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations.of(context)
                    .shipping_info_screen_btn_proceed_to_checkout,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: MyTheme.white,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      "${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
                      style:
                          TextStyle(fontSize: 16, color: MyTheme.accent_color),
                    ),
                  )
                ],
              ),
            ),
            // container for gaping into title text and title-bottom buttons
            Container(
              padding: EdgeInsets.only(top: 2),
              width: mWidth,
              color: MyTheme.light_grey,
              height: 1,
            ),
             SizedBox(height:10),
             Text(
              AppLocalizations.of(context)
                  .address_screen_address,
              style: TextStyle(
                  color: _shippingOptionIsAddress
                      ? MyTheme.dark_grey
                      : MyTheme.medium_grey_50,
                  fontWeight: _shippingOptionIsAddress
                      ? FontWeight.w700
                      : FontWeight.normal),
            ),

            // pick_up_status.$
            //     ? ScrollToHideWidget(
            //         child: Container(
            //             color: MyTheme.white,
            //             //MyTheme.light_grey,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 FlatButton(
            //                   padding: EdgeInsets.zero,
            //                   onPressed: () {
            //                     setState(() {
            //                       changeShippingOption(true);
            //                     });
            //                   },
            //                   child: Container(
            //                       color: MyTheme.white,
            //                       height: 50,
            //                       width: (mWidth / 2) - 1,
            //                       alignment: Alignment.center,
            //                       child: Text(
            //                         AppLocalizations.of(context)
            //                             .address_screen_address,
            //                         style: TextStyle(
            //                             color: _shippingOptionIsAddress
            //                                 ? MyTheme.dark_grey
            //                                 : MyTheme.medium_grey_50,
            //                             fontWeight: _shippingOptionIsAddress
            //                                 ? FontWeight.w700
            //                                 : FontWeight.normal),
            //                       )),
            //                 ),
            //                 Container(
            //                   width: 0.5,
            //                   height: 30,
            //                   color: MyTheme.grey_153,
            //                 ),
            //                 FlatButton(
            //                   padding: EdgeInsets.zero,
            //                   onPressed: () {
            //                     setState(() {
            //                       changeShippingOption(false);
            //                     });
            //                   },
            //                   child: Container(
            //                       color: MyTheme.white,
            //                       alignment: Alignment.center,
            //                       height: 50,
            //                       width: (mWidth / 2) - 1,
            //                       child: Text(
            //                         AppLocalizations.of(context).pickup_point,
            //                         style: TextStyle(
            //                             color: _shippingOptionIsAddress
            //                                 ? MyTheme.medium_grey_50
            //                                 : MyTheme.dark_grey,
            //                             fontWeight: !_shippingOptionIsAddress
            //                                 ? FontWeight.w700
            //                                 : FontWeight.normal),
            //                       )),
            //                 ),
            //               ],
            //             )),
            //         scrollController: _mainScrollController,
            //         childHeight: 40,
            //       )
            //     : Container(),
            //:Container()
          ],
        ),
      ),
    );
  }
}

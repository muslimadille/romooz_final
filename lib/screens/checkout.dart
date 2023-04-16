import 'dart:convert';

import 'package:active_ecommerce_flutter/helpers/hyperpay/apple_pay_screen.dart';
import 'package:active_ecommerce_flutter/helpers/hyperpay/checkout_view.dart';
import 'package:active_ecommerce_flutter/screens/web_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/stripe_screen.dart';
import 'package:active_ecommerce_flutter/screens/paypal_screen.dart';
import 'package:active_ecommerce_flutter/screens/razorpay_screen.dart';
import 'package:active_ecommerce_flutter/screens/paystack_screen.dart';
import 'package:active_ecommerce_flutter/screens/iyzico_screen.dart';
import 'package:active_ecommerce_flutter/screens/bkash_screen.dart';
import 'package:active_ecommerce_flutter/screens/nagad_screen.dart';
import 'package:active_ecommerce_flutter/screens/sslcommerz_screen.dart';
import 'package:active_ecommerce_flutter/screens/flutterwave_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/coupon_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:pay/pay.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/offline_screen.dart';
import 'package:active_ecommerce_flutter/screens/paytm_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;


class Checkout extends StatefulWidget {

  int order_id; // only need when making manual payment from order details
  DateTime shippingSelectedDate;
  bool
  manual_payment_from_order_details; // only need when making manual payment from order details
  String list;
  final bool isWalletRecharge;
  final double rechargeAmount;
  final String title;

  Checkout(
      {Key key,
        this.order_id = 0,
        this.manual_payment_from_order_details = false,
        this.list = "both",
        this.isWalletRecharge = false,
        this.rechargeAmount = 0.0,
        this.shippingSelectedDate = null,
        this.title})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var _selected_payment_method_index = 0;
  // var _selected_payment_method = "";
  // var _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  var _totalString = ". . .";
  var _grandTotalValue = 0.00;
  var _subTotalString = ". . .";
  var _taxString = ". . .";
  var _shippingCostString = ". . .";
  var _discountString = ". . .";
  var _used_coupon_code = "";
  var _coupon_applied = false;
  BuildContext loadingcontext;
  String payment_type = "cart_payment";
  String _title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    print("_shippingSelectedDate${widget.shippingSelectedDate}");

    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    fetchList();

    if (is_logged_in.$ == true) {
      if (widget.isWalletRecharge || widget.manual_payment_from_order_details) {
        _grandTotalValue = widget.rechargeAmount;
        payment_type = "wallet";
      } else {
        fetchSummary();
        //payment_type = payment_type;
      }
    }
  }

  fetchList() async {
    var paymentTypeResponseList =
    await PaymentRepository().getPaymentResponseList(list: widget.list);
    paymentTypeResponseList.forEach((element) {
    });
    _paymentTypeList.addAll(paymentTypeResponseList);
    // if (_paymentTypeList.length > 0) {
    //   _selected_payment_method = _paymentTypeList[0].payment_type;
    //   _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    // }
    _isInitial = false;
    setState(() {});
  }
  fetchCartItems() async {
    var cartResponseList =
    await CartRepository().getCartResponseList(user_id.$);
    var _shopList=[];
    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
      if (_shopList.length > 0) {
        _shopList.forEach((shop) {
          /*if (shop.cart_items.length > 0) {
            shop.cart_items.forEach((cart_item) {
              double partialTotal = (cart_item.price) * cart_item.quantity;
              _paymentItems.add(
                PaymentItem(
                  label: '${cart_item.product_name}',
                  amount: '${partialTotal.toStringAsFixed(2)}',
                  status: PaymentItemStatus.unknown,
                ),);

            });
          }*/

        });
        _paymentItems.add(
          PaymentItem(
            label: 'المجموع الفرعي',
            amount: '${_subTotalString}',
            status: PaymentItemStatus.unknown,
          ),
        );
        _paymentItems.add(
          PaymentItem(
            label: 'الضرائب',
            amount: '${_taxString}',
            status: PaymentItemStatus.unknown,
          ),
        );
        _paymentItems.add(
          PaymentItem(
            label: 'تكلفة الشحن',
            amount: '${_shippingCostString}',
            status: PaymentItemStatus.unknown,
          ),
        );
        _paymentItems.add(
          PaymentItem(
            label: 'الخصم',
            amount: '${_discountString}',
            status: PaymentItemStatus.unknown,
          ),
        );

        _paymentItems.add(
          PaymentItem(
            label: 'Tasla Co',
            amount: '${_totalString}',
            status: PaymentItemStatus.unknown,
          ),
        );
      }
    }
    _isInitial = false;
    setState(() {});
  }


  fetchSummary() async {
    var cartSummaryResponse = await CartRepository().getCartSummaryResponse();

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      fetchCartItems();
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method_index = 0;
    // _selected_payment_method = "";
    // _selected_payment_method_key = "";
    setState(() {});

    reset_summary();
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code;
    _coupon_applied = false;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  onCouponApply() async {
    var coupon_code = _couponController.text.toString();
    if (coupon_code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).checkout_screen_coupon_code_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var couponApplyResponse =
    await CouponRepository().getCouponApplyResponse(coupon_code);
    if (couponApplyResponse.result == false) {
      ToastComponent.showDialog(couponApplyResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
    await CouponRepository().getCouponRemoveResponse();

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onPressPlaceOrderOrProceed() {
    // if (_selected_payment_method == "") {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context).common_payment_choice_warning, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    if (_paymentTypeList[_selected_payment_method_index].payment_type == "hyperpay_payment") {
      pay_by_cod_hyperpay();
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "paypal_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
      ;
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "apple") {
      setState(() {

      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "razorpay") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "paystack") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "iyzico") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IyzicoScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "bkash") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "nagad") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "sslcommerz_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "flutterwave") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterwaveScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "paytm") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaytmScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _paymentTypeList[_selected_payment_method_index].payment_type_key,
        );
      })).then((value) {
        onPopped(value);
      });
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "wallet_system") {
      pay_by_wallet();
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "cash_payment") {
      pay_by_cod();
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "manual_payment" &&
        widget.manual_payment_from_order_details == false) {
      pay_by_manual_payment();
    }
    else if (_paymentTypeList[_selected_payment_method_index].payment_type == "manual_payment" &&
        widget.manual_payment_from_order_details == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfflineScreen(
          order_id: widget.order_id,
          payment_type: "manual_payment",
          details: _paymentTypeList[_selected_payment_method_index].details,
          offline_payment_id: _paymentTypeList[_selected_payment_method_index]
              .offline_payment_id,
          isWalletRecharge: widget.isWalletRecharge,
          rechargeAmount: widget.rechargeAmount,
        );
      })).then((value) {
        onPopped(value);
      });
    }
  }

  pay_by_wallet() async {
    print('------------------------------------------------------');
    loading();

    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(
        _paymentTypeList[_selected_payment_method_index].payment_type_key, widget.shippingSelectedDate);

    print("orderCreateResponse =====${orderCreateResponse}");

    Navigator.of(loadingcontext).pop();
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }





    var orderPeymntFromWalletResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
      // _paymentTypeList[_selected_payment_method_index].payment_type_key, _grandTotalValue,
        orderCreateResponse.orders_id
    );

    if (orderPeymntFromWalletResponse.result == false) {
      ToastComponent.showDialog(orderPeymntFromWalletResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }
  pay_by_cod() async {
    loading();
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(
        _paymentTypeList[_selected_payment_method_index].payment_type_key, widget.shippingSelectedDate);
    Navigator.of(loadingcontext).pop();
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  pay_by_cod_hyperpay() async {
    loading();

    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(
        _paymentTypeList[_selected_payment_method_index].payment_type_key, widget.shippingSelectedDate);

    print("orderCreateResponse =====${orderCreateResponse}");

    Navigator.of(loadingcontext).pop();
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }


    _checkoutId=await getCheckoutIdServer;
    if(_checkoutId.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        String link="https://app.romooz.app/payment/${orderCreateResponse.orders_id}/$_checkoutId";
        return WebPage(link);
      }));
    }else{
      ToastComponent.showDialog(
          'Failed to get payment response',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }

   /* /// START HYPER_PAY ACTIVITY
    _getPaymentResponse();*/
  }

  pay_by_manual_payment() async {
    loading();
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromManualPayment(_paymentTypeList[_selected_payment_method_index].payment_type_key);
    Navigator.pop(loadingcontext);
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  onPaymentMethodItemTap(index) {
    setState(() {
      _selected_payment_method_index = index;
    });

  }

  onPressDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
        EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Container(
            height: 150,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_subtotal,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _subTotalString,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context).checkout_screen_tax,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _taxString,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_shipping_cost,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _shippingCostString,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_discount,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _discountString,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_grand_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _totalString,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              AppLocalizations.of(context).common_close_in_all_lower,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
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
                          child: buildPaymentMethodList(),
                        ),
                        Container(
                          height: 140,
                        )
                      ]),
                    )
                  ],
                ),
              ),

              //Apply Coupon and order details container
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.isWalletRecharge
                    ? Container()
                    : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    /*border: Border(
                      top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                    )*/
                  ),
                  height:
                  widget.manual_payment_from_order_details ? 80 : 140,
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        widget.manual_payment_from_order_details == false
                            ? Padding(
                          padding:
                          const EdgeInsets.only(bottom: 16.0),
                          child: buildApplyCouponRow(context),
                        )
                            : Container(),
                        grandTotalSection(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
          child: TextFormField(
            controller: _couponController,
            readOnly: _coupon_applied,
            autofocus: false,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)
                    .checkout_screen_enter_coupon_code,
                hintStyle:
                TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16.0)),
          ),
        ),
        !_coupon_applied
            ? Container(
          width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
          height: 42,
          child: FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            //height: 50,
            color: MyTheme.accent_color,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0),
                )),
            child: Text(
              AppLocalizations.of(context).checkout_screen_apply_coupon,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              onCouponApply();
            },
          ),
        )
            : Container(
          width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
          height: 42,
          child: FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            //height: 50,
            color: MyTheme.accent_color,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0),
                )),
            child: Text(
              AppLocalizations.of(context).checkout_screen_remove,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              onCouponRemove();
            },
          ),
        )
      ],
    );
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
        widget.title,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildPaymentMethodItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).common_no_payment_method_added,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return widget.isWalletRecharge &&
        (_paymentTypeList[index].payment_type == "wallet_system" ||
            _paymentTypeList[index].payment_type == "cash_payment")
        ? GestureDetector(
      child: Container(),
      onDoubleTap: () {},
    )
        : GestureDetector(
      onTap: () {
        onPaymentMethodItemTap(index);
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: _selected_payment_method_index == index
                  ? BorderSide(color: MyTheme.accent_color, width: 2.0)
                  : BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                          //             Image.asset(
                          //   _paymentTypeList[index].image,
                          //   fit: BoxFit.fitWidth,
                          // ),
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image:  _paymentTypeList[index].image,
                            fit: BoxFit.fitWidth,
                          )

                      )),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            _paymentTypeList[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: buildPaymentMethodCheckContainer(
                _selected_payment_method_index == index),
          )
        ],
      ),
    );
  }

  Widget buildPaymentMethodCheckContainer(bool check) {
    return Visibility(
      visible: check,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(FontAwesome.check, color: Colors.white, size: 10),
        ),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: _paymentTypeList.isNotEmpty?Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isAppleDevice()&&(_paymentTypeList[_selected_payment_method_index].payment_method_key == "apple")?Expanded(child:_applePayBtn()):FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                widget.isWalletRecharge
                    ? AppLocalizations.of(context)
                    .recharge_wallet_screen_recharge_wallet
                    : widget.manual_payment_from_order_details
                    ? AppLocalizations.of(context)
                    .common_proceed_in_all_caps
                    : AppLocalizations.of(context)
                    .checkout_screen_place_my_order,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                bool checkTerms = false;
                await showDialog(
                  // The user CANNOT close this dialog  by pressing outsite it
                  // barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                        // The background color
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('يجب الموافقة علي سياسة الشروط والاحكام قبل عمل الطلبية', style: TextStyle(fontSize: 10)),
                              SizedBox(height: 5,),
                              InkWell(
                                  child: Text('اضغط هنا للاطلاع', style: TextStyle(color: Colors.blue, fontSize: 10),),
                                  onTap: () => launch('${AppConfig.RAW_BASE_URL}/terms')
                              ),
                              SizedBox(height: 10,),
                              RaisedButton(
                                elevation: 5.0,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                onPressed: () {
                                  checkTerms = true;
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: Text(
                                  'نعم أوفق',
                                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                                ),
                              ),
                              // RaisedButton(
                              //   elevation: 5.0,
                              //   color: Colors.deepOrange,
                              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              //   onPressed: () {
                              //     Navigator.of(context, rootNavigator: true).pop();
                              //   },
                              //   child: Text(
                              //     'رجوع',
                              //     style: TextStyle(fontSize: 15.0, color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    });
                if(!checkTerms){
                  return;
                }
                onPressPlaceOrderOrProceed();
              },
            )
          ],
        ),
      ):Container(),
    );
  }

  Widget grandTotalSection() {
    return Container(
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
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                AppLocalizations.of(context).checkout_screen_total_amount,
                style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
              ),
            ),
            Visibility(
              visible: !widget.manual_payment_from_order_details,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    onPressDetails();
                  },
                  child: Text(
                    AppLocalizations.of(context).common_see_details,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                  widget.manual_payment_from_order_details
                      ? widget.rechargeAmount.toString()
                      : _totalString,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${AppLocalizations.of(context).loading_text}"),
                ],
              ));
        });
  }
  /// ======================== HYPER PAY METHODS==============================
  /// PAYMENT NATIVE CHANNEL
  static const platform = MethodChannel('hyperPayChannel');
  String _checkoutId="";
  Future<void> _getPaymentResponse() async {
    /// get checkoutId from your server
    _checkoutId=await getCheckoutIdServer;
    if(_checkoutId.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        String link="https://app.romooz.app/payment/${widget.order_id}/$_checkoutId";
        return WebPage(link);
      }));
    }else{
      ToastComponent.showDialog(
          'Failed to get payment response',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }

    /*try {
      _checkoutId=await getCheckoutIdServer;
      /// send checkoutId to native method which get payment response
      var result=await platform.invokeMethod("getPaymentMethod",<String,dynamic>{
        "checkoutId":_checkoutId
      });
      print("${result.toString()}");//TODO REMOVE PRINT

      if(result.toString()=="success"){
        setPaymentStatusToServer();
      }
      ToastComponent.showDialog(
          ' payment response  ${"${result.toString()=="البطاقة المستخدمة غير مدعمة"?"":result.toString()}"}',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    } on PlatformException catch (e) {
      ToastComponent.showDialog(
          'Failed to get payment response  ${e.message}',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }*/

  }
  Future<String> get getCheckoutIdServer async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/hyperpay-get-checkoutId");
    final response = await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization": "Bearer ${access_token.$}",
        },
        body: {
          "payment_method_key":"mada" //TODO make method dynamic
        }
    );
    final Map _resBody = json.decode(response.body);
    return _resBody['checkout_id'];
  }
  Future<void> setPaymentStatusToServer(String paymentMethod)async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/hyperpay-get-paymentStatus");
    final response = await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization": "Bearer ${access_token.$}",
        },
        body: {
          "resource_path":"v2/checkouts/${_checkoutId}/payment",
          "payment_type":"hyperpay",
          "payment_method_key":paymentMethod,//TODO make method dynamic
          "orders_id":"${widget.order_id}"
        }
    );
    final Map _resBody = json.decode(response.body);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList();
    }));
  }
  ///============== APPLEPAY==================================
  List<PaymentItem> _paymentItems = [];
  void onApplePayResult(paymentResult) {
    //setPaymentStatusToServer();
    ToastComponent.showDialog(
        ' apple pay responce  ${"${paymentResult.toString()}"}',
        context,
        gravity: Toast.CENTER,
        duration: 10);
    debugPrint(paymentResult.toString());
  }
  bool isAppleDevice(){
    return Platform.isIOS;
  }
Widget _applePayBtn(){
    return SizedBox(child: ApplePayButton(
      paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
      paymentItems: _paymentItems,
      
      style: ApplePayButtonStyle.black,
      type: ApplePayButtonType.inStore,
      margin: const EdgeInsets.all(10),
      onPaymentResult: onApplePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    ),);
}


}

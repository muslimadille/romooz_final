import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String link;
  WebPage(this.link,{Key key}) : super(key: key);
  @override
  _WebPageState createState() => _WebPageState();
}


class _WebPageState extends State<WebPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:

    WebView(
      initialUrl: widget.link,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'messageHandler',
            onMessageReceived: (JavascriptMessage message) {
              print(message.message);
              var jsonData = jsonDecode(message.message);
              if(jsonData['status'] == 'CANCELLED'){
                // Your code
              }else if(jsonData['status'] == 'SUCCESS'){
                // Your code
              }
            })
      ]),
      onPageFinished: (value){
        print("$value" );
        if (value.toString().contains("status=paid")){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        }
        if(value.toString().contains("status=failed")){
          Navigator.pop(context);
          ToastComponent.showDialog("فشل عملية الدفع حاول مرة اخري",context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }

      },
      onWebViewCreated: (WebViewController webViewController) {
        webViewController.currentUrl().then((value) {
          print("$value");
          if (value.toString().contains("status=paid")){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList(from_checkout: true);
            }));
          }
          if(value.toString().contains("status=failed")){
            Navigator.pop(context);
            ToastComponent.showDialog("فشل عملية الدفع حاول مرة اخري",context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          }
        });
      },
      navigationDelegate: (NavigationRequest request) {
        print("$request");
        if (request.url.contains("success")){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
          return NavigationDecision.prevent;
        }

        return NavigationDecision.navigate;
      },
    )

      ,);
  }
}

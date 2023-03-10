import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:active_ecommerce_flutter/screens/tickets.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:io';

class ContactUsPage extends StatefulWidget {
  static String id = 'ContactUsPage';

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  bool err = false;
  String msgErr = '';

  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                "assets/whatsapp.png",
              ),
            ),
            title: Text(
              app_language.$ == 'ar' ? 'الواتساب' : 'WhatsApp',
            ),
            // trailing: Icon(Icons.more_vert),
            onTap: () async {
              String phone = '+966550696965';
              // var whatsappUrl ="whatsapp://send?phone=$phone";
              // launch(whatsappUrl);

              /////////////////////
              String url() {
                if (Platform.isAndroid) {
                  // add the [https]
                  // return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
                  return "https://wa.me/$phone"; // new line
                } else {
                  // add the [https]
                  // return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
                  // return "https://api.whatsapp.com/send?phone=$phone"; // new line

                  return "https://wa.me/$phone"; // new line

                }
              }

              // ignore: deprecated_member_use
              await launch(url());
              ///////////////////////
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                "assets/chat.png",
              ),
            ),
            title: Text(
              AppLocalizations.of(context).main_drawer_messages,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TicketsPage();
              }));
            },
          )
        ],
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(app_language.$ == 'ar' ? 'تواصل معنا' : 'Contact Us',
          style: TextStyle(color: Colors.black, fontSize: 20.0)),
    );
  }
}

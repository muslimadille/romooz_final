import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ContactUsPage extends StatefulWidget {
  static String id = 'ContactUsPage';

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

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
              child: Image.asset("assets/whatsapp.png",
              ),
            ),
            title: Text(app_language.$ == 'ar' ? 'الواتساب' : 'WhatsApp',),
            // trailing: Icon(Icons.more_vert),
            onTap: () async{
                String phone = '+966 55 069 6965';
                var whatsappUrl ="whatsapp://send?phone=$phone";
                launch(whatsappUrl);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset("assets/chat.png",
              ),
            ),
            title: Text(AppLocalizations.of(context).main_drawer_messages,),
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return MessengerList();
            }));
          },)
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

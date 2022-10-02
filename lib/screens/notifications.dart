import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';








class NotificationPage extends StatefulWidget {
  static String id = 'NotificationPage';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

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
              backgroundColor: const Color(0xff764abc),
              child: Icon(Icons.notifications_active),
            ),
            title: Text('الاشعار الاول'),
            subtitle: Text('خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي'.substring(0,45)),
            // trailing: Icon(Icons.more_vert),
            onTap: (){

            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff764abc),
              child: Icon(Icons.notifications),
            ),
            title: Text('الاشعار الاول'),
            subtitle: Text('خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي خصم علي اول فاتورة تطلبها من رموز بحد ادني 1000 ريال سعودي'),
            trailing: Icon(Icons.more_vert),
          ),
          // Text('lllllllllllll'),
          // SizedBox(height: 100,),
          // Expanded(
          //     child: FutureBuilder<List<MyNotification>>(
          //         future: NotificationController.getAllNotifications(),
          //         builder: (context, snapshot) {
          //           if (snapshot.hasError)
          //             return new Text('Error: ${snapshot.error}');
          //           if (snapshot.hasData) {
          //             return ListView.builder(
          //                 itemCount: snapshot.data.length,
          //                 scrollDirection: Axis.vertical,
          //                 itemBuilder: (BuildContext context, int index) {
          //                   return Card(
          //                     child: Container(
          //                       height: mainHeight*.2,
          //                       padding: EdgeInsets.all(25.0),
          //                       child: Center(
          //                         child: Text(snapshot.data[index].message,  style: TextStyle(color: Colors.black, fontSize: 15.0))
          //                       ),
          //                     ),
          //                   );
          //                 }
          //             );
          //           }
          //           return Center(
          //             child: CircularProgressIndicator(),
          //           );
          //         })),
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
      title: Text(app_language.$ == 'ar' ?"الإشعارات":"Notifications",
          style: TextStyle(color: Colors.black, fontSize: 20.0)),
    );
  }
}

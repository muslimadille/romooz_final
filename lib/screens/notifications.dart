import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/notifications_repository.dart';








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
          Expanded(
              child: FutureBuilder<Map<String,dynamic>>(
                  future: NotificationRepository.getAllNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return  ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xff764abc),
                                child: snapshot.data['data'][index]['status']==0?
                                Icon(Icons.notifications_active):
                                Icon(Icons.notifications),
                              ),
                              title: Text(snapshot.data['data'][index]['title']),
                              subtitle: Text(snapshot.data['data'][index]['description']),
                              onTap: () async{
                                 Map<String,dynamic> response = await
                                 NotificationRepository.markNotificationAsRead(snapshot.data['data'][index]['id']);
                                 if(response['result']){
                                   setState(() {

                                   });
                                 }
                              },
                            );
                          }
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
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

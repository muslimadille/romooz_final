import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/tickets_repository.dart';
import 'package:active_ecommerce_flutter/screens/add_tickets.dart';
import 'package:active_ecommerce_flutter/screens/ticket_details.dart';


class TicketsPage extends StatefulWidget {
  static String id = 'TicketsPage';

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {

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
                  future: TicketsRepository.getAllTicketss(),
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
                                child: snapshot.data['data'][index]['status']=="solved"?
                                Icon(Icons.mark_email_read):
                                Icon(Icons.mail),
                              ),
                              title: Text(snapshot.data['data'][index]['subject']),
                              // subtitle: Text(snapshot.data['data'][index]['description']),
                              trailing: snapshot.data['data'][index]['viewed']==1?
                              Icon(Icons.check_circle,color: Colors.green,):
                              Icon(Icons.check_circle_outline,color: Colors.grey,),
                              onTap: () async{
                                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return TicketDetailsPage(ticketID: snapshot.data['data'][index]['id'].toString());
                                }));
                                setState(() {

                                });
                              },
                            );
                          }
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          Container(
            height: 50,
            padding: EdgeInsets.all(5),
            child:  RaisedButton(
              // elevation: 5.0,
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddTicketPage();
                }));
                setState(() {

                });
              },
              child: Text(
                app_language.$ == 'ar' ?"اضافة تذكرة":"Add Ticket",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
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
      title: Text(app_language.$ == 'ar' ?"التذاكر":"Tickets",
          style: TextStyle(color: Colors.black, fontSize: 20.0)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/tickets_repository.dart';
import 'package:active_ecommerce_flutter/screens/add_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';


class TicketDetailsPage extends StatefulWidget {
  static String id = 'TicketDetailsPage';
  final String ticketID;
  TicketDetailsPage({@required this.ticketID});
  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {

  String subject="",details="";
  List<dynamic> replies=[];

  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    //on Splash Screen hide statusbar
    super.initState();
    _controller.text = '';
    getData();
  }


  getData() async{
    Map<String,dynamic> data = await TicketsRepository.getTicketsDetails(widget.ticketID);

    setState(() {
      subject = data['subject'];
      details = data['details'];
      replies = data['replies'];
    });
  }
  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Card(
              child: Container(
                width: mainWidth,
                height: mainWidth/4,
                padding: EdgeInsets.all(10),
                child: Text(details,style: TextStyle(fontSize: 15),),
              )
          ),
          Expanded(
            child: ListView.builder(
                itemCount: replies.length,
                scrollDirection: Axis.vertical,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: replies[index]['user_id']==user_id.$?MainAxisAlignment.start:MainAxisAlignment.end,
                    children: [
                  Visibility(
                    visible: replies[index]['user_id']==user_id.$,
                    child: SizedBox(width: 10,),
                  ),
                      Card(
                          child: Container(
                            width: mainWidth*3/4,
                            // height: mainWidth/4,
                            padding: EdgeInsets.all(10),
                            child: Text(replies[index]['reply'],style: TextStyle(fontSize: 15),),
                          ),
                        elevation: 3,
                        color: replies[index]['user_id']==user_id.$?Colors.white:Colors.grey,
                      ),
                      Visibility(
                        visible: !(replies[index]['user_id']==user_id.$),
                        child: SizedBox(width: 10,),
                      ),
                    ],
                  );
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 36,
              child: TextField(
                // controller: 'sublect',
                controller: _controller,
                // onChanged: (value){
                //   newReplay = value;
                // },
                autofocus: false,
                decoration:
                InputDecorations.buildInputDecoration_1(
                    hint_text: app_language.$ == 'ar' ?"اكتب رد":"Write a reply"),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.all(5),
                child:  RaisedButton(
                  // elevation: 5.0,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () async{
                    if(_controller.text=="")return;
                    await TicketsRepository.addReply({
                      "reply":_controller.text,
                      "ticket_id":widget.ticketID,
                      "attachments":"",
                    });
                    // Navigator.of(context).pop();
                    setState(() {
                      _controller.text = "";
                      getData();
                    });
                  },
                  child: Text(
                    app_language.$ == 'ar' ?"ارسال الرد":"Send replay",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(5),
                child:  RaisedButton(
                  // elevation: 5.0,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () async{
                    await TicketsRepository.closeTicket(widget.ticketID);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    app_language.$ == 'ar' ?"تم حل المشكلة":"Problem Solved",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                ),
              ),
            ],
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
      title: Text(subject,
          style: TextStyle(color: Colors.black, fontSize: 20.0)),
    );
  }
}

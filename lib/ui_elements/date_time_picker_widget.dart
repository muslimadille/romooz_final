import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DateTimePickerWidget extends StatelessWidget {
   Function(DateTime value) onConfirm;
   Function(DateTime value) onCancel;
   Function(DateTime value) onChange;
   final _initialDate=DateTime.now();
    var _selectedDate=DateTime.now();

  DateTimePickerWidget({this.onConfirm,this.onCancel,this.onChange,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 10
            )
          ]
      ),

      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.3,
      child: Column(children: [
      Container(
        height: 50,
        child: Row(
        children: [
          _btn(context,AppLocalizations.of(context).localeName=="ar"?"تأكيد":"Confirm",Colors.green,true),
          _btn(context,AppLocalizations.of(context).localeName=="ar"?"إلغاء":"cancel",MyTheme.accent_color,false),
        ],
      ),),
      Expanded(child: CupertinoDatePicker(
        onDateTimeChanged: (value){
          print(value);
          _selectedDate=value;
          onChange(value);
        },
        initialDateTime:_initialDate ,
        minimumDate: _initialDate,
        maximumDate: DateTime.now().add(Duration(days: 12)),
        use24hFormat: false,
      ))
    ],),);
  }
  Widget _btn(BuildContext context,String title,Color color,bool isConfirm){
    return InkWell(
        onTap: (){
          if(isConfirm){
            onConfirm(_selectedDate);
          }else{
            onCancel(_selectedDate);
          }
        },
      child: Container(
        height: MediaQuery.of(context).size.height*30,
        width: 80,
        padding: EdgeInsets.all(10),
        margin:EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(title,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

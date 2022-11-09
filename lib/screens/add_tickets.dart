import 'dart:io';
import 'package:active_ecommerce_flutter/style_classes.dart';
import 'package:path/path.dart' as p;
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:active_ecommerce_flutter/repositories/tickets_repository.dart';

// ignore: must_be_immutable
class AddTicketPage extends StatefulWidget {

  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {

  String details,subject;
  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _attachments_registry;

  String attachments_registry;


  // @override
  // void initState() {
  //   //on Splash Screen hide statusbar
  //   print("customer_type${widget.customer_type}");
  //   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  //   super.initState();
  // }

  chooseAndUploadImageAttachmentsRegistry(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title:
                    Text(AppLocalizations.of(context).common_photo_permission),
                content: Text(
                    AppLocalizations.of(context).common_app_needs_permission),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_deny),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_settings),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_give_photo_permission, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _attachments_registry =
          await _picker.pickImage(source: ImageSource.gallery);

      if (_attachments_registry == null) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
      String base64Image =
          FileHelper.getBase64FormateFile(_attachments_registry.path);
      String fileName = _attachments_registry.path.split("/").last;

      final extension = p.extension(_attachments_registry.path, 2);

      attachments_registry =
          "data:image/${extension.substring(1)};base64,${base64Image}";

      setState(() {});

      print("base64Image fileName ${attachments_registry}");

      // var profileImageUpdateResponse =
      //     await ProfileRepository().getProfileImageUpdateResponse(
      //   base64Image,
      //   fileName,
      // );

      // if (profileImageUpdateResponse.result == false) {
      //   ToastComponent.showDialog(profileImageUpdateResponse.message, context,
      //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      //   return;
      // } else {
      //   ToastComponent.showDialog(profileImageUpdateResponse.message, context,
      //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      //   avatar_original.$ = profileImageUpdateResponse.path;
      //   setState(() {});
      // }
    }
  }

  // @override
  // void dispose() {
  //   //before going to other screen show statusbar
  //   SystemChrome.setEnabledSystemUIOverlays(
  //       [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  //   super.dispose();
  // }

  Future<Map<String,dynamic>> onPressCreate() async {

    if (subject == "") {
      ToastComponent.showDialog(
          app_language.$ == 'ar' ?"من فضلك اكتب عنوان التذكرة":"Please Write Ticket subject",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return {};
    }else if (details == "") {
      ToastComponent.showDialog(
          app_language.$ == 'ar' ?"من فضلك اكتب تفاصيل التذكرة":"Please Write Ticket Details",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return {};
    }  else if (attachments_registry == null) {
      ToastComponent.showDialog(
          app_language.$ == 'ar' ?"من فضلك اضف  صورة للمشكلة":"Please add image for the problem",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return {};
    }


    var _data = {
      "subject": subject,
      "details": details,
      "attachments": attachments_registry,
    };


    return await TicketsRepository.addTicket(_data);


  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              child: Image.asset(
                "assets/splash_fr.png",
                fit: BoxFit.fitHeight,
                color: MyTheme.light_grey,
              ),
            ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      IconButton(
                          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                          onPressed: () {
                            return Navigator.of(context).pop();
                          }),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: Image.asset('assets/black-logo.png'),
                    ),
                  ),

                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            app_language.$ == 'ar' ?"عنوان التذكرة":"Ticket subject",
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 36,
                            child: TextField(
                              // controller: 'sublect',
                              onChanged: (value){
                                subject = value;
                              },
                              autofocus: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: app_language.$ == 'ar' ?"اكتب عنوان التذكرة":"Write Ticket Subject"),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            app_language.$ == 'ar' ?"تفاصيل التذكرة":"Ticket Details",
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 70,
                            child: TextField(
                              // controller: 'sublect',
                              onChanged: (value){
                                details = value;
                              },
                              autofocus: false,
                              maxLines: 50, //or null
                              // decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                              decoration:
                              InputDecorations.buildInputDecoration_1(
                                  hint_text: app_language.$ == 'ar' ?"اكتب تفاصل التذكرة":"Write Ticket Details"),
                            ),
                          ),
                        ),




                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          /*child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .registration_commercial_registration_no,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                icon: Icon(Icons.file_upload,
                                    color: MyTheme.dark_grey),
                                onPressed: () {
                                  chooseAndUploadImageAttachmentsRegistry(
                                      context);
                                },
                              ),
                              _attachments_registry != null
                                  ? Container(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  child: Image.file(File(
                                      _attachments_registry.path)),
                                ),
                              )
                                  : Container(),
                            ],
                          ),*/
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 45,
                          child: PrimaryButton(
                            color: MyTheme.accent_color,
                            reduis: 0.4,
                            title: app_language.$ == 'ar' ?"اضافة تذكرة":"Add Ticket",
                            onTap: () async{
                              Map<String,dynamic> response = await onPressCreate();
                              if(response['result']){
                                Navigator.of(context).pop();
                              }else{
                                ToastComponent.showDialog(
                                    response['message'],
                                    context,
                                    gravity: Toast.CENTER,
                                    duration: Toast.LENGTH_LONG);
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

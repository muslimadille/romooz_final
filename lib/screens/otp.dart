import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/style_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/notifications_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.verify_by = "email", this.user_id}) : super(key: key);
  final String verify_by;
  final int user_id;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  bool showLoader = false;


  @override
  Future<void> initState()   {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    var appSignatureID =  SmsAutoFill().getAppSignature.then((value) {
      ToastComponent.showDialog(
          value.toString(),
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    });

    SmsAutoFill().listenForCode().then((value) {
      SmsAutoFill().code.listen((event) {
        setState(() {
          _verificationCodeController.text=event;
        });
      });
    });
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id, widget.verify_by);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).otp_screen_verification_code_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    setState(() {
      showLoader = true;
    });

    var confirmCodeResponse =
    await AuthRepository().getConfirmCodeResponse(widget.user_id, code);

    if (confirmCodeResponse.result == false) {
      setState(() {
        showLoader = false;
      });
      ToastComponent.showDialog(confirmCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {

      // print('222222222222222222222222222222222222222222');
      ToastComponent.showDialog(confirmCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      AuthHelper().setUserData(confirmCodeResponse);
      print("loginResponse ------ ${confirmCodeResponse}");

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
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
                        padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                        child: Container(
                          width: 75,
                          height: 75,
                          child: Image.asset('assets/black-logo.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "${AppLocalizations.of(context).otp_screen_verify_your} " +
                              (_verify_by == "email"
                                  ? AppLocalizations.of(context)
                                  .otp_screen_email_account
                                  : AppLocalizations.of(context)
                                  .otp_screen_phone_number),
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                            width: _screen_width * (3 / 4),
                            child: _verify_by == "email"
                                ? Text(
                                AppLocalizations.of(context)
                                    .otp_screen_enter_verification_code_to_email,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))
                                : Text(
                                AppLocalizations.of(context)
                                    .otp_screen_enter_verification_code_to_phone,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))),
                      ),
                      Container(
                        width: _screen_width * (3 / 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 36,
                                    child: TextField(
                                      controller: _verificationCodeController,
                                      autofocus: false,
                                      decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "A X B 4 J H"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: !showLoader,
                              child: Container(
                                height: 45,
                                child: PrimaryButton(
                                  color: MyTheme.accent_color,
                                  reduis: 0.4,
                                  title: AppLocalizations.of(context)
                                      .otp_screen_confirm,
                                  onTap: () {
                                    onPressConfirm();
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showLoader,
                              child: LoaderButton(
                                color: MyTheme.accent_color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: InkWell(
                          onTap: () {
                            onTapResend();
                          },
                          child: Text(
                              AppLocalizations.of(context).otp_screen_resend_code,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  decoration: TextDecoration.underline,
                                  fontSize: 13)),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:active_ecommerce_flutter/data_model/zones_response.dart';
import 'package:active_ecommerce_flutter/style_classes.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as p;
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
  Registration({@required this.customer_type});

  String customer_type;

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "phone"; //phone or email
  String initialCountry = 'SA';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'SA', dialCode: "+966");
  String _phone = "";

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _commercialNameController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();

  TextEditingController _commercialRegistrationNoController =
  TextEditingController();

  TextEditingController _taxNumberController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  bool showLoader = false;

  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _commercial_registry;

  String commercial_registry;

  XFile _tax_number_certificate;

  String tax_number_certificate;

  //////// addresss
  ///
  ///
  ///int _default_shipping_address = 0;
  City _selected_city = null;
  Country _selected_country;
  // Zone _selected_zone;

  MyState _selected_state;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];
  StateSetter setModalState;

  //controllers for add purpose
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  // TextEditingController _zoneController = TextEditingController();

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];

  // List<TextEditingController> _zoneControllerListForUpdate = [];

  List<City> _selected_city_list_for_update = [];
  List<MyState> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  @override
  void initState() {
    //on Splash Screen hide statusbar
    print("customer_type${widget.customer_type}");
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  chooseAndUploadImageCommercialRegistry(context) async {
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
      _commercial_registry =
      await _picker.pickImage(source: ImageSource.gallery);

      if (_commercial_registry == null) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
      String base64Image =
      FileHelper.getBase64FormateFile(_commercial_registry.path);
      String fileName = _commercial_registry.path.split("/").last;

      final extension = p.extension(_commercial_registry.path, 2);

      commercial_registry =
      "data:image/${extension.substring(1)};base64,${base64Image}";

      setState(() {});

      print("base64Image fileName ${commercial_registry}");

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

  chooseAndUploadImageTaxNumberCertificate(context) async {
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
      _tax_number_certificate =
      await _picker.pickImage(source: ImageSource.gallery);

      if (_tax_number_certificate == null) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
      String base64Image =
      FileHelper.getBase64FormateFile(_tax_number_certificate.path);
      String fileName = _tax_number_certificate.path.split("/").last;

      final extension = p.extension(_tax_number_certificate.path, 2);

      tax_number_certificate = base64Image;

      tax_number_certificate =
      "data:image/${extension.substring(1)};base64,${base64Image}";

      setState(() {});

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

  onSelectCountryDuringAdd(country) {
    if (_selected_country != null && country.id == _selected_country.id) {
      //setModalState(() {
      _countryController.text = country.name;
      //});
      return;
    }
    _selected_country = country;
    _selected_state = null;
    _selected_city = null;

    setState(() {
      _countryController.text = country.name;
      _stateController.text = "";
      _cityController.text = "";
    });
  }

  // onSelectZoneDuringAdd(zone) {
  //   if (_selected_zone != null && zone.id == _selected_zone.id) {
  //     //setModalState(() {
  //     _countryController.text = zone.name;
  //     //});
  //     return;
  //   }
  //   _selected_zone = zone;
  //
  //   setState(() {
  //     _zoneController.text = zone.name;
  //   });
  // }

  onSelectStateDuringAdd(state,) {
    if (_selected_state != null && state.id == _selected_state.id) {
      // setModalState(() {
      _stateController.text = state.name;
      // });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {
      _stateController.text = state.name;
      _cityController.text = "";
    });
    //setModalState(() {

    // });
  }

  onSelectCityDuringAdd(city) {
    if (_selected_city != null && city.id == _selected_city.id) {
      setState(() {
        _cityController.text = city.name;
      });
      // setModalState(() {

      // });
      return;
    }
    _selected_city = city;
    setState(() {
      _cityController.text = city.name;
    });
  }

  onSelectCountryDuringUpdate(index, country) {
    if (_selected_country_list_for_update[index] != null &&
        country.id == _selected_country_list_for_update[index].id) {
      setState(() {
        _countryControllerListForUpdate[index].text = country.name;
      });
      return;
    }
    _selected_country_list_for_update[index] = country;
    _selected_state_list_for_update[index] = null;
    _selected_city_list_for_update[index] = null;
    setState(() {
      _countryControllerListForUpdate[index].text = country.name;
      _stateControllerListForUpdate[index].text = "";
      _cityControllerListForUpdate[index].text = "";
    });

    // setModalState(() {

    // });
  }

  onSelectStateDuringUpdate(index, state) {
    if (_selected_state_list_for_update[index] != null &&
        state.id == _selected_state_list_for_update[index].id) {
      setState(() {
        _stateControllerListForUpdate[index].text = state.name;
      });
      return;
    }
    _selected_state_list_for_update[index] = state;
    _selected_city_list_for_update[index] = null;
    setState(() {
      _stateControllerListForUpdate[index].text = state.name;
      _cityControllerListForUpdate[index].text = "";
    });
    //setModalState(() {

    //});
  }

  onSelectCityDuringUpdate(index, city) {
    if (_selected_city_list_for_update[index] != null &&
        city.id == _selected_city_list_for_update[index].id) {
      setState(() {
        _cityControllerListForUpdate[index].text = city.name;
      });
      return;
    }
    _selected_city_list_for_update[index] = city;
    setState(() {
      _cityControllerListForUpdate[index].text = city.name;
    });
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSignUp() async {
    var name = _nameController.text.toString();
    var commercial_name = _commercialNameController.text.toString();
    print("commercial_name ---- $commercial_name");
    var owner_name = _ownerNameController.text.toString();
    var commercial_registration_no =
    _commercialRegistrationNoController.text.toString();

    var tax_number = _taxNumberController.text.toString();

    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    var state_id = _passwordConfirmController.text.toString();

    if (name == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_name_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'email' && email == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_email_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_phone_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    // else if (password == "") {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context).registration_screen_password_warning,
    //       context,
    //       gravity: Toast.CENTER,
    //       duration: Toast.LENGTH_LONG);
    //   return;
    // }
    // else if (password_confirm == "") {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context)
    //           .registration_screen_password_confirm_warning,
    //       context,
    //       gravity: Toast.CENTER,
    //       duration: Toast.LENGTH_LONG);
    //   return;
    // } else if (password.length < 6) {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context)
    //           .registration_screen_password_length_warning,
    //       context,
    //       gravity: Toast.CENTER,
    //       duration: Toast.LENGTH_LONG);
    //   return;
    // } else if (password != password_confirm) {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context)
    //           .registration_screen_password_match_warning,
    //       context,
    //       gravity: Toast.CENTER,
    //       duration: Toast.LENGTH_LONG);
    //   return;
    // }

    else if (widget.customer_type == "wholesale" && owner_name == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_Owner_name_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" && commercial_name == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_commercial_name_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" &&
        commercial_registration_no == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_commercial_registration_no_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" && tax_number == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_tax_number_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" &&
        commercial_registration_no == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_commercial_registration_no_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" && tax_number == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_tax_number_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" &&
        commercial_registry == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_commercial_registration_no_warning_image,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" &&
        tax_number_certificate == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_tax_number_image_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    setState(() {
      showLoader = true;
    });
    /////
    ///



    var _data = {
      "name": name,
      "email_or_phone":  _register_by == 'email' ? email : _phone,
      "user_type": "customer",
      "customer_type": widget.customer_type,
    };

    if(widget.customer_type== "wholesale"){
      _data.addAll({
        // "password": "$password",
        // "password_confirmation": "${passowrd_confirmation}",
        // "register_by": "$register_by",
        "owner_name": owner_name,
        "commercial_name": commercial_name,
        "commercial_registration_no": commercial_registration_no,
        "commercial_registry": commercial_registry,
        "tax_number": tax_number,
        "tax_number_certificate": tax_number_certificate,
        "state_id": _selected_state.id.toString(),
      });
    }





    var signupResponse = await AuthRepository().getSignupResponse(
      _data
      // name,
      // _register_by == 'email' ? email : _phone,
      // widget.customer_type,
      // // password,
      // // password_confirm,
      // // _register_by,
      // owner_name,
      // commercial_name,
      // commercial_registration_no,
      // commercial_registry,
      // tax_number,
      // tax_number_certificate,
      // _selected_state.id.toString(),
      // // _selected_zone == null ? "0" : _selected_zone.id.toString(),
    );

    if (signupResponse.result == false) {
      setState(() {
        showLoader = false;
      });
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(
          verify_by: _register_by,
          user_id: signupResponse.user_id,
        );
      }));
    }
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
                          "${AppLocalizations.of(context).registration_screen_join} " +
                              AppConfig.app_name,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
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
                                AppLocalizations.of(context)
                                    .registration_screen_name,
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
                                  controller: _nameController,
                                  autofocus: false,
                                  decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: "John Doe"),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                _register_by == "email"
                                    ? AppLocalizations.of(context)
                                    .registration_screen_email
                                    : AppLocalizations.of(context)
                                    .registration_screen_phone,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (_register_by == "email")
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 36,
                                      child: TextField(
                                        controller: _emailController,
                                        autofocus: false,
                                        decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text: "johndoe@example.com"),
                                      ),
                                    ),
                                    // otp_addon_installed.$
                                    //     ? GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             _register_by = "phone";
                                    //           });
                                    //         },
                                    //         child: Text(
                                    //           AppLocalizations.of(context)
                                    //               .registration_screen_or_register_with_phone,
                                    //           style: TextStyle(
                                    //               color: MyTheme.accent_color,
                                    //               fontStyle: FontStyle.italic,
                                    //               decoration:
                                    //                   TextDecoration.underline),
                                    //         ),
                                    //       )
                                    //     : Container()
                                  ],
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 36,
                                      child: CustomInternationalPhoneNumberInput(
                                        onInputChanged: (PhoneNumber number) {
                                          print(number.phoneNumber);
                                          setState(() {
                                            _phone = number.phoneNumber;
                                          });
                                        },
                                        onInputValidated: (bool value) {
                                          print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                          selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.disabled,
                                        selectorTextStyle:
                                        TextStyle(color: MyTheme.font_grey),
                                        initialValue: phoneCode,
                                        textFieldController: _phoneNumberController,
                                        formatInput: true,
                                        keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                        inputDecoration: InputDecorations
                                            .buildInputDecoration_phone(
                                            hint_text: "01710 333 558"),
                                        onSaved: (PhoneNumber number) {
                                          //print('On Saved: $number');
                                        },
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       _register_by = "email";
                                    //     });
                                    //   },
                                    //   child: Text(
                                    //     AppLocalizations.of(context)
                                    //         .registration_screen_or_register_with_email,
                                    //     style: TextStyle(
                                    //         color: MyTheme.accent_color,
                                    //         fontStyle: FontStyle.italic,
                                    //         decoration: TextDecoration.underline),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     AppLocalizations.of(context)
                            //         .registration_screen_password,
                            //     style: TextStyle(
                            //         color: MyTheme.accent_color,
                            //         fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     children: [
                            //       Container(
                            //         height: 36,
                            //         child: TextField(
                            //           controller: _passwordController,
                            //           autofocus: false,
                            //           obscureText: true,
                            //           enableSuggestions: false,
                            //           autocorrect: false,
                            //           decoration:
                            //               InputDecorations.buildInputDecoration_1(
                            //                   hint_text: "• • • • • • • •"),
                            //         ),
                            //       ),
                            //       Text(
                            //         AppLocalizations.of(context)
                            //             .registration_screen_password_length_recommendation,
                            //         style: TextStyle(
                            //             color: MyTheme.textfield_grey,
                            //             fontStyle: FontStyle.italic),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     AppLocalizations.of(context)
                            //         .registration_screen_retype_password,
                            //     style: TextStyle(
                            //         color: MyTheme.accent_color,
                            //         fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Container(
                            //     height: 36,
                            //     child: TextField(
                            //       controller: _passwordConfirmController,
                            //       autofocus: false,
                            //       obscureText: true,
                            //       enableSuggestions: false,
                            //       autocorrect: false,
                            //       decoration:
                            //           InputDecorations.buildInputDecoration_1(
                            //               hint_text: "• • • • • • • •"),
                            //     ),
                            //   ),
                            // ),

                            ///// Comercial name
                            Visibility(
                              visible: widget.customer_type == "wholesale",
                              // ? true
                              // : false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .registration_commercial_name,
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
                                        controller: _commercialNameController,
                                        autofocus: false,
                                        decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text: "Romooz"),
                                      ),
                                    ),
                                  ),

                                  ///// Owner name
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .registration_owner_name,
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
                                        controller: _ownerNameController,
                                        autofocus: false,
                                        decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text:
                                            "XXXXXXXXXXXXXXXXXXXXXXXX"),
                                      ),
                                    ),
                                  ),

                                  ///// Commercial Registration No
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
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
                                            chooseAndUploadImageCommercialRegistry(
                                                context);
                                          },
                                        ),
                                        _commercial_registry != null
                                            ? Container(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Image.file(File(
                                                _commercial_registry.path)),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      height: 36,
                                      child: TextField(
                                        controller:
                                        _commercialRegistrationNoController,
                                        autofocus: false,
                                        decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text:
                                            "XXXXXXXXXXXXXXXXXXXXXXXX"),
                                      ),
                                    ),
                                  ),

                                  ///// TAX Number
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .registration_tax_number,
                                          style: TextStyle(
                                              color: MyTheme.accent_color,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.file_upload,
                                              color: MyTheme.dark_grey),
                                          onPressed: () {
                                            chooseAndUploadImageTaxNumberCertificate(
                                                context);
                                          },
                                        ),
                                        _tax_number_certificate != null
                                            ? Container(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Image.file(File(
                                                _tax_number_certificate
                                                    .path)),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      height: 36,
                                      child: TextField(
                                        controller: _taxNumberController,
                                        autofocus: false,
                                        decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text:
                                            "XXXXXXXXXXXXXXXXXXXXXXXX"),
                                      ),
                                    ),
                                  ),
                                  ////// country
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8.0),
                                  //   child: Text(
                                  //     "${AppLocalizations.of(context).address_screen_country} *",
                                  //     style: TextStyle(
                                  //         color: MyTheme.accent_color,
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 16.0),
                                  //   child: Container(
                                  //     height: 40,
                                  //     child: TypeAheadField(
                                  //       suggestionsCallback: (name) async {
                                  //         var countryResponse =
                                  //         await AddressRepository()
                                  //             .getCountryList(name: name);
                                  //         return countryResponse.countries;
                                  //       },
                                  //       loadingBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //                 AppLocalizations.of(context)
                                  //                     .address_screen_loading_countries,
                                  //                 style: TextStyle(
                                  //                     color: MyTheme.accent_color,
                                  //                     fontSize: 12,
                                  //                     fontWeight: FontWeight.bold),
                                  //               )),
                                  //         );
                                  //       },
                                  //       itemBuilder: (context, country) {
                                  //         print(country.toString());
                                  //         return ListTile(
                                  //           dense: true,
                                  //           title: Text(
                                  //             country.name,
                                  //             style: TextStyle(
                                  //                 color: MyTheme.font_grey),
                                  //           ),
                                  //         );
                                  //       },
                                  //       noItemsFoundBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //                   AppLocalizations.of(context)
                                  //                       .address_screen_no_country_available,
                                  //                   style: TextStyle(
                                  //                       color:
                                  //                       MyTheme.medium_grey))),
                                  //         );
                                  //       },
                                  //       onSuggestionSelected: (country) {
                                  //         onSelectCountryDuringAdd(country);
                                  //       },
                                  //       textFieldConfiguration:
                                  //       TextFieldConfiguration(
                                  //         onTap: () {},
                                  //         //autofocus: true,
                                  //         controller: _countryController,
                                  //         onSubmitted: (txt) {
                                  //           // keep this blank
                                  //         },
                                  //         decoration: InputDecoration(
                                  //             hintText: AppLocalizations.of(context)
                                  //                 .address_screen_enter_country,
                                  //             hintStyle: TextStyle(
                                  //                 fontSize: 12.0,
                                  //                 color: MyTheme.textfield_grey),
                                  //             enabledBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 0.5),
                                  //               borderRadius:
                                  //               const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             focusedBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 1.0),
                                  //               borderRadius:
                                  //               const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             contentPadding: EdgeInsets.symmetric(
                                  //                 horizontal: 8.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  /////// city
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).address_screen_city} *",
                                      // "${AppLocalizations.of(context).address_screen_state} *",
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Container(
                                      height: 40,
                                      child: TypeAheadField(
                                        suggestionsCallback: (name) async {
                                          if (_selected_country == null) {
                                            var stateResponse =
                                            await AddressRepository()
                                                .getStateListByCountry(); // blank response
                                            return stateResponse.states;
                                          }
                                          print('------------------------------');
                                          print(name);
                                          var stateResponse =
                                          await AddressRepository()
                                              .getStateListByCountry(
                                              country_id:
                                              _selected_country.id,
                                              name: name);
                                          return stateResponse.states;
                                        },
                                        loadingBuilder: (context) {
                                          return Container(
                                            height: 50,
                                            child: Center(
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .address_screen_loading_states,
                                                    style: TextStyle(
                                                        color:
                                                        MyTheme.medium_grey))),
                                          );
                                        },
                                        itemBuilder: (context, state) {
                                          //print(suggestion.toString());
                                          return ListTile(
                                            dense: true,
                                            title: Text(
                                              state.name,
                                              style: TextStyle(
                                                  color: MyTheme.font_grey),
                                            ),
                                          );
                                        },
                                        noItemsFoundBuilder: (context) {
                                          return Container(
                                            height: 50,
                                            child: Center(
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .address_screen_no_state_available,
                                                    style: TextStyle(
                                                        color:
                                                        MyTheme.medium_grey))),
                                          );
                                        },
                                        onSuggestionSelected: (state) {
                                          onSelectStateDuringAdd(
                                            state,
                                          );
                                        },
                                        textFieldConfiguration:
                                        TextFieldConfiguration(
                                          onTap: () {},
                                          //autofocus: true,
                                          controller: _stateController,
                                          onSubmitted: (txt) {
                                            // _searchKey = txt;
                                            // setState(() {});
                                            // _onSearchSubmit();
                                          },
                                          decoration: InputDecoration(
                                              hintText: AppLocalizations.of(context)
                                                  .address_screen_enter_state,
                                              hintStyle: TextStyle(
                                                  fontSize: 12.0,
                                                  color: MyTheme.textfield_grey),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: MyTheme.textfield_grey,
                                                    width: 0.5),
                                                borderRadius:
                                                const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: MyTheme.textfield_grey,
                                                    width: 1.0),
                                                borderRadius:
                                                const BorderRadius.all(
                                                  const Radius.circular(8.0),
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 8.0)),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8.0),
                                  //   child: Text(
                                  //     "${AppLocalizations.of(context).address_screen_city} *",
                                  //     style: TextStyle(
                                  //         color: MyTheme.accent_color,
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 16.0),
                                  //   child: Container(
                                  //     height: 40,
                                  //     child: TypeAheadField(
                                  //       suggestionsCallback: (name) async {
                                  //         if (_selected_state == null) {
                                  //           var cityResponse = await AddressRepository()
                                  //               .getCityListByState(); // blank response
                                  //           return cityResponse.cities;
                                  //         }
                                  //         var cityResponse =
                                  //             await AddressRepository()
                                  //                 .getCityListByState(
                                  //                     state_id: _selected_state.id,
                                  //                     name: name);
                                  //         return cityResponse.cities;
                                  //       },
                                  //       loadingBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //                   AppLocalizations.of(context)
                                  //                       .address_screen_loading_cities,
                                  //                   style: TextStyle(
                                  //                       color:
                                  //                           MyTheme.medium_grey))),
                                  //         );
                                  //       },
                                  //       itemBuilder: (context, city) {
                                  //         //print(suggestion.toString());
                                  //         return ListTile(
                                  //           dense: true,
                                  //           title: Text(
                                  //             city.name,
                                  //             style: TextStyle(
                                  //                 color: MyTheme.font_grey),
                                  //           ),
                                  //         );
                                  //       },
                                  //       noItemsFoundBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //                   AppLocalizations.of(context)
                                  //                       .address_screen_no_city_available,
                                  //                   style: TextStyle(
                                  //                       color:
                                  //                           MyTheme.medium_grey))),
                                  //         );
                                  //       },
                                  //       onSuggestionSelected: (city) {
                                  //         onSelectCityDuringAdd(city);
                                  //         print("city....${city.id}");
                                  //       },
                                  //       textFieldConfiguration:
                                  //           TextFieldConfiguration(
                                  //         onTap: () {},
                                  //
                                  //         //autofocus: true,
                                  //         controller: _cityController,
                                  //         onSubmitted: (txt) {
                                  //           // keep blank
                                  //         },
                                  //         decoration: InputDecoration(
                                  //             hintText: AppLocalizations.of(context)
                                  //                 .address_screen_enter_city,
                                  //             hintStyle: TextStyle(
                                  //                 fontSize: 12.0,
                                  //                 color: MyTheme.textfield_grey),
                                  //             enabledBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 0.5),
                                  //               borderRadius:
                                  //                   const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             focusedBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 1.0),
                                  //               borderRadius:
                                  //                   const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             contentPadding: EdgeInsets.symmetric(
                                  //                 horizontal: 8.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),


                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 8.0),
                                  //   child: Text(
                                  //     "${AppLocalizations.of(context).address_screen_zone} *",
                                  //     style: TextStyle(
                                  //         color: MyTheme.accent_color,
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 16.0),
                                  //   child: Container(
                                  //     height: 40,
                                  //     child: TypeAheadField(
                                  //       suggestionsCallback: (name) async {
                                  //         var countryResponse =
                                  //             await AddressRepository()
                                  //                 .getZoneList();
                                  //         return countryResponse.data;
                                  //       },
                                  //       loadingBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //             AppLocalizations.of(context)
                                  //                 .address_screen_loading_zones,
                                  //             style: TextStyle(
                                  //                 color: MyTheme.accent_color,
                                  //                 fontSize: 12,
                                  //                 fontWeight: FontWeight.bold),
                                  //           )),
                                  //         );
                                  //       },
                                  //       itemBuilder: (context, country) {
                                  //         print(country.toString());
                                  //         return ListTile(
                                  //           dense: true,
                                  //           title: Text(
                                  //             country.name,
                                  //             style: TextStyle(
                                  //                 color: MyTheme.font_grey),
                                  //           ),
                                  //         );
                                  //       },
                                  //       noItemsFoundBuilder: (context) {
                                  //         return Container(
                                  //           height: 50,
                                  //           child: Center(
                                  //               child: Text(
                                  //                   AppLocalizations.of(context)
                                  //                       .address_screen_no_zone_available,
                                  //                   style: TextStyle(
                                  //                       color:
                                  //                           MyTheme.medium_grey))),
                                  //         );
                                  //       },
                                  //       onSuggestionSelected: (zone) {
                                  //         onSelectZoneDuringAdd(zone);
                                  //       },
                                  //       textFieldConfiguration:
                                  //           TextFieldConfiguration(
                                  //         onTap: () {},
                                  //         //autofocus: true,
                                  //         controller: _zoneController,
                                  //         onSubmitted: (txt) {
                                  //           // keep this blank
                                  //         },
                                  //         decoration: InputDecoration(
                                  //             hintText: AppLocalizations.of(context)
                                  //                 .address_screen_enter_zone,
                                  //             hintStyle: TextStyle(
                                  //                 fontSize: 12.0,
                                  //                 color: MyTheme.textfield_grey),
                                  //             enabledBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 0.5),
                                  //               borderRadius:
                                  //                   const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             focusedBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //                   color: MyTheme.textfield_grey,
                                  //                   width: 1.0),
                                  //               borderRadius:
                                  //                   const BorderRadius.all(
                                  //                 const Radius.circular(8.0),
                                  //               ),
                                  //             ),
                                  //             contentPadding: EdgeInsets.symmetric(
                                  //                 horizontal: 8.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .address_screen_postal_code,
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: Container(
                                      height: 40,
                                      child: TextField(
                                        controller: _postalCodeController,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)
                                                .address_screen_enter_postal_code,
                                            hintStyle: TextStyle(
                                                fontSize: 12.0,
                                                color: MyTheme.textfield_grey),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: MyTheme.textfield_grey,
                                                  width: 0.5),
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: MyTheme.textfield_grey,
                                                  width: 1.0),
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(8.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 8.0)),
                                      ),
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
                                      .login_screen_sign_up,
                                  onTap: () {
                                    onPressSignUp();
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

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .registration_screen_already_have_account,
                                    style: TextStyle(
                                        color: MyTheme.medium_grey, fontSize: 12),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyTheme.textfield_grey, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: FlatButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  //height: 50,
                                  color: MyTheme.purpel,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .registration_screen_log_in,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return Login();
                                        }));
                                  },
                                ),
                              ),
                            )
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

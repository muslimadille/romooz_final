import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
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
  //////// addresss
  ///
  ///
  ///int _default_shipping_address = 0;
  City _selected_city;
  Country _selected_country;
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

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];
  List<City> _selected_city_list_for_update = [];
  List<MyState> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
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
    setState(() {});

    // setModalState(() {
    //   _countryController.text = country.name;
    //   _stateController.text = "";
    //   _cityController.text = "";
    // });
  }

  onSelectStateDuringAdd(
    state,
  ) {
    if (_selected_state != null && state.id == _selected_state.id) {
      // setModalState(() {
      _stateController.text = state.name;
      // });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {});
    //setModalState(() {
    _stateController.text = state.name;
    _cityController.text = "";
    // });
  }

  onSelectCityDuringAdd(city) {
    if (_selected_city != null && city.id == _selected_city.id) {
      // setModalState(() {
      _cityController.text = city.name;
      // });
      return;
    }
    _selected_city = city;
    //setModalState(() {
    _cityController.text = city.name;
    // });
  }

  onSelectCountryDuringUpdate(index, country) {
    if (_selected_country_list_for_update[index] != null &&
        country.id == _selected_country_list_for_update[index].id) {
      // setModalState(() {
      _countryControllerListForUpdate[index].text = country.name;
      //});
      return;
    }
    _selected_country_list_for_update[index] = country;
    _selected_state_list_for_update[index] = null;
    _selected_city_list_for_update[index] = null;
    setState(() {});

    // setModalState(() {
    _countryControllerListForUpdate[index].text = country.name;
    _stateControllerListForUpdate[index].text = "";
    _cityControllerListForUpdate[index].text = "";
    // });
  }

  onSelectStateDuringUpdate(index, state) {
    if (_selected_state_list_for_update[index] != null &&
        state.id == _selected_state_list_for_update[index].id) {
      //  setModalState(() {
      _stateControllerListForUpdate[index].text = state.name;
      // });
      return;
    }
    _selected_state_list_for_update[index] = state;
    _selected_city_list_for_update[index] = null;
    setState(() {});
    //setModalState(() {
    _stateControllerListForUpdate[index].text = state.name;
    _cityControllerListForUpdate[index].text = "";
    //});
  }

  onSelectCityDuringUpdate(index, city) {
    if (_selected_city_list_for_update[index] != null &&
        city.id == _selected_city_list_for_update[index].id) {
      //setModalState(() {
      _cityControllerListForUpdate[index].text = city.name;
      // });
      return;
    }
    _selected_city_list_for_update[index] = city;
    //setModalState(() {
    _cityControllerListForUpdate[index].text = city.name;
    // });
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
    } else if (password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_password_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_confirm_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_length_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_match_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" && commercial_name == null) {
      ToastComponent.showDialog(widget.customer_type, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (widget.customer_type == "wholesale" && owner_name == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_Owner_name_warning, context,
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
    }

    var signupResponse = await AuthRepository().getSignupResponse(
        name,
        _register_by == 'email' ? email : _phone,
        password,
        password_confirm,
        _register_by,
        widget.customer_type,
        owner_name,
        commercial_name,
        commercial_registration_no,
        tax_number,
        "1");

    if (signupResponse.result == false) {
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
              width: _screen_width * (3 / 4),
              child: Image.asset(
                  "assets/splash_login_registration_background_image.png"),
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
                      child: Image.asset(
                          'assets/login_registration_form_logo.png'),
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

                        ///// Comercial name
                        Visibility(
                          visible: widget.customer_type == "wholesale"
                              ? true
                              : false,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
                                child: Text(
                                  AppLocalizations.of(context)
                                      .registration_commercial_registration_no,
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
                                child: Text(
                                  AppLocalizations.of(context)
                                      .registration_tax_number,
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
                                    controller: _taxNumberController,
                                    autofocus: false,
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text:
                                                "XXXXXXXXXXXXXXXXXXXXXXXX"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "${AppLocalizations.of(context).address_screen_country} *",
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
                                      var countryResponse =
                                          await AddressRepository()
                                              .getCountryList(name: name);
                                      return countryResponse.countries;
                                    },
                                    loadingBuilder: (context) {
                                      return Container(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          AppLocalizations.of(context)
                                              .address_screen_loading_countries,
                                          style: TextStyle(
                                              color: MyTheme.accent_color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      );
                                    },
                                    itemBuilder: (context, country) {
                                      print(country.toString());
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          country.name,
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
                                                    .address_screen_no_country_available,
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.medium_grey))),
                                      );
                                    },
                                    onSuggestionSelected: (country) {
                                      onSelectCountryDuringAdd(country);
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onTap: () {},
                                      //autofocus: true,
                                      controller: _countryController,
                                      onSubmitted: (txt) {
                                        // keep this blank
                                      },
                                      decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)
                                              .address_screen_enter_country,
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "${AppLocalizations.of(context).address_screen_state} *",
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "${AppLocalizations.of(context).address_screen_city} *",
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
                                      if (_selected_state == null) {
                                        var cityResponse = await AddressRepository()
                                            .getCityListByState(); // blank response
                                        return cityResponse.cities;
                                      }
                                      var cityResponse =
                                          await AddressRepository()
                                              .getCityListByState(
                                                  state_id: _selected_state.id,
                                                  name: name);
                                      return cityResponse.cities;
                                    },
                                    loadingBuilder: (context) {
                                      return Container(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .address_screen_loading_cities,
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.medium_grey))),
                                      );
                                    },
                                    itemBuilder: (context, city) {
                                      //print(suggestion.toString());
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          city.name,
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
                                                    .address_screen_no_city_available,
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.medium_grey))),
                                      );
                                    },
                                    onSuggestionSelected: (city) {
                                      onSelectCityDuringAdd(city);
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onTap: () {},
                                      //autofocus: true,
                                      controller: _cityController,
                                      onSubmitted: (txt) {
                                        // keep blank
                                      },
                                      decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)
                                              .address_screen_enter_city,
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
                                padding: const EdgeInsets.only(bottom: 16.0),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .registration_screen_password,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _passwordController,
                                  autofocus: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "• • • • • • • •"),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .registration_screen_password_length_recommendation,
                                style: TextStyle(
                                    color: MyTheme.textfield_grey,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .registration_screen_retype_password,
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
                              controller: _passwordConfirmController,
                              autofocus: false,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: "• • • • • • • •"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
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
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context)
                                    .registration_screen_register_sign_up,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressSignUp();
                              },
                            ),
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
                              color: MyTheme.golden,
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

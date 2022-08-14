// ignore_for_file: must_be_immutable

import 'package:active_ecommerce_flutter/data_model/zones_response.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/style_classes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/screens/map_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address extends StatefulWidget {
  Address(
      {Key key,
      this.from_shipping_info = false,
      this.from_registeration = false})
      : super(key: key);
  bool from_shipping_info;
  bool from_registeration;
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> with SingleTickerProviderStateMixin {
  /////////////map ////

  dynamic addresses_created = null;

  Future<Position> position;
  double latitude = 0.0;
  double longitude = 0.0;

  PickResult selectedPlace;
  PickResult selectedPlace_update;
  LatLng kInitialPosition =
      LatLng(24.8132637, 46.331984); // London , arbitary value

  GoogleMapController _controller;
  bool showLoader = false;
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
    setState(() {});
  }

  setInitialLocation() {
    kInitialPosition = LatLng(addresses_created.lat, addresses_created.lang);
    setState(() {});
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    return position;
  }

  setDummyInitialLocation() {
    position = getLocation();
    position.then((value) => {
          kInitialPosition = LatLng(value.latitude, value.longitude) //
        });

    print("position===${position}");
    setState(() {});
  }

  onTapPickHere(selectedPlace) async {
    // var addressUpdateLocationResponse = await AddressRepository()
    //     .getAddressUpdateLocationResponse(
    //         addresses_created.id,
    //         selectedPlace.geometry.location.lat,
    //         selectedPlace.geometry.location.lng);

    // if (addressUpdateLocationResponse.result == false) {
    //   ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    // ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
    //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    // Navigator.pop(context);
  }

  /////////////////////// map

  ScrollController _mainScrollController = ScrollController();
  int _default_shipping_address = 0;
  City _selected_city;
  Country _selected_country;
  MyState _selected_state;
  Zone _selected_zone;
  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];

  //controllers for add purpose
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _zoneController = TextEditingController();
  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];

  List<TextEditingController> _zoneControllerListForUpdate = [];

  List<City> _selected_city_list_for_update = [];
  List<MyState> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  List<Zone> _selected_zone_list_for_update = [];

  List<LatLng> _locationControllerListForUpdate = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }

    setDummyInitialLocation();
  }

  fetchAll() {
    fetchShippingAddressList();

    setState(() {});
  }

  fetchShippingAddressList() async {
    print("enter fetchShippingAddressList");
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    setState(() {
      _isInitial = false;
    });
    if (_shippingAddressList.length > 0) {
      addresses_created = _shippingAddressList[0];
      print("addresses_created${addresses_created}");
      //_default_shipping_address = _shippingAddressList[0].id;

      var count = 0;
      _shippingAddressList.forEach((address) {
        //var acity = getCityByPartialName(address.city);
        //var acountry = getCountryByPartialName(address.country);
        if (address.set_default == 1) {
          _default_shipping_address = address.id;
        }
        _addressControllerListForUpdate
            .add(TextEditingController(text: address.address));
        _postalCodeControllerListForUpdate
            .add(TextEditingController(text: address.postal_code));
        _phoneControllerListForUpdate
            .add(TextEditingController(text: address.phone));
        _countryControllerListForUpdate
            .add(TextEditingController(text: address.country_name));
        _stateControllerListForUpdate
            .add(TextEditingController(text: address.state_name));
        _cityControllerListForUpdate
            .add(TextEditingController(text: address.city_name));

        _zoneControllerListForUpdate
            .add(TextEditingController(text: address.zone_name));

        _selected_country_list_for_update
            .add(Country(id: address.country_id, name: address.country_name));
        _selected_state_list_for_update
            .add(MyState(id: address.state_id, name: address.state_name));
        _selected_city_list_for_update
            .add(City(id: address.city_id, name: address.city_name));

        _selected_zone_list_for_update
            .add(Zone(id: address.zone_id, name: address.zone_name));

        _locationControllerListForUpdate.add(LatLng(address.lat, address.lang));
      });

      //print("fetchShippingAddressList${_locationControllerListForUpdate}");
    }

    setState(() {});
  }

  reset() {
    _default_shipping_address = 0;
    _shippingAddressList.clear();
    _isInitial = true;

    _addressController.clear();
    _postalCodeController.clear();
    _phoneController.clear();

    _countryController.clear();
    _stateController.clear();
    _cityController.clear();

    //update-ables
    _addressControllerListForUpdate.clear();
    _postalCodeControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _countryControllerListForUpdate.clear();
    _stateControllerListForUpdate.clear();
    _cityControllerListForUpdate.clear();
    _selected_city_list_for_update.clear();
    _selected_state_list_for_update.clear();
    _selected_country_list_for_update.clear();
    _selected_zone_list_for_update.clear();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  afterAddingAnAddressUpdateLocation(address_id) async {
    print(selectedPlace_update);
    var addressUpdateLocationResponse;
    if (selectedPlace_update == null) {
      addressUpdateLocationResponse = await AddressRepository()
          .getAddressUpdateLocationResponse(address_id, 24.8132637, 46.331984);
    } else {
      addressUpdateLocationResponse = await AddressRepository()
          .getAddressUpdateLocationResponse(
              address_id,
              selectedPlace_update.geometry.location.lat,
              selectedPlace_update.geometry.location.lng);
    }

    if (addressUpdateLocationResponse.result == false) {
      ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    Navigator.of(context, rootNavigator: true).pop();
    afterAddingAnAddress();
    setState(() {
      showLoader = false;
    });

    // Navigator.pop(context);
  }

  afterDeletingAnAddress() {
    reset();
    fetchAll();
  }

  afterUpdatingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse = await AddressRepository()
        .getAddressMakeDefaultResponse(_default_shipping_address);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(addressMakeDefaultResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressMakeDefaultResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    setState(() {
      _default_shipping_address = _shippingAddressList[index].id;
    });
  }

  onPressDelete(id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)
                      .address_screen_address_remove_warning,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).common_cancel_ucfirst,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                FlatButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context).common_confirm_ucfirst,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(id) async {
    var addressDeleteResponse =
        await AddressRepository().getAddressDeleteResponse(id);

    if (addressDeleteResponse.result == false) {
      ToastComponent.showDialog(addressDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressDeleteResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    afterDeletingAnAddress();
  }

  onAddressAdd(context) async {
    print("onAddressAdd${selectedPlace_update}");
    setState(() {
      showLoader = true;
    });

    var address = _addressController.text.toString();
    var postal_code = _postalCodeController.text.toString();
    var phone = _phoneController.text.toString();

    if (address == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_address_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_country == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_country_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_state == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_state_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_city == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_city_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_zone == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_zone_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addressAddResponse = await AddressRepository().getAddressAddResponse(
        address: address,
        country_id: _selected_country.id,
        state_id: _selected_state.id,
        city_id: _selected_city.id,
        zone_id: _selected_zone.id,
        postal_code: postal_code,
        phone: phone);

    if (addressAddResponse.result == false) {
      ToastComponent.showDialog(addressAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressAddResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    afterAddingAnAddressUpdateLocation(addressAddResponse.data.id);
  }

  onAddressUpdate(context, index, id) async {
    var address = _addressControllerListForUpdate[index].text.toString();
    var postal_code = _postalCodeControllerListForUpdate[index].text.toString();
    var phone = _phoneControllerListForUpdate[index].text.toString();

    if (address == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_address_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_country_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_country_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_state_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_state_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_city_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_city_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_zone_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_zone_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateResponse(
            id: id,
            address: address,
            country_id: _selected_country_list_for_update[index].id,
            state_id: _selected_state_list_for_update[index].id,
            zone_id: _selected_zone_list_for_update[index].id,
            city_id: _selected_city_list_for_update[index].id,
            postal_code: postal_code,
            phone: phone);

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    afterAddingAnAddressUpdateLocation(id);
  }

  onSelectZoneDuringAdd(zone) {
    if (_selected_zone != null && zone.id == _selected_zone.id) {
      //setModalState(() {
      _zoneController.text = zone.name;
      //});
      return;
    }
    _selected_zone = zone;

    setState(() {
      _zoneController.text = zone.name;
    });
    print("_selected_zone ${_selected_zone}");
  }

  onSelectCountryDuringAdd(country, setModalState) {
    if (_selected_country != null && country.id == _selected_country.id) {
      setModalState(() {
        _countryController.text = country.name;
      });
      return;
    }
    _selected_country = country;
    _selected_state = null;
    _selected_city = null;
    setState(() {});

    setModalState(() {
      _countryController.text = country.name;
      _stateController.text = "";
      _cityController.text = "";
    });
  }

  onSelectStateDuringAdd(state, setModalState) {
    if (_selected_state != null && state.id == _selected_state.id) {
      setModalState(() {
        _stateController.text = state.name;
      });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {});
    setModalState(() {
      _stateController.text = state.name;
      _cityController.text = "";
    });
  }

  onSelectCityDuringAdd(city, setModalState) {
    if (_selected_city != null && city.id == _selected_city.id) {
      setModalState(() {
        _cityController.text = city.name;
      });
      return;
    }
    _selected_city = city;
    setModalState(() {
      _cityController.text = city.name;
    });
  }

  onSelectCountryDuringUpdate(index, country, setModalState) {
    if (_selected_country_list_for_update[index] != null &&
        country.id == _selected_country_list_for_update[index].id) {
      setModalState(() {
        _countryControllerListForUpdate[index].text = country.name;
      });
      return;
    }
    _selected_country_list_for_update[index] = country;
    _selected_state_list_for_update[index] = null;
    _selected_city_list_for_update[index] = null;
    setState(() {});

    setModalState(() {
      _countryControllerListForUpdate[index].text = country.name;
      _stateControllerListForUpdate[index].text = "";
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectStateDuringUpdate(index, state, setModalState) {
    if (_selected_state_list_for_update[index] != null &&
        state.id == _selected_state_list_for_update[index].id) {
      setModalState(() {
        _stateControllerListForUpdate[index].text = state.name;
      });
      return;
    }
    _selected_state_list_for_update[index] = state;
    _selected_city_list_for_update[index] = null;
    setState(() {});
    setModalState(() {
      _stateControllerListForUpdate[index].text = state.name;
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectCityDuringUpdate(index, city, setModalState) {
    if (_selected_city_list_for_update[index] != null &&
        city.id == _selected_city_list_for_update[index].id) {
      setModalState(() {
        _cityControllerListForUpdate[index].text = city.name;
      });
      return;
    }
    _selected_city_list_for_update[index] = city;
    setModalState(() {
      _cityControllerListForUpdate[index].text = city.name;
    });
  }

  onSelectZoneDuringUpdate(index, zone, setModalState) {
    if (_selected_zone_list_for_update[index] != null &&
        zone.id == _selected_zone_list_for_update[index].id) {
      setModalState(() {
        _zoneControllerListForUpdate[index].text = zone.name;
      });
      return;
    }
    _selected_zone_list_for_update[index] = zone;
    setModalState(() {
      _zoneControllerListForUpdate[index].text = zone.name;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.from_registeration
            ? buildAppBarRegister(context)
            : buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          displacement: 0,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildAddressList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width - 16,
                    height: 60,
                    color: Color.fromRGBO(252, 252, 252, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: MyTheme.light_grey, width: 1.0)),
                    child: Icon(
                      FontAwesome.plus,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                    onPressed: () {
                      buildShowAddFormDialog(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ]))
            ],
          ),
        ));
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_address} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_address,
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
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_country} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, country) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (country) {
                              onSelectCountryDuringAdd(country, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_state} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              if (_selected_country == null) {
                                var stateResponse = await AddressRepository()
                                    .getStateListByCountry(); // blank response
                                return stateResponse.states;
                              }
                              var stateResponse = await AddressRepository()
                                  .getStateListByCountry(
                                      country_id: _selected_country.id,
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, state) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  state.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (state) {
                              onSelectStateDuringAdd(state, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_city} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
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
                              var cityResponse = await AddressRepository()
                                  .getCityListByState(
                                      state_id: _selected_state.id, name: name);
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, city) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  city.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (city) {
                              onSelectCityDuringAdd(city, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${AppLocalizations.of(context).address_screen_zone} *",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
                                  .getZoneList(city_id: _selected_city.id);
                              return countryResponse.data;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .address_screen_loading_zones,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                )),
                              );
                            },
                            itemBuilder: (context, country) {
                              print(country.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .address_screen_no_zone_available,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (zone) {
                              onSelectZoneDuringAdd(zone);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _zoneController,
                              onSubmitted: (txt) {
                                // keep this blank
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .address_screen_enter_zone,
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
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
                                color: MyTheme.font_grey, fontSize: 12)),
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneController,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_phone,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        child: placePickerMethod(context),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context).common_close_ucfirst,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Visibility(
                      visible: !showLoader,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: FlatButton(
                          minWidth: 75,
                          height: 30,
                          color: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context).common_add_ucfirst,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            setState(() {
                              onAddressAdd(context);
                            });
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
                )
              ],
            );
          });
        });
  }

  PlacePicker placePickerMethodUpdate(BuildContext context, int index) {
    return PlacePicker(
      hintText: AppLocalizations.of(context)
          .map_location_screen_your_delivery_location,
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: _locationControllerListForUpdate[index],
      useCurrentLocation: false,
      //selectInitialPosition: true,
      onMapCreated: _onMapCreated,
      //initialMapType: MapType.terrain,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        selectedPlace = result;
        print("onTapPickHere ---${selectedPlace}");
        Navigator.of(context).pop();
        setState(() {});
      },
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',
      //selectInitialPosition: true,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        selectedPlace_update = selectedPlace;

        print("-------------");
        // onTapPickHere(selectedPlace);
        /*
      if(!isSearchBarFocused && state != SearchingState.Searching){
        ToastComponent.showDialog("Hello", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }*/
        return isSearchBarFocused
            ? Container()
            : Visibility(
                visible: false,
                child: FloatingCard(
                  height: 50,
                  bottomPosition: 120.0,
                  // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                  leftPosition: 0.0,
                  rightPosition: 0.0,
                  width: 500,
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  ),
                  child: state == SearchingState.Searching
                      ? Center(
                          child: Text(
                          AppLocalizations.of(context)
                              .map_location_screen_calculating,
                          style: TextStyle(color: MyTheme.font_grey),
                        ))
                      : Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: Text(
                                          selectedPlace.formattedAddress,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: MyTheme.medium_grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    color: MyTheme.accent_color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(4.0),
                                      bottomLeft: const Radius.circular(4.0),
                                      topRight: const Radius.circular(4.0),
                                      bottomRight: const Radius.circular(4.0),
                                    )),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .map_location_screen_pick_here,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                      //            this will override default 'Select here' Button.
                                      /*print("do something with [selectedPlace] data");
                                    print(selectedPlace.formattedAddress);
                                    print(selectedPlace.geometry.location.lat);
                                    print(selectedPlace.geometry.location.lng);*/

                                      onTapPickHere(selectedPlace);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              );
      },
      pinBuilder: (context, state) {
        if (state == PinState.Idle) {
          return Image.asset(
            'assets/delivery_map_icon.png',
            height: 60,
          );
        } else {
          return Image.asset(
            'assets/delivery_map_icon.png',
            height: 80,
          );
        }
      },
    );
  }

  PlacePicker placePickerMethod(BuildContext context) {
    return PlacePicker(
      hintText: AppLocalizations.of(context)
          .map_location_screen_your_delivery_location,
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      //selectInitialPosition: true,
      onMapCreated: _onMapCreated,
      //initialMapType: MapType.terrain,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        selectedPlace = result;
        print("onTapPickHere ---${selectedPlace}");
        Navigator.of(context).pop();
        setState(() {});
      },
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',
      //selectInitialPosition: true,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        selectedPlace_update = selectedPlace;

        print("-------------");
        // onTapPickHere(selectedPlace);
        /*
      if(!isSearchBarFocused && state != SearchingState.Searching){
        ToastComponent.showDialog("Hello", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }*/
        return isSearchBarFocused
            ? Container()
            : Visibility(
                visible: false,
                child: FloatingCard(
                  height: 50,
                  bottomPosition: 120.0,
                  // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                  leftPosition: 0.0,
                  rightPosition: 0.0,
                  width: 500,
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  ),
                  child: state == SearchingState.Searching
                      ? Center(
                          child: Text(
                          AppLocalizations.of(context)
                              .map_location_screen_calculating,
                          style: TextStyle(color: MyTheme.font_grey),
                        ))
                      : Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: Text(
                                          selectedPlace.formattedAddress,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: MyTheme.medium_grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    color: MyTheme.accent_color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(4.0),
                                      bottomLeft: const Radius.circular(4.0),
                                      topRight: const Radius.circular(4.0),
                                      bottomRight: const Radius.circular(4.0),
                                    )),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .map_location_screen_pick_here,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                      //            this will override default 'Select here' Button.
                                      /*print("do something with [selectedPlace] data");
                                    print(selectedPlace.formattedAddress);
                                    print(selectedPlace.geometry.location.lat);
                                    print(selectedPlace.geometry.location.lng);*/

                                      onTapPickHere(selectedPlace);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              );
      },
      pinBuilder: (context, state) {
        if (state == PinState.Idle) {
          return Image.asset(
            'assets/delivery_map_icon.png',
            height: 60,
          );
        } else {
          return Image.asset(
            'assets/delivery_map_icon.png',
            height: 80,
          );
        }
      },
    );
  }

  Future buildShowUpdateFormDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_address} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_address,
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
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_country} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, country) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (country) {
                              onSelectCountryDuringUpdate(
                                  index, country, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller:
                                  _countryControllerListForUpdate[index],
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_state} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              if (_selected_country_list_for_update[index] ==
                                  null) {
                                var stateResponse = await AddressRepository()
                                    .getStateListByCountry(); // blank response
                                return stateResponse.states;
                              }
                              var stateResponse = await AddressRepository()
                                  .getStateListByCountry(
                                      country_id:
                                          _selected_country_list_for_update[
                                                  index]
                                              .id,
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, state) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  state.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (state) {
                              onSelectStateDuringUpdate(
                                  index, state, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _stateControllerListForUpdate[index],
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_city} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              if (_selected_state_list_for_update[index] ==
                                  null) {
                                var cityResponse = await AddressRepository()
                                    .getCityListByState(); // blank response
                                return cityResponse.cities;
                              }
                              var cityResponse = await AddressRepository()
                                  .getCityListByState(
                                      state_id:
                                          _selected_state_list_for_update[index]
                                              .id,
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, city) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  city.name,
                                  style: TextStyle(color: MyTheme.font_grey),
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
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (city) {
                              onSelectCityDuringUpdate(
                                  index, city, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _cityControllerListForUpdate[index],
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${AppLocalizations.of(context).address_screen_zone} *",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
                                  .getZoneList(
                                      city_id:
                                          _selected_city_list_for_update[index]
                                              .id);
                              return countryResponse.data;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .address_screen_loading_zones,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                )),
                              );
                            },
                            itemBuilder: (context, country) {
                              print(country.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .address_screen_no_zone_available,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (zone) {
                              onSelectZoneDuringUpdate(
                                  index, zone, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _zoneControllerListForUpdate[index],
                              onSubmitted: (txt) {
                                // keep this blank
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .address_screen_enter_zone,
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
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
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller:
                                _postalCodeControllerListForUpdate[index],
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_phone,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        child: placePickerMethod(context),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)
                              .common_close_in_all_capital,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)
                              .common_update_in_all_capital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressUpdate(
                              context, index, _shippingAddressList[index].id);
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context).address_screen_addresses_of_user,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
          Text(
            "* ${AppLocalizations.of(context).address_screen_addresses_to_make_default}",
            style: TextStyle(fontSize: 10, color: MyTheme.medium_grey),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  AppBar buildAppBarRegister(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context).address_screen_addresses_of_user,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
          Text(
            "* ${AppLocalizations.of(context).address_screen_addresses_to_make_default}",
            style: TextStyle(fontSize: 10, color: MyTheme.medium_grey),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildAddressList() {
    print("is Initial: ${_isInitial}");
    if (is_logged_in == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildAddressItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_no_address_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index].id) {
          onAddressSwitch(index);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _default_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context).address_screen_address,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 175,
                          child: Text(
                            _shippingAddressList[index].address,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context).address_screen_city,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].city_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context).address_screen_state,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].state_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context).address_screen_country,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].country_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)
                                .address_screen_postal_code,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].postal_code,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].phone,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            app_language_rtl.$
                ? Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: InkWell(
                      onTap: () {
                        buildShowUpdateFormDialog(context, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
                        child: Icon(
                          Icons.edit,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ))
                : Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: InkWell(
                      onTap: () {
                        buildShowUpdateFormDialog(context, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
                        child: Icon(
                          Icons.edit,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    )),
            app_language_rtl.$
                ? Positioned(
                    left: 0,
                    top: 40.0,
                    child: InkWell(
                      onTap: () {
                        onPressDelete(_shippingAddressList[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ))
                : Positioned(
                    right: 0,
                    top: 40.0,
                    child: InkWell(
                      onTap: () {
                        onPressDelete(_shippingAddressList[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
            OtherConfig.USE_GOOGLE_MAP
                ? app_language_rtl.$
                    ? Positioned(
                        left: 0,
                        top: 80.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MapLocation(
                                  address: _shippingAddressList[index]);
                            })).then((value) {
                              onPopped(value);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Icon(
                              Icons.location_on,
                              color: MyTheme.dark_grey,
                              size: 16,
                            ),
                          ),
                        ))
                    : Positioned(
                        right: 0,
                        top: 80.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MapLocation(
                                  address: _shippingAddressList[index]);
                            })).then((value) {
                              onPopped(value);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Icon(
                              Icons.location_on,
                              color: MyTheme.dark_grey,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                : Container(),
          ],
        ),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Visibility(
      visible: widget.from_shipping_info || widget.from_registeration,
      child: BottomAppBar(
        child: Container(
          color: Colors.transparent,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                color: MyTheme.accent_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Text(
                  widget.from_shipping_info
                      ? AppLocalizations.of(context)
                          .address_screen_back_to_shipping_info
                      : AppLocalizations.of(context).go_to_home,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Main();
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

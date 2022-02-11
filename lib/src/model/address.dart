import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../abg_utils.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddressData{
  String id;
  String address;
  double lat;
  double lng;
  bool current;
  int type; // 1 home - 2 office - 3 other
  String name;
  String phone;

  AddressData({this.id = "", this.address = "", this.lat = 0,
    this.lng = 0, this.current = false, this.type = 1, this.name = "", this.phone = ""});

  factory AddressData.fromJson(Map<String, dynamic> data){
    return AddressData(
      id: (data["id"] != null) ? data["id"] : "",
      address: (data["address"] != null) ? data["address"] : "",
      lat: (data["lat"] != null) ? toDouble(data["lat"].toString()) : 0,
      lng: (data["lng"] != null) ? toDouble(data["lng"].toString()) : 0,
      current: (data["current"] != null) ? data["current"] : false,
      type: (data["type"] != null) ? data["type"] : 1,
      name: (data["name"] != null) ? data["name"] : "",
      phone: (data["phone"] != null) ? data["phone"] : "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'address': address,
    'lat': lat,
    'lng': lng,
    'current': current,
    'type' : type,
    'name' : name,
    'phone' : phone,
  };
}


initProviderDistances() async {
  if (providers.isEmpty)
    return;
  if (userAccountData.userAddress.isEmpty)
    return;
  var _address = getCurrentAddress();
  if (_address.id.isNotEmpty) {
    for (var item in providers) {
      double _dist = double.infinity;
      for (var latLng in item.route) {
        double d = Geolocator.distanceBetween(_address.lat, _address.lng, latLng.latitude, latLng.longitude);
        if (d < _dist)
          _dist = d;
      }
      if (_dist == double.infinity)
        _dist = 0;
      item.distanceToUser = _dist;
    }
  }
//  parent.redraw();
}

AddressData getCurrentAddress(){
  for (var item in userAccountData.userAddress) {
    if (item.current)
      return item;
  }
  if (userAccountData.userAddress.isNotEmpty)
    return userAccountData.userAddress[0];
  return AddressData();
}

setCurrentAddress(String id){
  for (var item in userAccountData.userAddress) {
    item.current = false;
    if (item.id == id)
      item.current = true;
  }
  saveAddress();
  initProviderDistances();
}

//

double userCurrentLatitude = 0;
double userCurrentLongitude = 0;

Future<Position> _getCurrent() async {
  var _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation,
      timeLimit: Duration(seconds: 10)).onError((error, stackTrace) {
    return messageError(buildContext, error.toString());
  });
  return _currentPosition;
}

Future<bool> getCurrentLocation() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied)
      return false;
  }
  Position pos = await _getCurrent();
  userCurrentLatitude = pos.latitude;
  userCurrentLongitude = pos.longitude;
  return true;
}

//
// type
// 1 - home
// 2 - office
// 3 - other
//

Future<String?> saveLocation(int _type, String _address, String _name, String _phone,
    String stringEnterAddress, /// strings.get(77); /// "Please enter address",
    String stringEnterName, /// strings.get(87); /// "Please Enter name",
    String stringEnterPhone, /// strings.get(88); /// "Please enter phone",
    ) async {
  if (_address.isEmpty)
    return stringEnterAddress; /// "Please enter address",
  if (_name.isEmpty)
    return stringEnterName; /// "Please Enter name",
  if (_phone.isEmpty)
    return stringEnterPhone; /// "Please enter phone",

  for (var item in userAccountData.userAddress)
    item.current = false;

  userAccountData.userAddress.add(AddressData(
    id: Uuid().v4(),
    address: _address,
    lat: userCurrentLatitude,
    lng: userCurrentLongitude,
    current: true,
    type: _type,
    name: _name,
    phone: _phone,
  ));

  var t = await saveAddress();
  if (t == null){
    userCurrentLatitude = 0;
    userCurrentLongitude = 0;
  }

  initProviderDistances();

  return t;
}

String urlServerBackend = ""; // https://www.abg-studio.com/onDemand1_backend/public/api/";

Future<PlacesSearchResponse?> _placesSearchNearbyWithRadius(double lat, double lng) async {
  try {
    var response = await http.post(Uri.parse("${urlServerBackend}searchNearbyWithRadius"),
        body: convert.jsonEncode({
          "lat": lat.toString(),
          "lng": lng.toString(),
          "key": appSettings.googleMapApiKey
        }),
        headers: {
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      final body = convert.jsonDecode(response.body);
      return PlacesSearchResponse.fromJson(body);
    }
  } catch (ex) {
    messageError(buildContext, ex.toString());
  }
  return null;
}

Future<String> getAddressFromLatLng(LatLng pos) async {
  PlacesSearchResponse response;
  if (urlServerBackend.isNotEmpty){
    var t = await _placesSearchNearbyWithRadius(pos.latitude, pos.longitude);
    if (t == null)
      return "";
    response = t;
  }else {
    if (kIsWeb)
      return "";
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: appSettings.googleMapApiKey);
    response = await places.searchNearbyWithRadius(Location(lat: pos.latitude, lng: pos.longitude), 20);
  }
  if (response.results.isEmpty)
    return "";
  if (!response.isOkay)
    return "${response.errorMessage}";
  var _textAddress = "";
  if (response.results.isNotEmpty) {
    for (var item in response.results)
      if (item.vicinity != null)
        if (item.vicinity!.length > _textAddress.length)
          _textAddress = item.vicinity!;
  }
  return _textAddress;
}

import 'dart:convert';
import 'dart:io';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

getLocalSettings() async {
  dprint("getLocalSettings");
  try{
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var _file = File('$directoryPath/localSettings.json');
    if (await _file.exists()){
      final contents = await _file.readAsString();
      var data = json.decode(contents);
      dprint("getLocalSettings $data");
      localSettings = LocalSettings.fromJson(data);
      //dprint("productsLastTime: ${localSettings.productsLastTime}");

      // login
      if (localSettings.type == "email" && localSettings.email.isNotEmpty && localSettings.password.isNotEmpty)
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: localSettings.email, password: localSettings.password);

    }
  }catch(ex){
    print("exception getTheme $ex");
  }
}

LocalSettings localSettings = LocalSettings.createEmpty();

class LocalSettings{

  String locale = "";
  double mapLat = 0;
  double mapLng = 0;
  double mapZoom = 12;
  String hint;
  bool darkMode = false;
  bool showOnBoard = true;
  //
  String logo = "";
  Color mainColor;
  //
  String langVer = "";
  // for login
  String email = "";
  String password = "";
  String type = "";
  //
  double fontSizePlus = 0;
  double customerCategoryImageSize = 0;

  LocalSettings({
    this.locale = "",
    this.mapLat = 0,
    this.mapLng = 0,
    this.mapZoom = 12,
    this.hint = "",
    this.darkMode = false,
    this.showOnBoard = true,
    this.logo = "",
    this.mainColor = const Color(0xff3c7396),
    this.langVer = "",
    this.email = "",
    this.password = "",
    this.type = "",
    this.fontSizePlus = 0,
    this.customerCategoryImageSize = 80,
  });

  Map<String, dynamic> toJson() => {
    'locale' : locale,
    'mapLat' : mapLat,
    'mapLng' : mapLng,
    'mapZoom' : mapZoom,
    'hint' : hint,
    'darkMode' : darkMode,
    'showOnBoard': showOnBoard,
    //
    'logo': logo,
    'mainColor': mainColor.value.toString(),
    //
    'langVer': langVer,
    //
    'email': email,
    'password': password,
    'type': type,
    //
    'fontSizePlus': fontSizePlus,
    'customerCategoryImageSize': customerCategoryImageSize,
  };

  factory LocalSettings.createEmpty(){
    return LocalSettings();
  }

  factory LocalSettings.fromJson(Map<String, dynamic> data){
    List<String> _address = [];
    if (data['address'] != null)
      for (dynamic key in data['address'])
        _address.add(key.toString());
    return LocalSettings(
      locale : (data["locale"] != null) ? data["locale"]: "",
      mapLat : (data["mapLat"] != null) ? toDouble(data["mapLat"].toString()): 0,
      mapLng : (data["mapLng"] != null) ? toDouble(data["mapLng"].toString()): 0,
      mapZoom : (data["mapZoom"] != null) ? toDouble(data["mapZoom"].toString()): 0,
      hint : (data["hint"] != null) ? data["hint"]: "",
      darkMode: (data["darkMode"] != null) ? data["darkMode"]: false,
      showOnBoard: (data["showOnBoard"] != null) ? data["showOnBoard"]: true,
      //
      logo : (data["logo"] != null) ? data["logo"]: "",
      mainColor: (data["mainColor"] != null) ? toColor(data["mainColor"]) : Color(0xff3c7396),
      //
      langVer : (data["langVer"] != null) ? data["langVer"]: "",
      //
      email : (data["email"] != null) ? data["email"]: "",
      password : (data["password"] != null) ? data["password"]: "",
      type : (data["type"] != null) ? data["type"]: "",
      //
      fontSizePlus : (data["fontSizePlus"] != null) ? toDouble(data["fontSizePlus"].toString()): 0,
      customerCategoryImageSize : (data["customerCategoryImageSize"] != null) ? toDouble(data["customerCategoryImageSize"].toString()): 0,
    );
  }

  setShowOnBoard(bool val){
    showOnBoard = val;
    _save();
  }

  setLocal(String value){
    locale = value;
    dprint("LocalSettings setLocal $value");
    _save();
  }

  setMap(double lat, double lng, double zoom){
    mapLat = lat;
    mapLng = lng;
    mapZoom = zoom;
    dprint("LocalSettings setMap");
    _save();
  }

  setLangVersion(String val){
    langVer = val;
    dprint("LocalSettings setLangVer _cur=$val");
    _save();
  }

  setHint(String val){
    hint = val;
    dprint("LocalSettings setHint val=$val");
    _save();
  }

  setDarkMode(bool val){
    darkMode = val;
    dprint("LocalSettings setDarkMode val=$val");
    _save();
  }

  setLogo(String val){
    logo = val;
    dprint("LocalSettings setLogo val=$val");
    _save();
  }

  setMainColor(Color val){
    mainColor = val;
    dprint("LocalSettings mainColor val=$val");
    _save();
  }

  // type = "email"
  saveLogin(String _email, String _password, String _type){
    email = _email;
    password = _password;
    type = _type;
    _save();
  }

  saveFontSizePlus(double _fontSizePlus){
    fontSizePlus = _fontSizePlus;
    _save();
  }

  saveCustomerCategoryImageSize(double _customerCategoryImageSize){
    customerCategoryImageSize = _customerCategoryImageSize;
    _save();
  }


  _save() async {
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    await File('$directoryPath/localSettings.json').writeAsString(json.encode(toJson()));
  }
}
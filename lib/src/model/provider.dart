import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../abg_utils.dart';

List<ProviderData> providers = [];
ProviderData currentProvider = ProviderData.createEmpty();


LatLng getProviderRouteLatLng(String providerId){ // parent.currentService.providers.isNotEmpty ? parent.currentService.providers[0] : ""
  ProviderData? _provider = getProviderById(providerId);
  if (_provider == null)
    return LatLng(0, 0);
  if (_provider.route.isEmpty)
    return LatLng(0, 0);

  return _provider.route[0];
}

List<LatLng> getProviderRoute(String providerId){ // parent.currentService.providers[0]
  ProviderData? _provider = getProviderById(providerId);
  if (_provider == null)
    return [];
  return _provider.route;
}

Future<String?> providerSaveMinAndMaxAmount(ProviderData provider) async {
  try{
    await dbSetDocumentInTable("provider", provider.id, {
      'useMinPurchaseAmount': provider.useMinPurchaseAmount,
      'minPurchaseAmount': provider.minPurchaseAmount,
      'useMaxPurchaseAmount': provider.useMaxPurchaseAmount,
      'maxPurchaseAmount': provider.maxPurchaseAmount,
    });
  }catch(ex){
    return "providerSaveMinAndMaxAmount " + ex.toString();
  }
  return null;
}


Future<ProviderData?> getProviderData(String login) async {
  try{
    List<ProviderData> _list = await dbGetAllDocumentInTable("provider", field1: "login", isEqualTo1: login);
    if (_list.isNotEmpty)
      return _list[0];
    // var querySnapshot = await FirebaseFirestore.instance.collection("provider").where("login", isEqualTo: login).get();
    // for (var result in querySnapshot.docs) {
    //   var _data = result.data();
    //   if (_data.isNotEmpty){
    //     return ProviderData.fromJson(result.id, _data);
    //   }
    // }
  }catch(ex){
    return null;
  }
  return null;
}

Future<String> getProviderId(String login) async {
  var data = await getProviderData(login);
  if (data != null)
    return data.id;

  return "";
  // }
  // var ret = "";
  // try{
  //   var querySnapshot = await FirebaseFirestore.instance.collection("provider").where("login", isEqualTo: login).get();
  //   for (var result in querySnapshot.docs) {
  //     var data = result.data();
  //     if (data.isEmpty)
  //       return "";
  //     ret = result.id;
  //   }
  // }catch(ex){
  //   return "";
  // }
  // return ret;
}

Future<UserData?> getProviderUserByEmail(String userEmail) async {
  try{
    List<UserData> _list = await dbGetAllDocumentInTable("listusers", field1: "email", isEqualTo1: userEmail);
    if (_list.isNotEmpty)
      return _list[0];
  }catch(ex){
    dprint("getProviderUserByEmail " + ex.toString());
  }
  return null;
}

ProviderData? getProviderById(String _providerId) {
  for (var item in providers)
    if (item.id == _providerId)
      return item;
    return null;
}

String getProviderNameById(String _providerId, String locale) {
  ProviderData? provider = getProviderById(_providerId);
  if (provider == null)
    return "";
  return getTextByLocale(provider.name, locale);
}

String getProviderImageById(String _providerId) {
  if (_providerId.isEmpty)
    return appSettings.customerLogoServer;
  ProviderData? provider = getProviderById(_providerId);
  if (provider == null)
    return "";
  if (provider.gallery.isNotEmpty)
    return provider.gallery[0].serverPath;
  return "";
}

ProviderData? getProviderByEmail(String userEmail) {
  for (var item in providers)
    if (item.login == userEmail)
      return item;
}


Future<String?> saveWorkArea(ProviderData _provider) async {
  try{
    await dbSetDocumentInTable("provider", _provider.id, {
          "route": _provider.route.map((i) {
                    return {'lat': i.latitude, 'lng': i.longitude};
             }).toList()
        }
    );

    // await FirebaseFirestore.instance.collection("provider").doc(_provider.id).set({
    //   "route": _provider.route.map((i){
    //     return {'lat': i.latitude, 'lng': i.longitude};
    //   }).toList()
    // }, SetOptions(merge: true));
  }catch(ex){
    return "saveWorkArea " + ex.toString();
  }
  return null;
}

Future<String?> saveProviderArticles(ProviderData _provider) async {
  try{
    await dbSetDocumentInTable("provider", _provider.id, {
        "articles": _provider.articles
      }
    );
    // await FirebaseFirestore.instance.collection("provider").doc(_provider.id).set({
    //   "articles": _provider.articles
    // }, SetOptions(merge: true));
  }catch(ex){
    return "saveProviderArticles " + ex.toString();
  }
  return null;
}

String getProviderAddress(String id){
  String _address = "";
  for (var item in providers)
    if (item.id == id) {
      _address = item.address;
      break;
    }
  return _address;
}

_initWeekEnd(){
  if (currentProvider.workTime.length != 7){
    currentProvider.workTime = [
      WorkTimeData(id: 0),
      WorkTimeData(id: 1),
      WorkTimeData(id: 2),
      WorkTimeData(id: 3),
      WorkTimeData(id: 4),
      WorkTimeData(id: 5),
      WorkTimeData(id: 6),
    ];
  }
}

providerSetDescTitle(String val, String langEditDataComboValue){
  for (var item in currentProvider.descTitle)
    if (item.code == langEditDataComboValue) {
      item.text = val;
      return;
    }
  currentProvider.descTitle.add(StringData(code: langEditDataComboValue, text: val));
}

providerSetName(String val, String langEditDataComboValue){
  for (var item in currentProvider.name)
    if (item.code == langEditDataComboValue) {
      item.text = val;
      return;
    }
  currentProvider.name.add(StringData(code: langEditDataComboValue, text: val));
}

providerSetDesc(String val, String langEditDataComboValue){
  for (var item in currentProvider.desc)
    if (item.code == langEditDataComboValue) {
      item.text = val;
      return;
    }
  currentProvider.desc.add(StringData(code: langEditDataComboValue, text: val));
}

Future<void> selectOpenDate(BuildContext context, String weekDataComboValue) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: 7, minute: 15),
    builder: (context, child) =>
        MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: appSettings.timeFormat == "24h"), child: child!),    // 24h - 12h
  );
  if (picked != null){
    _initWeekEnd();
    for (var item in currentProvider.workTime)
      if (item.id.toString() == weekDataComboValue){
        DateTime _timeClose = DateFormat('HH:mm').parse(item.closeTime);
        var _open = DateTime(0,0,0, picked.hour, picked.minute);
        var _close = DateTime(0,0,0, _timeClose.hour, _timeClose.minute);
        if (_open.isAfter(_close))
          _open = _close;
        item.openTime = DateFormat('HH:mm').format(_open);
      }
  }
}

Future<void> selectCloseDate(BuildContext context, String weekDataComboValue) async {
  var ret = "16:00";
  for (var item in currentProvider.workTime)
    if (item.id.toString() == weekDataComboValue)
      ret = item.closeTime;
  DateTime _time = DateFormat('HH:mm').parse(ret);
  //
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
    builder: (context, child) =>
        MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: appSettings.timeFormat == "24h"), child: child!),    // 24h - 12h
  );
  if (picked != null){
    _initWeekEnd();
    for (var item in currentProvider.workTime)
      if (item.id.toString() == weekDataComboValue){
        DateTime _timeOpen = DateFormat('HH:mm').parse(item.openTime);
        var _open = DateTime(0,0,0, _timeOpen.hour, _timeOpen.minute);
        var _close = DateTime(0,0,0, picked.hour, picked.minute);
        if (_close.isBefore(_open))
          _close = _open;
        item.closeTime = DateFormat('HH:mm').format(_close);
      }
  }
}

setWeekend(bool val, String weekDataComboValue){
  _initWeekEnd();
  for (var item in currentProvider.workTime)
    if (item.id.toString() == weekDataComboValue)
      item.weekend = val;
}

bool getWeekend(String weekDataComboValue){
  _initWeekEnd();
  for (var item in currentProvider.workTime)
    if (item.id.toString() == weekDataComboValue) {
      return item.weekend;
    }
  return false;
}

String getCloseTime(String weekDataComboValue){
  _initWeekEnd();
  var ret = "16:00";
  for (var item in currentProvider.workTime)
    if (item.id.toString() == weekDataComboValue)
      ret = item.closeTime;
  DateTime _time = DateFormat('HH:mm').parse(ret);
  return DateFormat(appSettings.getTimeFormat()).format(_time);
}

String getOpenTime(String weekDataComboValue){
  _initWeekEnd();
  var ret = "09:00";
  for (var item in currentProvider.workTime)
    if (item.id.toString() == weekDataComboValue)
      ret = item.openTime;
  DateTime _time = DateFormat('HH:mm').parse(ret);
  return DateFormat(appSettings.getTimeFormat()).format(_time);
}

Future<String?> setProviderAvailable(ProviderData _provider, bool val) async {
  try{
    await dbSetDocumentInTable("provider", _provider.id, {
      'available': val
      }
    );
    // await FirebaseFirestore.instance.collection("provider").doc(provider.id).set({
    //   'available': val
    // }, SetOptions(merge: true));
  }catch(ex){
    return "setProviderAvailable " + ex.toString();
  }
  return null;
}

Future<String?> saveProviderFromAdmin() async {
  try{
    var _data = currentProvider.toJson();
    await dbSetDocumentInTable("provider", currentProvider.id, _data);
    // await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id)
    //     .set(_data, SetOptions(merge:true));
  }catch(ex){
    return "MainDataProvider save " + ex.toString();
  }
  return null;
}

Future<String?> createProviderFromAdmin(UserData? newProvider, List<UserData> providersRequest) async {
  try{
    var _data = currentProvider.toJson();
    currentProvider.id = await dbAddDocumentInTable("provider", _data);
    // var t = await FirebaseFirestore.instance.collection("provider").add(_data);
    // currentProvider.id = t.id;
    // providers.add(currentProvider);
    await dbIncrementCounter("settings", "main", "provider_count", 1);
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"provider_count": FieldValue.increment(1)}, SetOptions(merge:true));
    if (newProvider != null) {
      await dbSetDocumentInTable("listusers", newProvider.id, {"providerRequest": false});
      // await FirebaseFirestore.instance.collection("listusers").doc(newProvider.id)
      //     .set({"providerRequest": false}, SetOptions(merge: true));
      providersRequest.remove(newProvider);
      newProvider = null;
      await dbIncrementCounter("settings", "main", "provider_request_count", -1);
      // await FirebaseFirestore.instance.collection("settings").doc("main")
      //     .set({"provider_request_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    }
  }catch(ex){
    return "createProviderFromAdmin " + ex.toString();
  }
  return null;
}

Future<String?> registerProvider(String email, String pass, String _login,
    String providerName, String phone, String desc, String address,
    List<String> category, String pathToImage, List<LatLng> routeForNewProvider) async {
  try {
    final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: pass,)).user;
    if (user == null)
      return "User don't create";

    // load image
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putFile(File(pathToImage));
    var _fileData = await File(pathToImage).readAsBytes();

    await dbSetDocumentInTable("listusers", user.uid, {
      "visible": true,
      "providerApp": true,
      "providerRequest" : true,
      "phoneVerified": false,
      "email": user.email,
      "phone": phone,
      "name": _login,
      "date_create" : DateTime.now().toUtc(),
      "providerName": providerName,
      "providerAddress": address,
      "providerDesc": desc,
      "providerLogoLocalFile": name,
      "providerLogoServerPath": await dbSaveFile(name, _fileData),
      "providerWorkArea": routeForNewProvider.map((i){
        return {'lat': i.latitude, 'lng': i.longitude};
      }).toList(),
      "providerCategory": category
    });

    // await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
    //   "visible": true,
    //   "providerApp": true,
    //   "providerRequest" : true,
    //   "phoneVerified": false,
    //   "email": user.email,
    //   "phone": phone,
    //   "name": _login,
    //   "date_create" : FieldValue.serverTimestamp(),
    //   "providerName": providerName,
    //   "providerAddress": address,
    //   "providerDesc": desc,
    //   "providerLogoLocalFile": name,
    //   "providerLogoServerPath": await dbSaveFile(name, _fileData),
    //   "providerWorkArea": routeForNewProvider.map((i){
    //     return {'lat': i.latitude, 'lng': i.longitude};
    //   }).toList(),
    //   "providerCategory": category
    // }, SetOptions(merge:true));

    await dbIncrementCounter("settings", "main", "provider_request_count", 1);
    await dbIncrementCounter("settings", "main", "provider_new_request_count", 1);

    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"provider_request_count": FieldValue.increment(1)}, SetOptions(merge:true));
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"provider_new_request_count": FieldValue.increment(1)}, SetOptions(merge:true));

  }catch(ex){
    return "model registerProvider " + ex.toString();
  }
  return null;
}

loadProvider(Function() callbackLoad) async{
  dbListenChanges("provider", (List<ProviderData> _data){
    providers = _data;
    callbackLoad();
    redrawMainWindow();
  });

  // FirebaseFirestore.instance.collection("provider").snapshots().listen((querySnapshot){
  //   providers = [];
  //   for (var result in querySnapshot.docs) {
  //     var _data = result.data();
  //     // dprint("Provider $_data");
  //     var t = ProviderData.fromJson(result.id, _data);
  //     providers.add(t);
  //   }
  //   callbackLoad();
  //   addStat("provider", querySnapshot.docs.length);
  // }).onError((ex){
  //   messageError(buildContext, "loadProvider " + ex.toString());
  // });
}

Future<String?> deleteProvider(ProviderData val) async {
  try{
    await dbDeleteDocumentInTable("provider", val.id);
    // await FirebaseFirestore.instance.collection("provider").doc(val.id).delete();
    await dbIncrementCounter("settings", "main", "provider_count", -1);
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"provider_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    if (val.id == currentProvider.id)
      currentProvider = ProviderData.createEmpty();
    //providers.remove(val);
  }catch(ex){
    return "deleteProvider " + ex.toString();
  }
  return null;
}

Future<String?> providerAddImageToGallery(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    currentProvider.gallery.add(ImageData(localFile: name, serverPath: await dbSaveFile(name, _imageData)));
  } catch (ex) {
    return "providerAddImageToGallery " + ex.toString();
  }
  return null;
}

Future<String?> providerSetLogoImageData(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    currentProvider.logoServerPath = await dbSaveFile(name, _imageData);
    currentProvider.logoLocalFile = name;
  } catch (ex) {
    return "providerSetLogoImageData " + ex.toString();
  }
  return null;
}

Future<String?> providerSetUpperImageData(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    currentProvider.imageUpperServerPath = await dbSaveFile(name, _imageData);
    currentProvider.imageUpperLocalFile = name;
  } catch (ex) {
    return "providerSetUpperImageData " + ex.toString();
  }
  return null;
}

Future<String?> providerDeleteImage(ImageData item) async {
  try{
    await dbFileDelete(item);
    for (var item2 in currentProvider.gallery)
      if (item.serverPath == item2.serverPath){
        currentProvider.gallery.remove(item2);
        break;
      }

  } catch (ex) {
    return "providerDeleteImage " + ex.toString();
  }
  return null;
}

class ProviderData {
  String id;
  List<StringData> name;
  String phone;
  String www;
  String instagram;
  String telegram;
  List<StringData> desc;
  List<StringData> descTitle;
  String address;
  //String avatar;
  bool visible;
  int unread = 0;
  int all = 0;
  String login;
  String lastMessage = "";
  DateTime lastMessageTime = DateTime.now();
  String chatId = "";

  String imageUpperServerPath = "";
  String imageUpperLocalFile = "";
  String logoServerPath = "";
  String logoLocalFile = "";
  List<ImageData> gallery = [];
  //
  List<WorkTimeData> workTime = [];
  List<String> category = [];
  //
  bool select = false;
  final dataKey = GlobalKey();
  List<LatLng> route;
  double distanceToUser = 0;
  bool available = true; // провайдер доступен или нет. В приложении провайдера устанавливается в Account'e
  String assetUpperImage;
  String assetsLogo;
  List<String> assetsGallery;
  List<String> assetsCategory;
  List<AddonData> addon;
  double tax; // default tax for provider
  List<String> articles;

  // int freeTrialDays;
  List<ProviderSubscriptionsData> subscriptions;

  //
  bool useMaximumServices; // максимальное количество сервисов
  int maxServices;
  bool useMaxAddonInOneService; // максимальное количество addon в одном сервисе
  int maxAddonInOneService;
  bool useMaximumProducts;  // максимальное количество товаров
  int maxProducts;
  bool useMinPurchaseAmount; // минимальная сумма покупки для этого провайдера в одном заказе
  double minPurchaseAmount;
  bool useMaxPurchaseAmount; // максимальная сумма покупки для этого провайдера в одном заказе
  double maxPurchaseAmount;
  bool acceptPaymentInCash; // принимать оплату наличными
  bool acceptOnlyInWorkArea; // разрешат только если пользователь находится в рабочей зоне провайдера

  ProviderData({this.id = "", required this.name, this.visible = true, this.address = "", required this.desc,
    this.phone = "", this.www = "", this.instagram = "", this.telegram = "", required  this.descTitle,
    this.imageUpperServerPath = "", this.imageUpperLocalFile = "",
    this.logoServerPath = "", this.logoLocalFile = "", required this.gallery, required this.workTime,
    required this.category,
    this.login = "", required this.route, this.available = true,
    this.assetUpperImage = "", this.assetsLogo = "", required this.assetsGallery, required this.assetsCategory,
    required this.addon, this.tax = 10, required this.articles,
    //
    this.useMaximumServices = false, this.maxServices = 0, this.useMaxAddonInOneService = false,
    this.maxAddonInOneService = 0, this.useMaximumProducts = false, this.maxProducts = 0,
    this.useMinPurchaseAmount = false, this.minPurchaseAmount = 0, this.useMaxPurchaseAmount = false,
    this.maxPurchaseAmount = 0, this.acceptPaymentInCash = true, this.acceptOnlyInWorkArea = false,
    //
    // this.freeTrialDays = 0,
    required this.subscriptions
  });

  factory ProviderData.createEmpty(){
    return ProviderData(descTitle: [StringData(code: "en", text: "Description",)], route: [], addon: [],
        gallery: [], workTime: [], desc: [], category: [], name: [], assetsGallery: [], assetsCategory: [],
        articles: [], subscriptions: []);
  }

  Map<String, dynamic> toJson() => {
    'name': name.map((i) => i.toJson()).toList(),
    'phone': phone,
    'www': www,
    'instagram': instagram,
    'telegram': telegram,
    'desc': desc.map((i) => i.toJson()).toList(),
    'descTitle': descTitle.map((i) => i.toJson()).toList(),
    'address': address,
    'visible': visible,
    'imageUpperServerPath': imageUpperServerPath,
    'imageUpperLocalFile': imageUpperLocalFile,
    'logoServerPath': logoServerPath,
    'logoLocalFile': logoLocalFile,
    'gallery': gallery.map((i) => i.toJson()).toList(),
    'workTime': workTime.map((i) => i.toJson()).toList(),
    'category': category,
    "login" : login,
    "tax" : tax,
    "route" : route.map((i){
      return {'lat': i.latitude, 'lng': i.longitude};
    }).toList(),
    'available': available,
    'addon': addon.map((i) => i.toJson()).toList(),
    'articles': articles,
    //
    'useMaximumServices': useMaximumServices,
    'maxServices': maxServices,
    'useMaxAddonInOneService': useMaxAddonInOneService,
    'maxAddonInOneService': maxAddonInOneService,
    'useMaximumProducts': useMaximumProducts,
    'maxProducts': maxProducts,
    'useMinPurchaseAmount': useMinPurchaseAmount,
    'minPurchaseAmount': minPurchaseAmount,
    'useMaxPurchaseAmount': useMaxPurchaseAmount,
    'maxPurchaseAmount': maxPurchaseAmount,
    'acceptPaymentInCash': acceptPaymentInCash,
    'acceptOnlyInWorkArea': acceptOnlyInWorkArea,
    //
    // 'freeTrialDays' : freeTrialDays,
    'subscriptions' : subscriptions.map((i) => i.toJson()).toList(),
  };

  factory ProviderData.fromJson(String id, Map<String, dynamic> data){
    List<ProviderSubscriptionsData> _subscriptions = [];
    if (data['subscriptions'] != null)
      for (var element in List.from(data['subscriptions'])) {
        _subscriptions.add(ProviderSubscriptionsData.fromJson(element));
      }
    _subscriptions.sort((a, b) => a.timeStart.compareTo(b.timeStart));
    List<String> _category = [];
    if (data['category'] != null)
      for (var element in List.from(data['category'])) {
        _category.add(element);
      }
    List<ImageData> _gallery = [];
    if (data['gallery'] != null)
      for (var element in List.from(data['gallery'])) {
        _gallery.add(ImageData(serverPath: element["serverPath"], localFile: element["localFile"]));
      }
    //
    List<WorkTimeData> _workTime = [];
    if (data['workTime'] != null)
      for (var element in List.from(data['workTime'])) {
        _workTime.add(WorkTimeData.fromJson(element));
      }
    //
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    List<StringData> _desc = [];
    if (data['desc'] != null)
      for (var element in List.from(data['desc'])) {
        _desc.add(StringData.fromJson(element));
      }
    List<StringData> _descTitle = [];
    if (data['descTitle'] != null)
      for (var element in List.from(data['descTitle'])) {
        _descTitle.add(StringData.fromJson(element));
      }
    List<LatLng> _route = [];
    if (data["route"] != null)
      for (var element in List.from(data['route'])) {
        if (element['lat'] != null && element['lng'] != null)
          _route.add(LatLng(
              element['lat'], element['lng']
          ));
      }
    List<AddonData> _addon = [];
    if (data['addon'] != null)
      for (var element in List.from(data['addon'])) {
        _addon.add(AddonData.fromJson(element));
      }
    List<String> _articles = [];
    if (data['articles'] != null)
      for (var element in List.from(data['articles'])) {
        _articles.add(element);
      }
    return ProviderData(
      id: id,
      name: _name,
      phone: (data["phone"] != null) ? data["phone"] : "",
      www: (data["www"] != null) ? data["www"] : "",
      instagram: (data["instagram"] != null) ? data["instagram"] : "",
      telegram: (data["telegram"] != null) ? data["telegram"] : "",
      desc: _desc,
      descTitle: _descTitle,
      address: (data["address"] != null) ? data["address"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      imageUpperServerPath: (data["imageUpperServerPath"] != null) ? data["imageUpperServerPath"] : "",
      imageUpperLocalFile: (data["imageUpperLocalFile"] != null) ? data["imageUpperLocalFile"] : "",
      logoServerPath: (data["logoServerPath"] != null) ? data["logoServerPath"] : "",
      logoLocalFile: (data["logoLocalFile"] != null) ? data["logoLocalFile"] : "",
      gallery: _gallery,
      workTime: _workTime,
      category: _category,
      //avatar: (data["avatar"] != null) ? data["avatar"] : "",
      login: (data["login"] != null) ? data["login"] : "",
      route : _route,
      available: (data["available"] != null) ? data["available"] : true,
      addon: _addon,
      tax: (data["tax"] != null) ? toDouble(data["tax"].toString()) : 10.0,
      assetsCategory: [],
      assetsGallery: [],
      articles: _articles,
      //
      useMaximumServices: (data["useMaximumServices"] != null) ? data["useMaximumServices"] : false,
      maxServices: (data["maxServices"] != null) ? toInt(data["maxServices"].toString()) : 0,
      useMaxAddonInOneService: (data["useMaxAddonInOneService"] != null) ? data["useMaxAddonInOneService"] : false,
      maxAddonInOneService: (data["maxAddonInOneService"] != null) ? toInt(data["maxAddonInOneService"].toString()) : 0,
      useMaximumProducts: (data["useMaximumProducts"] != null) ? data["useMaximumProducts"] : false,
      maxProducts: (data["maxProducts"] != null) ? toInt(data["maxProducts"].toString()) : 0,
      useMinPurchaseAmount: (data["useMinPurchaseAmount"] != null) ? data["useMinPurchaseAmount"] : false,
      minPurchaseAmount: (data["minPurchaseAmount"] != null) ? toDouble(data["minPurchaseAmount"].toString()) : 0.0,
      useMaxPurchaseAmount: (data["useMaxPurchaseAmount"] != null) ? data["useMaxPurchaseAmount"] : false,
      maxPurchaseAmount: (data["maxPurchaseAmount"] != null) ? toDouble(data["maxPurchaseAmount"].toString()) : 0.0,
      acceptPaymentInCash: (data["acceptPaymentInCash"] != null) ? data["acceptPaymentInCash"] : true,
      acceptOnlyInWorkArea: (data["acceptOnlyInWorkArea"] != null) ? data["acceptOnlyInWorkArea"] : false,
      //
      // freeTrialDays: (data["freeTrialDays"] != null) ? toInt(data["freeTrialDays"].toString()) : 0,
      subscriptions: _subscriptions,
    );
  }

  compareToAvailable(ProviderData b){
    if (available && !b.available)
      return 1;
    if (!available && b.available)
      return -1;
    return 0;
  }
}

class WorkTimeData{
  int id = 0;
  bool weekend = false;
  String openTime = "";
  String closeTime = "";

  WorkTimeData({this.id = 0, this.openTime = "09:00", this.closeTime = "16:00", this.weekend = false});

  Map<String, dynamic> toJson() => {
    'index': id,
    'openTime': openTime,
    'closeTime': closeTime,
    'weekend': weekend,
  };

  factory WorkTimeData.fromJson(Map<String, dynamic> data){
    return WorkTimeData(
      id: (data["index"] != null) ? data["index"] : 0,
      openTime: (data["openTime"] != null) ? data["openTime"] : "9:00",
      closeTime: (data["closeTime"] != null) ? data["closeTime"] : "16:00",
      weekend: (data["weekend"] != null) ? data["weekend"] : false,
    );
  }

  factory WorkTimeData.createEmpty(){
    return WorkTimeData();
  }
}

class ProviderSubscriptionsData{
  DateTime timeStart = DateTime.now();
  double price;
  String paymentMethod;
  int days;

  ProviderSubscriptionsData(this.timeStart, this.price, this.paymentMethod, this.days);

  Map<String, dynamic> toJson() => {
    "timeStart" : timeStart.millisecondsSinceEpoch,
    "price" : price,
    "paymentMethod": paymentMethod,
    "days": days,
  };

  factory ProviderSubscriptionsData.fromJson(Map<String, dynamic> data){
    return ProviderSubscriptionsData(
      (data["timeStart"] != null) ? DateTime.fromMillisecondsSinceEpoch(data["timeStart"]) : DateTime.now(),
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0.0,
      (data["paymentMethod"] != null) ? data["paymentMethod"] : "",
      (data["days"] != null) ? toInt(data["days"].toString()) : 0,
    );
  }
}
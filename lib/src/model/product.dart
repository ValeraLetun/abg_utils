import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../abg_utils.dart';

List<ProductData> product = [];
late DateTime _last;
ProductData currentProduct = ProductData.createEmpty();

ProductData getProduct(String id){
  for (var item in product)
    if (item.id == id)
      return item;

  return ProductData.createEmpty();
}

bool _loadProcess = false;

Future<String?> initService(String listen, String providerId, Function() callback) async{
  if (_loadProcess)
    return null;
  _loadProcess = true;
  product = [];
  dprint("initService get from 'service' where $listen arrayContains $providerId");
  await _getLocal();
  bool _localLoad = false;
  if (product.isEmpty) {
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    if (listen == "all")
       querySnapshot = await FirebaseFirestore.instance.collection("service").get();
    else
       querySnapshot = await FirebaseFirestore.instance.collection("service")
         .where(listen, arrayContains: providerId).get();

    for (var result in querySnapshot.docs) {
      var _data = result.data();
      var t = ProductData.fromJson(result.id, _data);
      if (!t.delete)
        product.add(t);
    }

    addStat("product", querySnapshot.docs.length);
  }else
    _localLoad = true;

  product.sort((a, b) => b.timeModify.compareTo(a.timeModify));
  if (product.isEmpty)
    _last = DateTime.now();
  else
    _last = product[0].timeModify; //timeUtc;

  if (!_localLoad)
    _saveLocal(_last);

  dprint("services init count=${product.length}");
  callback();
  _loadProcess = false;
  return await _listen(listen, providerId, callback);
}

// ignore: cancel_subscriptions
StreamSubscription? listenProductsStream;

Future<String?> _listen(String listen, String providerId, Function() callback) async{
  try{
    work(querySnapshot){
      for (var result in querySnapshot.docs) {
        var _data = ProductData.fromJson(result.id, result.data());

        for (var item in product)
          if (item.id == _data.id){
            dprint("Remove service with id = ${item.id}");
            product.remove(item);
            break;
          }
        dprint("Add service with id = ${_data.id}");
        if (!_data.delete)
          product.add(_data);
      }
      redrawMainWindow();

      product.sort((a, b) => b.timeModify.compareTo(a.timeModify));
      if (product.isEmpty)
        _last = DateTime.now();
      else
        _last = product[0].timeModify; //timeUtc;
      _saveLocal(_last);

      addStat("product listen", querySnapshot.docs.length);
      callback();
    }

    if (listen == "all"){
      listenProductsStream = FirebaseFirestore.instance.collection("service")
          .where("timeModify", isGreaterThan: _last)
          .snapshots().listen((querySnapshot) {
        work(querySnapshot);
      }, onError: (Object? obj){
        messageError(buildContext, obj.toString());
      });
    }else{
      dprint("products _listen $listen arrayContains $providerId timeModify $_last");
      listenProductsStream = FirebaseFirestore.instance.collection("service")
          .where(listen, arrayContains: providerId).where("timeModify", isGreaterThan: _last)
          .snapshots().listen((querySnapshot) {
        work(querySnapshot);
      }, onError: (Object? obj){
        messageError(buildContext, "Configure Indexes for services");
        dprint("Configure Indexes for services");
      });
    }

  }catch(ex){
    return "listenService " + ex.toString();
  }
  return null;
}

_saveLocal(DateTime _lastTime) async {
  if (kIsWeb){
    localStorage.update(
      "products.json",
          (val) {
        return json.encode({"data": product.map((i) {
          return i.toJson(local: true);
        }).toList()});
      },
      ifAbsent: () {
        return json.encode({"data": product.map((i) {
          return i.toJson(local: true);
        }).toList()});
      },
    );
  }else {
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    await File('$directoryPath/products.json')
        .writeAsString(json.encode({"data": product.map((i) {
      var m = i.toJson(local: true);
      // dprint("$m");
      return m;
    }).toList()}));
  }
}

_getLocal() async {
  work(_data){
    if (_data['data'] != null){
      for (var element in List.from(_data['data'])) {
        // dprint(element.toString());
        // dprint(element["id"]);

        var _newItem = ProductData.fromJson(element["id"], element, local: true);

        //
        // проверка на повторения
        // если повторения найдены. Надо очистить кеш и загрузить заново
        //
        for (var item in product)
          if (item.id == _newItem.id) {
            product = [];
            return;
          }

        product.add(_newItem);
      }
      addStat("product load", product.length, cache: true);
    }
  }

  if (kIsWeb) {
    MapEntry<String, String>? data;
    try {
      data = localStorage.entries.firstWhere((i) => i.key == "products.json");
    } on StateError {
      data = null;
    }
    if (data != null) {
      var _data = json.decode(data.value) as Map<String, dynamic>;
      work(_data);
    }
  }else{
    try{
      var directory = await getApplicationDocumentsDirectory();
      var directoryPath = directory.path;
      var _file = File('$directoryPath/products.json');
      if (await _file.exists()){
        final contents = await _file.readAsString();
        var _data = json.decode(contents);
        work(_data);
      }
    }catch(ex){
      dprint("exception _getLocal $ex");
    }
  }
}

productDeleteLocal() async {
  if (kIsWeb) {
    // MapEntry<String, String>? data;
    // try {
    //   data = localStorage.entries.firstWhere((i) => i.key == "products.json");
    // } on StateError {
    //   data = null;
    // }
    // if (data != null) {
    //   var _data = json.decode(data.value) as Map<String, dynamic>;
    //   work(_data);
    // }
  } else {
    try {
      var directory = await getApplicationDocumentsDirectory();
      var directoryPath = directory.path;
      var _file = File('$directoryPath/products.json');
      if (await _file.exists())
        await _file.delete();
    } catch (ex) {
      dprint("productDeleteLocal $ex");
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////
////                                EDIT                                      ///
/////////////////////////////////////////////////////////////////////////////////
/*
currentProduct

deleteProduct
saveProduct
addImageToGallery
deleteImageFromGallery
productSetDescTitle
productSetDesc
productSetName
price
  productSetNamePrice
  productSetPriceImageData
  productSetPrice
  productSetDiscPrice
  productGetPriceUnitCombo
  productSetPriceUnitCombo
Addon
  productAddAddon
  selectAddon
  deleteAddon
 */
/////////////////////////////////////////////////////////////////////////////////

Future<String?> deleteProduct(ProductData val) async {
  try{
    await FirebaseFirestore.instance.collection("service").doc(val.id).set({
      "delete": true,
      "timeModify": DateTime.now().toUtc(),
    }, SetOptions(merge:true));
    await FirebaseFirestore.instance.collection("settings").doc("main")
        .set({"service_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    // services.remove(val);
  }catch(ex){
    return "deleteProduct " + ex.toString();
  }
  // parent.notify();
  return null;
}

Future<String?> saveProduct(ProviderData provider, {bool admin = false}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "user == null";
  try{
    // await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
    //   "providerId": parent.providerData.id
    // }, SetOptions(merge:true));
    //

    if (currentProduct.id.isEmpty) {
      if (!admin) {
        currentProduct.providers.add(provider.id);
        currentProduct.taxAdmin = provider.tax;
      }
      var _data = currentProduct.toJson();
      var t = await FirebaseFirestore.instance.collection("service").add(_data);
      currentProduct.id = t.id;
      product.add(currentProduct);
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"service_count": FieldValue.increment(1)}, SetOptions(merge:true));
    }else {
      var _data = currentProduct.toJson();
      await FirebaseFirestore.instance.collection("service").doc(
          currentProduct.id).set(_data, SetOptions(merge: true));
    }
  }catch(ex){
    return "saveProduct " + ex.toString();
  }
  return null;
}


Future<String?> addImageToGallery(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "service/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    currentProduct.gallery.add(ImageData(localFile: name, serverPath: await dbSaveFile(name, _imageData)));
  } catch (ex) {
    return "addImageToGallery " + ex.toString();
  }
  return null;
}

Future<String?> deleteImageFromGallery(ImageData item) async {
  try{
    await dbFileDeleteServerPath(item.serverPath);
    // await FirebaseStorage.instance.refFromURL(item.serverPath).delete();
    currentProduct.gallery.remove(item);
  } catch (ex) {
    return "deleteImage " + ex.toString();
  }
  return null;
}

productSetPriceUnitCombo(String val, int level){
  if (level < currentProduct.price.length)
    currentProduct.price[level].priceUnit = val;
  else
    currentProduct.price.add(PriceData([], 0, 0, val, ImageData()));
}

productSetDescTitle(String val, String locale){
  for (var item in currentProduct.descTitle)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentProduct.descTitle.add(StringData(code: locale, text: val));
}

productSetDesc(String val, String locale){
  for (var item in currentProduct.desc)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentProduct.desc.add(StringData(code: locale, text: val));
}

productSetName(String val, String locale){ // parent.customerAppLangsComboValue
  for (var item in currentProduct.name)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentProduct.name.add(StringData(code: locale, text: val));
}

productSetNamePrice(String val, int level, String locale){ // parent.customerAppLangsComboValue
  if (level < currentProduct.price.length) {
    for (var item in currentProduct.price[level].name)
      if (item.code == locale) {
        item.text = val;
        return;
      }
    currentProduct.price[level].name.add(StringData(code: locale, text: val));
  }else
    currentProduct.price.add(PriceData([StringData(code: locale, text: val)], 0, 0, "hourly", ImageData()));
}

Future<String?> productSetPriceImageData(Uint8List _imageData, int level) async{
  try{
    var f = Uuid().v4();
    var name = "service/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    var _img = ImageData(localFile: name, serverPath: await dbSaveFile(name, _imageData));
    if (level < currentProduct.price.length)
      currentProduct.price[level].image = _img;
    else
      currentProduct.price.add(PriceData([], 0, 0, "hourly", _img));
  } catch (ex) {
    return "productSetPriceImageData " + ex.toString();
  }
  return null;
}

productSetPrice(String val, int level){
  double _price = double.parse(val);
  if (level < currentProduct.price.length)
    currentProduct.price[level].price = _price;
  else
    currentProduct.price.add(PriceData([], _price, 0, "hourly", ImageData()));
}

productSetDiscPrice(String val, int level){
  double _price = (val.isEmpty) ? 0 : double.parse(val);
  if (level < currentProduct.price.length)
    currentProduct.price[level].discPrice = _price;
  else
    currentProduct.price.add(PriceData([], 0, _price, "hourly", ImageData()));
}

productGetPriceUnitCombo(int level){
  if (level < currentProduct.price.length)
    return currentProduct.price[level].priceUnit;
  return "hourly";
}

////////////////////////////////////////////////////////////////////////////////
// add on
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

AddonData? editAddon;

Future<String?> productAddAddon(String name, double price, String locale,
    ProviderData? _provider,
    String stringEnterName,  // strings.get(115); /// "Please Enter Name",
    String stringEnterPrice,  // strings.get(170); /// "Please enter price",
    ) async {
  if (name.isEmpty)
    return stringEnterName; /// "Please Enter Name",
  if (price == 0)
    return stringEnterPrice; /// "Please enter price",
  late AddonData _addon;
  if (editAddon == null){
    _addon = AddonData(Uuid().v4(), [StringData(code: locale, text: name)], price);
    currentProduct.addon.add(_addon);
  }else {
    editAddon!.price = price;
    var _found = false;
    for (var item in editAddon!.name)
      if (item.code == locale) {
        item.text = name;
        _found = true;
      }
    if (!_found)
      editAddon!.name.add(StringData(code: locale, text: name));
    _addon = editAddon!;
  }

  _save(ProviderData item) async {
    if (editAddon == null)
      item.addon.add(_addon);
    else{
      for (var _add in item.addon)
        if (_add.id == _addon.id) {
          _add.price = _addon.price;
          _add.name = _addon.name;
        }
    }
    try{
      dbSetDocumentInTable("provider", item.id, {
        'addon': item.addon.map((i) => i.toJson()).toList(),
      });
      // var _data = item.toJson();
      // await FirebaseFirestore.instance.collection("provider").doc(item.id)
      //     .set({
      //   'addon': item.addon.map((i) => i.toJson()).toList(),
      // }, SetOptions(merge:true));
    }catch(ex){
      return "MainDataService addAddon " + ex.toString();
    }
  }

  if (currentProduct.providers.isNotEmpty){
    if (_provider != null){
      _save(_provider);
    }else
      for (var item in providers)
        if (item.id == currentProduct.providers[0]){
          _save(item);
        }
  }
  editAddon = null;
  return null;
}

selectAddon(AddonData item, bool _select){
  if (_select){
    currentProduct.addon.add(item);
  }else{
    for (var addon in currentProduct.addon)
      if (addon.id == item.id) {
        currentProduct.addon.remove(item);
        break;
      }
  }
}

Future<String?> deleteAddon(String id) async {
  for (var service in product)
    for (var item in service.addon)
      if (item.id == id) {
        service.addon.remove(item);
        try{
          var _data = service.toJson();
          await FirebaseFirestore.instance.collection("service").doc(service.id).set(_data, SetOptions(merge:true));
        }catch(ex){
          return "deleteAddon " + ex.toString();
        }
        break;
      }
  for (var item in providers)
    if (currentProduct.providers.isNotEmpty && item.id == currentProduct.providers[0]){
      for (var _provAddon in item.addon)
        if (_provAddon.id == id){
          item.addon.remove(_provAddon);
          break;
        }
      try{
        var _data = item.toJson();
        await FirebaseFirestore.instance.collection("provider").doc(item.id).set(_data, SetOptions(merge:true));
      }catch(ex){
        return "deleteAddon " + ex.toString();
      }
    }
  return null;
}


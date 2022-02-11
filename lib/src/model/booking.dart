import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../abg_utils.dart';
import 'package:universal_html/html.dart' as html;

List<OrderData> bookings = [];
int newBookingCount = 0;
late DateTime _last;

Function()? _jobInfoListen;
setJobInfoListen(Function()? jobInfoListen){
  _jobInfoListen = jobInfoListen;
}

//
// listen  - "providerId",
//
Future<String?> initBookings(String listen, String userEmail) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";

  String providerId = "";
  if (listen == "providerId")
    providerId = await getProviderId(userEmail);
  if (listen == "customerId")
    providerId = user.uid;

  newBookingCount = 0;
  await _getLocal();
  bool _localLoad = false;
  if (bookings.isEmpty) {
    var ret = await _load(listen, providerId);
    if (ret != null)
      return ret;
  }else
    _localLoad = true;

  bookings.sort((a, b) => b.time.compareTo(a.time));
  bookings.sort((a, b) => b.timeModify.compareTo(a.timeModify));
  if (bookings.isEmpty)
    _last = DateTime.now();
  else
    _last = bookings[0].timeModify; //timeUtc;

  if (!_localLoad)
    _saveLocal(_last);

  // dprint("booking init bookingsCount=${bookings.length}");
  return await _listen(listen, providerId);
}

Future<String?> _load(String listen, String providerId) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";
  try{
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    // for admin panel
    if (listen == "all")
      querySnapshot = await FirebaseFirestore.instance.collection("booking")
          .where("time", isGreaterThan: DateTime.now().subtract(Duration(days: 7))).get();
    else  // for customer and provider apps
      querySnapshot = await FirebaseFirestore.instance.collection("booking")
          .where("timeModify", isGreaterThan: DateTime.now().subtract(Duration(days: 7)))
      // .where(listen, isEqualTo: providerId).where("timeModify", isGreaterThan: _last)
        .where(listen, isEqualTo: providerId).get(); // listen = "providerId" or "customerId"
    //
    bookings = [];
    // var index = 0;
    for (var result in querySnapshot.docs) {
      // dprint("booking _load ${result.id}");
      var _data = OrderData.fromJson(result.id, result.data());
      if (_data.status != "temp" && !_data.delete) {
        bookings.add(_data);
        // index++;
        // dprint("$index _data.viewByProvider=${_data.viewByProvider} ${_data.id} ${_data.time}");
        if (!_data.viewByProvider && listen == "providerId")
          newBookingCount++;
      }
    }

    for (var item in bookings)
      for (var item2 in item.addon)
        item2.selected = true;
    //
    if (listen == "all") // for admin panel
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"booking_count_unread": 0}, SetOptions(merge:true));

    addStat("booking load", querySnapshot.docs.length);

  }catch(ex){
    return "booking _load " + ex.toString();
  }
  return null;
}

// ignore: cancel_subscriptions
StreamSubscription? listenBookingStream;

Future<String?> _listen(String listen, String providerId) async{
  try{
    List<OrderData> listV4 = [];
    // var _lastTimeV1Call = false;
    work(querySnapshot) async {
      for (var result in querySnapshot.docs) {
        var _data = OrderData.fromJson(result.id, result.data());
        if (_data.status != "temp") {
          for (var item in bookings)
            if (item.id == _data.id){
              //dprint("Remove booking with id = ${item.id}");
              bookings.remove(item);
              newBookingCount--;
              break;
            }
          //dprint("Add booking with id = ${_data.id}");
          if (!_data.delete)
            bookings.add(_data);
        }
        //dprint("listen _data.viewByProvider=${_data.viewByProvider} ${_data.id}");
        if (!_data.viewByProvider && listen == "providerId")
          newBookingCount++;

        if (!_data.ver4) {
          // dprint("bookingSaveInCache ${_data.id}");
          listV4.add(_data);
          //await bookingSaveInCache(_data, migrate: true);
          // _lastTimeV1Call = true;
        }
      }
      if (newBookingCount < 0)
        newBookingCount = 0;
      for (var item in bookings)
        for (var item2 in item.addon)
          item2.selected = true;
      bookings.sort((a, b) => b.time.compareTo(a.time));
      if (_jobInfoListen != null) {
        _jobInfoListen!();
      }
      redrawMainWindow();
      // dprint("booking _listen count=${bookings.length}");
      _saveLocal(_last);
      addStat("booking listen", querySnapshot.docs.length);

      if (listV4.isNotEmpty)
        await bookingSaveInCacheList(listV4);
        FirebaseFirestore.instance.collection("settings").doc("main").set({
          "lastTimeV1Call": DateTime.now().toUtc()
        }, SetOptions(merge:true));
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "not register";

    if (listen == "all") { // admin panel
      FirebaseFirestore.instance.collection("booking").where("timeModify", isGreaterThan: _last)
          .snapshots().listen((querySnapshot) async {
        work(querySnapshot);
      });
    }else
      listenBookingStream = FirebaseFirestore.instance.collection("booking")
          .where(listen, isEqualTo: providerId).where("timeModify", isGreaterThan: _last)
          .snapshots().listen((querySnapshot) {
         work(querySnapshot);
      }, onError: (Object? obj){
        messageError(buildContext, "Configure Indexes for booking ${obj.toString()}");
        dprint("Configure Indexes for booking");
      });

  }catch(ex){
    return "listenBooking " + ex.toString();
  }
  return null;
}

Future<String?> setBookingToRead(String listen) async{
  try{
    // var index = 0;
    if (listen == "viewByProvider")
      for (var item in bookings){
       // index++;
        //dprint("$index setBookingToRead item.viewByProvider=${item.viewByProvider} ${item.id} ${item.time}");
        if (!item.viewByProvider){
          await FirebaseFirestore.instance.collection("booking").doc(item.id).set({
            "viewByProvider": true,
            "timeModify": DateTime.now().toUtc(),
          }, SetOptions(merge: true));
          item.viewByProvider = true;
        }
        newBookingCount = 0;
      }

  }catch(ex){
    return "setBookingToRead " + ex.toString();
  }
  return null;
}

Future<String?> bookingDelete(OrderData val) async {
  try{
    await FirebaseFirestore.instance.collection("booking").doc(val.id).set({
      "delete": true,
      "timeModify": DateTime.now().toUtc(),
    }, SetOptions(merge:true));
    await FirebaseFirestore.instance.collection("settings").doc("main")
        .set({"booking_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    // if (val.id == current.id)
    //   current = OrderData.createEmpty();
    // bookings.remove(val);
  }catch(ex){
    return "bookingDelete " + ex.toString();
  }
  // parent.notify();
  return null;
}

Future<String?> saveBooking(OrderData current) async {
  try{
    var _data = current.toJson();
    await FirebaseFirestore.instance.collection("booking").doc(current.id).set(_data, SetOptions(merge:true));
  }catch(ex){
    return "saveBooking " + ex.toString();
  }
  return null;
}


//
//
//


html.Storage get localStorage => html.window.localStorage;

/*
 localStorage.remove(fileName);
  Future<bool> exists() async {
    return localStorage.containsKey(fileName);
  }
 */

_saveLocal(DateTime _lastTime) async {
  //dprint("_saveLocal bookings.length=${bookings.length}");
  if (kIsWeb){
    work(val){
      return json.encode({"data": bookings.map((i) {
        var m = i.toJson(local: true);
        //dprint("_saveLocal $m");
        return m;
      }).toList()});
    }
    localStorage.update(
      "booking.json", work,
          ifAbsent: () { return work("");},
    );
  }else{
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    await File('$directoryPath/booking.json')
        .writeAsString(json.encode({"data": bookings.map((i) {
      var m = i.toJson(local: true);
      //dprint("$m");
      return m;
    }).toList()}));
  }
}

_getLocal() async {
  work(_data){
    if (_data['data'] != null) {
      for (var element in List.from(_data['data'])) {
        //dprint(element.toString());
        //dprint(element["id"]);

        var _newItem = OrderData.fromJson(element["id"], element, local: true);

        //
        // проверка на повторения
        // если повторения найдены. Надо очистить кеш и загрузить заново
        //
        for (var item in bookings)
          if (item.id == _newItem.id) {
            bookings = [];
            return;
          }

        bookings.add(_newItem);
      }
    }
    addStat("booking load", bookings.length, cache: true);
  }

  if (kIsWeb) {
    MapEntry<String, String>? data;
    try {
      data = localStorage.entries.firstWhere((i) => i.key == "booking.json");
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
      var _file = File('$directoryPath/booking.json');
      if (await _file.exists()){
        final contents = await _file.readAsString();
        var _data = json.decode(contents);
        work(_data);
      }
    }catch(ex){
      dprint("exception booking _getLocal $ex");
    }
  }
}



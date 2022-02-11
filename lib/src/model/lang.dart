
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../abg_utils.dart';


// app = "service"

Future<String?> ifNeedLoadNewLanguages(List<LangData> appLangs, String app, Function(LangData) callback) async {
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("language").doc("langs").get();
    var data = querySnapshot.data();
    if (data == null)
      return "langs = null";
    addStat("langs", data.length);
    //dprint("loadLanguages data=$data");
    if (data['list'] != null) {
      var elementList = data['list'];
      appLangs = [];
      elementList.forEach((item) {
        var t = LangData.fromJson(item);
        callback(t);
        if (t.app == app)
          appLangs.add(t);
        // appLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: app,
        //     direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
        //     data: {}),);
      });

      //
      // get language version
      //
      if (data['ver'].toString() != localSettings.langVer){
        // save local
        var directory = await getApplicationDocumentsDirectory();
        var directoryPath = directory.path;
        //dprint("appLangs ${appLangs.length}");
        await File('$directoryPath/listlangs.json').writeAsString(json.encode(appLangs.map((i) => i.toJson()).toList()));
        appSettings.langVer = data['ver'];
        await saveSettingsToLocalFile(appSettings);
        //
        // get languages
        //
        for (var element in appLangs){
          var _doc = "${element.app}_${element.locale}";
          var querySnapshot = await FirebaseFirestore.instance.collection("language").doc(_doc).get();
          var data = querySnapshot.data();
          if (data != null) {
            Map<String, dynamic> _words = data['data'];
            // save local
            //dprint("save language local $_doc");
            var _t = json.encode(_words);
            await File('$directoryPath/$_doc.json').writeAsString(_t);
          }
        }
        localSettings.setLangVersion(data['ver'].toString());
      }
    }
  }catch(ex){
    return "ifNeedLoadNewLanguages " + ex.toString();
  }
  return null;
}

Future<String?> loadLangsFromLocal(String locale,
    String needLocale, Function(LangData lang) setLang, Function(List<LangData> lang) setLangs) async {
  try{
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var _file = File('$directoryPath/listlangs.json');
    if (!await _file.exists())
      return null;
    final contents = await _file.readAsString();
    var data = json.decode(contents);
    //dprint("loadLangsFromLocal $data");
    List<LangData> t = data.map((f) {
      var b = LangData.fromJson(f);
      //dprint("loadLangsFromLocal ${b.locale}");
      return b;
    } ).cast<LangData>().toList();
    setLangs(t); // parent.appLangs = t;
    // dprint("loadLangsFromLocal appLangs ${t.appLangs}");
    for (var item in t){
      var _doc = "${item.app}_${item.locale}";
      var _file = File('$directoryPath/$_doc.json');
      if (!await _file.exists())
        return null;
      final contents = await _file.readAsString();
      //dprint('read local lang $directoryPath/$_doc.json');
      item.data = json.decode(contents);
      if (locale.isNotEmpty){
        if (locale == item.locale)
          setLang(item); //item.data, item.locale, context, item.direction);
      }else
      if (needLocale == item.locale)
        setLang(item); // item.data, item.locale, context, item.direction);
    }
  }catch(ex){
    return "model loadLangsFromLocal " + ex.toString();
  }
  return null;
}

Future<String?> saveUpdatedLang(LangData lang, querySnapshot, String _name) async {
  // print("saveUpdatedLang $_name");
  var _data = querySnapshot.data();
  Map<String, dynamic> _words = _data!['data'];
  // print("old length=${_words.length}");
  // print("new length=${lang.data.length}");
  bool _added = false;
  // for (int i = _words.length+1; i<=lang.data.length; i++){
  for (int i = 0; i <= lang.data.length; i++){
    // print("---$_name ${lang.data[i.toString()]} ${_words[i.toString()]}" );
    if (lang.data[i.toString()] != null && _words[i.toString()] == null) {
      _words.addAll({i.toString(): lang.data[i.toString()]});
      // print("add $_name $i : ${lang.data[i.toString()]} ${_words[i.toString()]}" );
      _added = true;
    }
  }
  if (_added)
    await FirebaseFirestore.instance.collection("language").doc(_name).set(_data, SetOptions(merge:true));
}

class LangData{
  LangData({required this.name, required this.engName, this.image = "",
    required this.direction, required this.locale, this.app = "service", required this.data, this.words = 0});
  String name;
  String engName;
  String image;
  TextDirection direction;
  String locale;
  String app;
  Map<String, dynamic> data;
  int words;

  Map toJson() => {
    'name' : name,
    'engName' : engName,
    'direction' : direction == TextDirection.ltr ? "ltr" : 'rtl',
    'locale' : locale,
    'app' : app,
    'words' : words,
  };

  factory LangData.fromJson(Map<String, dynamic> data){
    return LangData(
        name: data["name"] ?? "",
        engName: data["engName"] ?? "",
        app: data["app"] ?? "service",
        direction: data["direction"] != null ? data["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl : TextDirection.ltr,
        locale: data["locale"] ?? "",
        data: {},
        words: data["words"] != null ? toInt(data["words"].toString()) : 0,
    );
  }
}
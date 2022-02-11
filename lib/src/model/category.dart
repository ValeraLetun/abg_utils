import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../abg_utils.dart';

List<CategoryData> categories = [];
CategoryData currentCategory = CategoryData.createEmpty();

Future<String?> categoryCreate() async {
  try{
    var _data = currentCategory.toJson();
    currentCategory.id = await dbAddDocumentInTable("category", _data);
    // var t = await FirebaseFirestore.instance.collection("category").add(_data);
    // currentCategory.id = t.id;
    categories.add(currentCategory);
    await dbIncrementCounter("settings", "main", "category_count", 1);
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"category_count": FieldValue.increment(1)}, SetOptions(merge:true));
  }catch(ex){
    return "categoryCreate " + ex.toString();
  }
  return null;
}

Future<String?> categorySave() async {
  try{
    var _data = currentCategory.toJson();
    await dbSetDocumentInTable("category", currentCategory.id, _data);
    // await FirebaseFirestore.instance.collection("").doc(currentCategory.id).set(_data, SetOptions(merge:true));
  }catch(ex){
    return "categorySave " + ex.toString();
  }
  return null;
}

Future<String?> categoryDelete(CategoryData item) async {
  try{
    await dbDeleteDocumentInTable("category", item.id);
    // await FirebaseFirestore.instance.collection("category").doc(val.id).delete();
    await dbIncrementCounter("settings", "main", "category_count", -1);
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"category_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    if (item.id == currentCategory.id)
      currentCategory = CategoryData.createEmpty();
    categories.remove(item);
  }catch(ex){
    return "categoryDelete " + ex.toString();
  }
  return null;
}

Future<String?> categorySetImage(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "category/$f.jpg";
    currentCategory.serverPath = await dbSaveFile(name, _imageData);
    currentCategory.localFile = name;
  } catch (e) {
    return "categorySetImage " + e.toString();
  }
  return null;
}

List<String> getCategories(List<String> val, String locale, List<CategoryData> category){
  List<String> ret = [];
  for (var item in val) {
    for (var item2 in category)
      if (item == item2.id) {
        ret.add(getTextByLocale(item2.name, locale));
        break;
      }
  }
  return ret;
}

String getCategoryNames(List<String> ids){
  var _text = "";
  for (var item in ids) {
    var t = getCategoryNameById(item);
    if (t.isNotEmpty){
      if (_text.isNotEmpty)
        _text = "$_text, ";
      _text = "$_text$t";
    }
  }
  return _text;
}

List<String> getServiceCategories(List<String> val){
  List<String> ret = [];
  for (var item in val) {
    for (var item2 in categories)
      if (item == item2.id) {
        ret.add(getTextByLocale(item2.name, locale));
        break;
      }
  }
  return ret;
}

String getCategoryNameById(String id){
  for (var item in categories)
    if (item.id == id)
      return getTextByLocale(item.name, locale);
  return "";
}

Future<String?> loadCategory(bool onlyVisible) async{
  try{
    List<CategoryData> _categories = await dbGetAllDocumentInTable("category");
    if (onlyVisible){
      categories = [];
      for (var item in _categories)
        if (item.visible)
          categories.add(item);
    }else
      categories = _categories;

    dbListenChanges("category", (List<CategoryData>_categories){
      if (onlyVisible){
        categories = [];
        for (var item in _categories)
          if (item.visible)
            categories.add(item);
      }else
        categories = _categories;
      if (redrawMainWindowInitialized)
        redrawMainWindow();
    });

  }catch(ex){
    return "loadCategory " + ex.toString();
  }
  return null;
}

bool ifCategoryHaveSubcategories(String id){
  for (var item in categories)
    if (item.parent == id)
      return true;
  return false;
}

//

categorySetName(String val, String locale){ // parent.langEditDataComboValue
  for (var item in currentCategory.name)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentCategory.name.add(StringData(code: locale, text: val));
}

categorySetDesc(String val, String locale){ /// parent.langEditDataComboValue
  for (var item in currentCategory.desc)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentCategory.desc.add(StringData(code: locale, text: val));
}

class CategoryData {
  String id;
  List<StringData> name;
  List<StringData> desc;
  bool visible;
  bool visibleCategoryDetails;

  String localFile = "";
  String serverPath = "";

  Color color;
  String parent;
  bool select = false;
  String assetFile = "";
  final dataKey = GlobalKey();
  final dataKey2 = GlobalKey();

  CategoryData({required this.id, required this.name,
    required this.localFile, required this.serverPath,
    required this.color, required this.parent,
    required this.visible, required this.visibleCategoryDetails,
    required this.desc, this.assetFile = ""});

  factory CategoryData.createEmpty(){
    return CategoryData(id: "", name: [], localFile: "", serverPath: "",
        color: Colors.green, parent: "", visible: true, visibleCategoryDetails: true,
        desc: []);
  }

  Map<String, dynamic> toJson() => {
    'name' : name.map((i) => i.toJson()).toList(),
    'desc' : desc.map((i) => i.toJson()).toList(),
    'visible' : visible,
    'visibleCategoryDetails' : visibleCategoryDetails,
    'localFile': localFile,
    'serverPath' : serverPath,
    'color': color.value.toString(),
    'parent' : parent,
  };

  factory CategoryData.fromJson(String id, Map<String, dynamic> data){
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
    return CategoryData(
      id: id,
      name: _name,
      localFile: (data["localFile"] != null) ? data["localFile"] : "",
      serverPath: (data["serverPath"] != null) ? data["serverPath"] : "",
      color: (data["color"] != null) ? toColor(data["color"]) : Colors.red,
      parent: (data["parent"] != null) ? data["parent"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      visibleCategoryDetails: (data["visibleCategoryDetails"] != null) ? data["visibleCategoryDetails"] : true,
      desc: _desc,
    );
  }

  compareToVisible(CategoryData b){
    if (visible && !b.visible)
      return 1;
    if (!visible && b.visible)
      return -1;
    return 0;
  }
}



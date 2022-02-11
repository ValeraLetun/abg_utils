import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

ProductData currentArticle = ProductData.createEmpty();
String groupToEdit = "";
ImageData? uploadedImage;
GroupData? variantGroupEdit;
PriceData? variantEdit;

List<ProductDataCache> productDataCache = [];
List<ProductDataCache> productDataCacheSort = [];

Future<String?> loadArticleCache(bool onlyVisible) async {
  try{
    work(querySnapshot){
      productDataCache = [];
      if (querySnapshot.exists){
        if (querySnapshot.data() != null) {
          var _meData = querySnapshot.data()!;
          for (var item in _meData.entries){
            var t = ProductDataCache.fromJson(item.key, item.value);
            if (!t.delete) {
              if (onlyVisible) {
                if (t.visible)
                  productDataCache.add(t);
              } else
                productDataCache.add(t);
            }
          }
        }
        productDataCache.sort((a, b) => b.timeModify.compareTo(a.timeModify));
      }
    }

    var querySnapshot = await FirebaseFirestore.instance.collection("cache").doc("article").get();
    work(querySnapshot);

    FirebaseFirestore.instance.collection("cache")
        .doc("article").snapshots().listen((querySnapshot) {
      work(querySnapshot);
      redrawMainWindow();
    });

  }catch(ex){
    return "loadArticleCache " + ex.toString();
  }
  return null;
}

Future<String?> articleGetItemToEdit(ProductDataCache item) async {
  try{
    currentArticle = ProductData.createEmpty();
    var querySnapshot = await FirebaseFirestore.instance.collection("article").doc(item.id).get();
    if (querySnapshot.exists){
      if (querySnapshot.data() != null) {
        var _meData = querySnapshot.data()!;
        currentArticle = ProductData.fromJson(querySnapshot.id, _meData);
      }else
        return "articleGetItemToEdit querySnapshot.data() = null";
    }else
      return "articleGetItemToEdit ${item.id} not exists";
  }catch(ex){
    return "articleGetItemToEdit " + ex.toString();
  }
  return null;
}

////// search
String articleSortByProvider = "not_select";
String articleSearchText = "";
int articleAscDesc = 0;
int _count = 0;
double articleMinPrice = 0;
double articleMaxPrice = -1;

articleSort({bool isFindInEmpty = false}){
  _count = 20;
  _articleSort(isFindInEmpty: isFindInEmpty);
}

_articleSort({bool isFindInEmpty = false}){
  int _c = 0;
  productDataCacheSort = [];
  if (articleSearchText.isEmpty && !isFindInEmpty)
    return;

  if (articleAscDesc == 1)
    productDataCache.sort((a, b) => getTextByLocale(a.name, locale).compareTo(getTextByLocale(b.name, locale)));
  if (articleAscDesc == 2)
    productDataCache.sort((a, b) => getTextByLocale(b.name, locale).compareTo(getTextByLocale(a.name, locale)));
  if (articleAscDesc == 3)
    productDataCache.sort((a, b) => getDistanceByProviderId(a.providers.isNotEmpty ? a.providers[0] : "")
        .compareTo(getDistanceByProviderId(b.providers.isNotEmpty ? b.providers[0] : "")));
  if (articleAscDesc == 4)
    productDataCache.sort((a, b) => getDistanceByProviderId(b.providers.isNotEmpty ? b.providers[0] : "")
        .compareTo(getDistanceByProviderId(a.providers.isNotEmpty ? a.providers[0] : "")));

  for (var item in productDataCache) {
    // not_select  все провайдеры
    if (articleSortByProvider != "not_select") {
      if (articleSortByProvider == "root") { // показывать товары администрации
        if (item.providers.isNotEmpty) // providers - должно быть пустым
          continue;
      }
      else
        if (!item.providers.contains(articleSortByProvider))
          continue;
    }
    if (articleSearchText.isNotEmpty)
      if (!getTextByLocale(item.name, locale).toUpperCase().contains(articleSearchText.toUpperCase()))
        continue;
    double _price = item.price;
    if (item.discPrice != 0)
      _price = item.discPrice;
    if (_price < articleMinPrice  || _price > articleMaxPrice)
      continue;
    productDataCacheSort.add(item);
    _c++;
    if (_c == _count)
      break;
  }
}

articleSortGetNextPage(bool isFindInEmpty){
  _count += 20;
  _articleSort(isFindInEmpty: isFindInEmpty);
}

//////////////

List<ProductDataCache> getProductsByProvider(String providerId) {
  List<ProductDataCache> _products = [];
  for (var item in productDataCache) {
    if (providerId == "not_select"){
      _products.add(item);
      continue;
    }
    if (providerId == "root" && item.providers.isEmpty) {
        _products.add(item);
        continue;
      }
    if (!item.providers.contains(providerId))
      continue;
    _products.add(item);
  }
  return _products;
}

articleSetName(String val, String locale){
  for (var item in currentArticle.name)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentArticle.name.add(StringData(code: locale, text: val));
}

Future<String?> articleDeleteImageFromGallery(ImageData item)async {
  try{
    if (item.serverPath.startsWith("https://firebasestorage.googleapis.com"))
      await dbFileDeleteServerPath(item.serverPath);
      // await FirebaseStorage.instance.refFromURL(item.serverPath).delete();
    currentArticle.gallery.remove(item);
  } catch (ex) {
    return "articleDeleteImageFromGallery " + ex.toString();
  }
  return null;
}

articleSetDescTitle(String val, String locale){ // parent.langEditDataComboValue
  for (var item in currentArticle.descTitle)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentArticle.descTitle.add(StringData(code: locale, text: val));
}

articleSetDesc(String val, String locale){ //
  for (var item in currentArticle.desc)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentArticle.desc.add(StringData(code: locale, text: val));
}

Future<String?> createArticle(ProviderData? _provider) async{
  try{
    currentArticle.thisIsArticle = true;
    var _data = currentArticle.toJson();
    var t = await FirebaseFirestore.instance.collection("article").add(_data);
    currentArticle.id = t.id;
    //articles.add(currentArticle);
    //
    await articleSaveInCache(currentArticle);

    if (_provider != null) {
      _provider.articles.add(t.id);
      saveProviderArticles(_provider);
    }else{
    }

  }catch(ex){
    return "createArticle " + ex.toString();
  }
  return null;
}

articleSaveInCache(ProductData _product) async {

  int _stock = 0;
  for (var _group in _product.group)
    for (var _var in _group.price)
      _stock += _var.stock;

  var _cache = ProductDataCache(
    id: _product.id,
    timeModify: _product.timeModify,
    name: _product.name,
    visible: _product.visible,
    price: _product.priceProduct,
    category: _product.category,
    providers: _product.providers,
    rating: _product.getRating(),
    image: _product.gallery.isNotEmpty ? _product.gallery[0].serverPath : "",
    discPrice: _product.discPriceProduct,
    stock: _stock,
    delete: _product.delete,
  );
  await FirebaseFirestore.instance.collection("cache").doc("article")
      .set({
    _product.id: _cache.toJson(),
  }, SetOptions(merge:true));

  var index = 0;
  for (var item in productDataCache)
    if (item.id == _product.id){
      index = productDataCache.indexOf(item);
      productDataCache.remove(item);
      break;
    }
  if (!_cache.delete)
    productDataCache.insert(index, _cache);
}

Future<String?> articleSave() async {
  try{
    var _data = currentArticle.toJson();
    await FirebaseFirestore.instance.collection("article").doc(currentArticle.id).set(_data, SetOptions(merge:true));
    await articleSaveInCache(currentArticle);
  }catch(ex){
    return "articleSave save " + ex.toString();
  }
  return null;
}

Future<String?> articleDelete(ProductDataCache item) async {
  if (currentArticle.id == item.id)
    currentArticle = ProductData.createEmpty();
  var t = currentArticle;
  var ret = await articleGetItemToEdit(item);
  var _loadedArticle = currentArticle;
  currentArticle = t;
  if (ret != null)
    return ret;
  try{
    await FirebaseFirestore.instance.collection("article").doc(_loadedArticle.id).set({
      "delete": true,
      "timeModify": DateTime.now().toUtc(),
    });
    _loadedArticle.delete = true;
    await articleSaveInCache(_loadedArticle);
  }catch(ex){
    return "articleDelete " + ex.toString();
  }
  return null;
}

articleEmptyCurrent(){
  currentArticle = ProductData.createEmpty();
}

Future<String?> articleAddImageToGallery(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "product/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    currentArticle.gallery.add(ImageData(localFile: name, serverPath: await dbSaveFile(name, _imageData)));
  } catch (ex) {
    return "articleAddImageToGallery " + ex.toString();
  }
  return null;
}

Future<String?> articleAddImageToVariant(Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "product/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    uploadedImage = ImageData(localFile: name, serverPath: await dbSaveFile(name, _imageData));
  } catch (ex) {
    return "articleAddImageToVariant " + ex.toString();
  }
  return null;
}

class ProductDataCache {
  String id;
  DateTime timeModify; // время воследней модификации (для listener)
  List<StringData> name;
  bool visible;
  double price;
  double discPrice;
  List<String> category;
  List<String> providers; // Id
  double rating = 0;
  String image;
  int stock;
  bool delete;


  ProductDataCache({required this.id,
    required this.timeModify,
    required this.name,
    required this.visible,
    required this.discPrice,
    required this.price,
    required this.category,
    required this.providers,
    required this.rating,
    required this.image,
    required this.stock,
    required this.delete,
  });

  Map<String, dynamic> toJson({bool local = false}) {
    return {
      't': local ? timeModify.toIso8601String() : DateTime.now().toUtc(),
      'n': name.map((i) => i.toJson()).toList(),
      'v': visible,
      'd': discPrice,
      'm': price,
      'c': category,
      'p': providers,
      'r': rating,
      'i': image,
      's': stock,
      'a': delete,
    };
  }

  factory ProductDataCache.createEmpty(String id){
    return ProductDataCache(
      id: id,
      timeModify: DateTime.now(),
      name: [],
      visible: true,
      price: 0,
      discPrice: 0,
      category: [],
      providers: [],
      rating: 0,
      image: "",
      stock: 0,
      delete: false
    );
  }

  factory ProductDataCache.fromJson(String id, Map<String, dynamic> data, {bool local = false}){
    List<StringData> _name = [];
    if (data['n'] != null)
      for (var element in List.from(data['n'])) {
        _name.add(StringData.fromJson(element));
      }
    List<String> _category = [];
    if (data['c'] != null)
      for (var element in List.from(data['c'])) {
        _category.add(element);
      }
    List<String> _providers = [];
    if (data['p'] != null)
      for (var element in List.from(data['p'])) {
        _providers.add(element);
      }
    return ProductDataCache(
      id: id,
      timeModify: !local ? (data["t"] != null) ? data["t"].toDate() : DateTime.now()
          : DateTime.parse(data["t"]),
      name: _name,
      visible: (data["v"] != null) ? data["v"] : true,
      price: (data["m"] != null) ? toDouble(data["m"].toString()) : 0.0,
      discPrice: (data["d"] != null) ? toDouble(data["d"].toString()) : 0.0,
      category: _category,
      providers: _providers,
      rating: (data["r"] != null) ? toDouble(data["r"].toString()) : 0.0,
      image: (data["i"] != null) ? data["i"] : "",
      stock: (data["s"] != null) ? toInt(data["s"].toString()) : 0,
      delete: (data["a"] != null) ? data["a"] : false,
    );
  }

  compareToVisible(ProductDataCache b){
    if (visible && !b.visible)
      return 1;
    if (!visible && b.visible)
      return -1;
    return 0;
  }

}

bool ifProviderHaveArticles(String providerId){
  if (providerId.isEmpty)
    return false;
  for (var item in productDataCache)
    if (item.providers.contains(providerId))
      return true;
  return false;
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

double articlesGetMinPrice(){
  double _min = double.infinity;
  for (var item in productDataCache) {
    var _price = item.price;
    if (item.discPrice != 0)
      _price = item.discPrice;
    if (_price < _min)
      _min = _price;
  }
  if (_min == double.infinity)
    _min = 0;
  return _min;
}

double articlesGetMaxPrice(){
  double _max = 0;
  for (var item in productDataCache) {
    var _price = item.price;
    if (item.discPrice != 0)
      _price = item.discPrice;
    if (_price > _max)
      _max = _price;
  }
  return _max;
}

double? articleGetTotalPrice(){
  double _price = currentArticle.discPriceProduct;
  bool _priceSelected = true;

  if (currentArticle.group.isEmpty){
    if (_price != 0)
      return _price;
    return currentArticle.priceProduct;
  }

  PriceData? _select;
  for (var _group in currentArticle.group){
    for (var _variant in _group.price)
      if (_variant.selected) {
        _select = _variant;
        if (_variant.priceUnit == "+")
          _price += _variant.price;
        else
          _price -= _variant.price;
      }
    if (_select == null)
      _priceSelected = false;
  }
  if (!_priceSelected)
    return null;
  return _price;
}


int articleGetInStock(){
  int _total = currentArticle.stock;
  int _current = currentArticle.stock;
  PriceData? _select;
  bool _priceSelected = true;
  for (var _group in currentArticle.group){
    for (var _variant in _group.price) {
      _total += _variant.stock;
      if (_variant.selected) {
        _select = _variant;
        _current += _variant.stock;
      }
    }
    if (_select == null)
      _priceSelected = false;
  }
  if (!_priceSelected)
    return _total;

  if (currentArticle.countProduct >= _current)
    currentArticle.countProduct = _current;
  return _current;
}

String articleGetFullName(){
  String name = getTextByLocale(currentArticle.name, locale);
  for (var _group in currentArticle.group){
    for (var _variant in _group.price){
      if (_variant.selected)
        name += " : ${getTextByLocale(_variant.name, locale)}";
    }
  }
  return name;
}

int getProviderProductsCount(String providerId){
  var _count = 0;
  for (var item in productDataCache){
    if (item.providers.isEmpty)
      continue;
    if (!item.providers.contains(providerId))
      continue;
    _count++;
  }
  return _count;
}

import 'package:flutter/material.dart';
import '../../abg_utils.dart';

class ProductData {
  String id;
  bool delete;
  DateTime timeModify; // время воследней модификации (для listener)
  List<StringData> name;
  List<StringData> descTitle;
  List<StringData> desc;
  double tax;
  double taxAdmin;
  bool visible;
  List<PriceData> price;
  List<ImageData> gallery;
  Duration duration = Duration();
  List<String> category;
  List<String> providers; // Id
  //
  bool select = false;
  final dataKey = GlobalKey();
  List<String> assetsCategory;
  List<String> assetsProvider;
  List<String> assetsGallery;
  //
  int rating1;
  int rating2;
  int rating3;
  int rating4;
  int rating5;
  int countRating = 0;
  double rating = 0;
  int favoritesCount;
  //
  List<AddonData> addon;
  bool unavailable;
  // для магазина
  double priceProduct;
  double discPriceProduct;
  String unit;
  List<GroupData> group;
  bool thisIsArticle;
  int countProduct;
  //
  String video;
  String videoType; // mp4 youtube
  int stock;

  ProductData(this.id, this.name, {this.visible = true, required this.desc,
    required this.gallery, required this.descTitle, required this.price,
    required this.duration, required this.category, required this.providers, this.tax = 0,
    this.assetsCategory = const [], this.assetsProvider = const [], this.assetsGallery = const [],
    this.rating1 = 0, this.rating2 = 0, this.rating3 = 0, this.rating4 = 0, this.rating5 = 0,
    this.countRating = 0, this.rating = 0, this.taxAdmin = 0, this.favoritesCount = 0, required this.addon,
    this.unavailable = false, required this.timeModify, this.delete = false,
    this.priceProduct = 0, this.discPriceProduct = 0, required this.group,
    this.unit = "pcs", this.thisIsArticle = false, this.countProduct = 0,
    this.video = "", this.videoType = "", this.stock = 0,
  });

  factory ProductData.clone(ProductData _source){
    List<AddonData> _addon = [];
    for (var item in _source.addon)
      _addon.add(AddonData.clone(item));

    return ProductData(_source.id, _source.name,
      visible: _source.visible,
      desc: _source.desc,
      gallery: _source.gallery,
      descTitle: _source.descTitle,
      price: _source.price,
      duration: _source.duration,
      category: _source.category,
      providers: _source.providers,
      tax: _source.tax,
      assetsCategory: const [],
      assetsProvider: const [],
      assetsGallery: const [],
      rating1: _source.rating1,
      rating2: _source.rating2,
      rating3: _source.rating3,
      rating4: _source.rating4,
      rating5: _source.rating5,
      countRating: _source.countRating,
      rating: _source.rating,
      taxAdmin: _source.taxAdmin,
      favoritesCount: _source.favoritesCount,
      addon: _addon,
      unavailable: _source.unavailable,
      timeModify: _source.timeModify,
      delete: _source.delete,
      priceProduct: _source.priceProduct,
      discPriceProduct: _source.discPriceProduct,
      group: _source.group,
      unit: _source.unit,
      thisIsArticle: _source.thisIsArticle,
      countProduct: _source.countProduct,
      video: _source.video,
      videoType: _source.videoType,
      stock: _source.stock,
    );
  }

  factory ProductData.createEmpty(){
    return ProductData("", [], gallery: [], price: [], desc: [], descTitle: [], timeModify: DateTime.now(),
        duration: Duration(), category: [], providers: [], addon: [], group: []);
  }

  Map<String, dynamic> toJson({bool local = false}) => {
    'id': id,
    'delete': delete,
    'timeModify': local ? timeModify.toIso8601String() : DateTime.now().toUtc(),
    'name': name.map((i) => i.toJson()).toList(),
    'tax': tax,
    'descTitle': descTitle.map((i) => i.toJson()).toList(),
    'desc': desc.map((i) => i.toJson()).toList(),
    'visible': visible,
    'price': price.map((i) => i.toJson()).toList(),
    'gallery': gallery.map((i) => i.toJson()).toList(),
    'duration': duration.inMilliseconds,
    'category' : category,
    'providers': providers,
    'rating1': rating1,
    'rating2': rating2,
    'rating3': rating3,
    'rating4': rating4,
    'rating5': rating5,
    'taxAdmin': taxAdmin,
    'favoritesCount' : favoritesCount,
    'addon': addon.map((i) => i.toJson()).toList(),
    'unavailable': unavailable,
    'priceProduct': priceProduct,
    'discPriceProduct': discPriceProduct,
    'group': group.map((i) => i.toJson()).toList(),
    'unit': unit,
    'thisIsArticle': thisIsArticle,
    'countProduct': countProduct,
    'video': video,
    'videoType': videoType,
    'stock': stock,
  };

  factory ProductData.fromJson(String id, Map<String, dynamic> data, {bool local = false}){
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    List<StringData> _descTitle = [];
    if (data['descTitle'] != null)
      for (var element in List.from(data['descTitle'])) {
        _descTitle.add(StringData.fromJson(element));
      }
    List<StringData> _desc = [];
    if (data['desc'] != null)
      for (var element in List.from(data['desc'])) {
        _desc.add(StringData.fromJson(element));
      }
    List<PriceData> _price = [];
    if (data['price'] != null)
      for (var element in List.from(data['price'])) {
        _price.add(PriceData.fromJson(element));
      }
    List<ImageData> _gallery = [];
    if (data['gallery'] != null)
      for (var element in List.from(data['gallery'])) {
        _gallery.add(ImageData.fromJson(element));
      }
    List<String> _category = [];
    if (data['category'] != null)
      for (var element in List.from(data['category'])) {
        _category.add(element);
      }
    List<String> _providers = [];
    if (data['providers'] != null)
      for (var element in List.from(data['providers'])) {
        _providers.add(element);
      }
    List<AddonData> _addon = [];
    if (data['addon'] != null)
      for (var element in List.from(data['addon'])) {
        _addon.add(AddonData.fromJson(element));
      }
    List<GroupData> _group = [];
    if (data['group'] != null)
      for (var element in List.from(data['group'])) {
        _group.add(GroupData.fromJson(element));
      }
    var rating1 = (data["rating1"] != null) ? toInt(data["rating1"].toString()) : 0;
    var rating2 = (data["rating2"] != null) ? toInt(data["rating2"].toString()) : 0;
    var rating3 = (data["rating3"] != null) ? toInt(data["rating3"].toString()) : 0;
    var rating4 = (data["rating4"] != null) ? toInt(data["rating4"].toString()) : 0;
    var rating5 = (data["rating5"] != null) ? toInt(data["rating5"].toString()) : 0;
    var _countRating = rating1+rating2+rating3+rating4+rating5;
    double _rating = 0;
    if (_countRating != 0)
      _rating = (rating1*1 + rating2*2 + rating3*3 + rating4*4 + rating5*5)/_countRating;

    var _favoritesCount = (data["favoritesCount"] != null) ? toInt(data["favoritesCount"].toString()) : 0;
    if (_favoritesCount < 0)
      _favoritesCount = 0;

    return ProductData(
      id,
      _name,
      delete: (data["delete"] != null) ? data["delete"] : false,
      timeModify: !local ? (data["timeModify"] != null) ? data["timeModify"].toDate() : DateTime.now()
          : DateTime.parse(data["timeModify"]),
      tax: (data["tax"] != null) ? toDouble(data["tax"].toString()) : 0.0,
      descTitle: _descTitle,
      desc: _desc,
      visible: (data["visible"] != null) ? data["visible"] : true,
      price: _price,
      gallery: _gallery,
      duration: (data["duration"] != null) ? Duration(milliseconds : data["duration"]) : Duration(),
      category: _category,
      providers: _providers,
      rating1: rating1,
      rating2: rating2,
      rating3: rating3,
      rating4: rating4,
      rating5: rating5,
      countRating: _countRating,
      rating: _rating,
      taxAdmin: (data["taxAdmin"] != null) ? toDouble(data["taxAdmin"].toString()) : 0.0,
      favoritesCount: _favoritesCount,
      addon: _addon,
      unavailable: (data["unavailable"] != null) ? data["unavailable"] : false,
      priceProduct: (data["priceProduct"] != null) ? toDouble(data["priceProduct"].toString()) : 0.0,
      discPriceProduct: (data["discPriceProduct"] != null) ? toDouble(data["discPriceProduct"].toString()) : 0.0,
      group: _group,
      unit: (data["unit"] != null) ? data["unit"] : "pcs",
      thisIsArticle: (data["thisIsArticle"] != null) ? data["thisIsArticle"] : false,
      countProduct: (data["countProduct"] != null) ? toInt(data["countProduct"].toString()) : 0,
      video: (data["video"] != null) ? data["video"] : "",
      videoType: (data["videoType"] != null) ? data["videoType"] : "",
      stock: (data["stock"] != null) ? toInt(data["stock"].toString()) : 0,
    );
  }

  //
  //
  //
  double getMinPrice(){
    double _min = double.maxFinite;
    for (var item in price) {
      if (item.discPrice == 0) {
        if (_min > item.price)
          _min = item.price;
      }else {
        if (_min > item.discPrice)
          _min = item.discPrice;
      }
    }
    if (_min == double.maxFinite)
      return _min;
    return _min;
  }

  double getRating(){
    var _count = rating1+rating2+rating3+rating4+rating5;
    double _rating = 0;
    if (_count != 0)
      _rating = (rating1*1 + rating2*2 + rating3*3 + rating4*4 + rating5*5)/_count;
    return _rating;
  }

  compareToVisible(ProductData b){
    if (visible && !b.visible)
      return 1;
    if (!visible && b.visible)
      return -1;
    return 0;
  }
}

class GroupData{
  String id;
  List<StringData> name;
  List<PriceData> price;

  GroupData({required this.name, required this.id, required this.price});

  factory GroupData.createEmpty(){
    return GroupData(id: "", name: [], price: []);
  }

  factory GroupData.clone(GroupData source){
    List<PriceData> _price = [];
    for (var item in source.price)
      _price.add(PriceData.clone(item));

    return GroupData(
        id: source.id,
        name: source.name,
        price: _price,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name.map((i) => i.toJson()).toList(),
    'price': price.map((i) => i.toJson()).toList(),
  };

  factory GroupData.fromJson(Map<String, dynamic> data){
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    List<PriceData> _price = [];
    if (data['price'] != null)
      for (var element in List.from(data['price'])) {
        _price.add(PriceData.fromJson(element));
      }
    return GroupData(
      id: (data["id"] != null) ? data["id"] : "",
      name: _name,
      price: _price,
    );
  }
}
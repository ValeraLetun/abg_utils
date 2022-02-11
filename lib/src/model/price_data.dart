

import '../../abg_utils.dart';

class PriceData{
  List<StringData> name;
  double price;
  double discPrice;
  String priceUnit; // "hourly" or "fixed"
  ImageData image;
  bool selected;
  int stock;
  PriceData(this.name, this.price, this.discPrice, this.priceUnit, this.image, {this.selected = false, this.stock = 0,});

  factory PriceData.createEmpty(){
    return PriceData([], 0, 0, "hourly", ImageData());
  }

  factory PriceData.clone(PriceData source){
    return PriceData(
        source.name, source.price, source.discPrice, source.priceUnit, source.image,
      selected: source.selected, stock: source.stock
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name.map((i) => i.toJson()).toList(),
    'price': price,
    'discPrice': discPrice,
    'priceUnit': priceUnit,
    'image': image.toJson(),
    'stock': stock,
    'selected': selected,
  };

  factory PriceData.fromJson(Map<String, dynamic> data){
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    var _image = ImageData();
    if (data['image'] != null)
      _image = ImageData.fromJson(data['image']);
    return PriceData(
      _name,
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0.0,
      (data["discPrice"] != null) ? toDouble(data["discPrice"].toString()) : 0.0,
      (data["priceUnit"] != null) ? data["priceUnit"] : "",
      _image,
      stock: (data["stock"] != null) ? toInt(data["stock"].toString()) : 0,
      selected: data["selected"] ?? false,
    );
  }

  double getPrice(){
    return discPrice != 0 ? discPrice : price;
  }

  // String getPriceString(BuildContext context){
  //   return Provider.of<MainModel>(context,listen:false).getPriceString(getPrice());
  // }
}


/* site
class PriceData{
  List<StringData> name;
  double price;
  double discPrice;
  String priceUnit; // "hourly" or "fixed"
  ImageData image;
  bool selected;
  PriceData(this.name, this.price, this.discPrice, this.priceUnit, this.image, {this.selected = false});

  factory PriceData.createEmpty(){
    return PriceData([], 0, 0, "hourly", ImageData());
  }

  Map<String, dynamic> toJson() => {
    'name': name.map((i) => i.toJson()).toList(),
    'price': price,
    'discPrice': discPrice,
    'priceUnit': priceUnit,
    'image': image.toJson(),
  };

  factory PriceData.fromJson(Map<String, dynamic> data){
    List<StringData> _name = [];
    if (data['name'] != null)
      List.from(data['name']).forEach((element){
        _name.add(StringData.fromJson(element));
      });
    var _image = ImageData();
    if (data['image'] != null)
      _image = ImageData.fromJson(data['image']);
    return PriceData(
      _name,
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0,
      (data["discPrice"] != null) ? toDouble(data["discPrice"].toString()) : 0,
      (data["priceUnit"] != null) ? data["priceUnit"] : "",
      _image,
    );
  }

  double getPrice(){
    return discPrice != 0 ? discPrice : price;
  }

  String getPriceString(MainModel _mainModel){
    return _mainModel.localAppSettings.
    getPriceString(getPrice());
  }
}


 */
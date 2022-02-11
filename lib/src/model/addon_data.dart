import '../../abg_utils.dart';

class AddonData{
  String id;
  List<StringData> name;
  double price;

  int needCount = 1;

  bool selected;
  AddonData(this.id, this.name, this.price, {this.selected = true, this.needCount = 1});

  factory AddonData.createEmpty(){
    return AddonData("", [], 0);
  }

  factory AddonData.clone(AddonData _source){
    return AddonData(_source.id, _source.name, _source.price,
      selected: _source.selected,
      needCount: _source.needCount);
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name.map((i) => i.toJson()).toList(),
    'price': price,
    'needCount': needCount,
  };

  factory AddonData.fromJson(Map<String, dynamic> data){
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    return AddonData(
      (data["id"] != null) ? data["id"] : "",
      _name,
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0.0,
      needCount: data["needCount"] != null ? toInt(data["needCount"].toString()) : 1,
    );
  }
}

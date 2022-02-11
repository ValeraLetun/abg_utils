import 'package:abg_utils/abg_utils.dart';

double filterGetMinPrice(List<ProductData> services){
  double _min = double.infinity;
  for (var item in services) {
    var _price = getMinAmountInProduct(item.price);
    if (_price < _min)
      _min = _price;
  }
  if (_min == double.infinity)
    _min = 0;
  return _min;
}

double filterGetMaxPrice(List<ProductData> services){
  double _max = 0;
  for (var item in services) {
    var _price = getMinAmountInProduct(item.price);
    if (_price > _max)
      _max = _price;
  }
  return _max;
}



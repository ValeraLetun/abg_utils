import '../../abg_utils.dart';

double getDistanceByProviderId(String _providerId){
  var _provider = getProviderById(_providerId);
  if (_provider != null){
    double d = 0;
    if (distanceUnit == "km")
      d = _provider.distanceToUser/1000;
    else
      d = _provider.distanceToUser/1609.32;
    if (d != 0){
      if (d > 10)
        return d;
      else
        return d;
    }
  }
  return double.infinity;
}

String getStringDistanceByProviderId(String _providerId){
  var d = getDistanceByProviderId(_providerId);
  if (d != double.infinity){
    if (d > 10)
      return d.toStringAsFixed(0) + distanceUnit;
    else
      return d.toStringAsFixed(3) + distanceUnit;
  }
  return "";
}

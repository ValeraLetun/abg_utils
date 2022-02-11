import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as pu;

import '../../abg_utils.dart';

LatLng getCenter(LatLngBounds bounds) {
  LatLng center = LatLng(
    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
    (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
  );
  return center;
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  bool _first = true;
  double x0 = 0;
  double x1 = 0;
  double y0 = 0;
  double y1 = 0;
  for (LatLng latLng in list) {
    if (_first) {
      _first = false;
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
}

bool ifUserAddressInProviderRoute(String provider){ // parent.currentService.providers[0]
  AddressData _address = getCurrentAddress();
  ProviderData? _provider = getProviderById(provider);

  if (_provider == null || _address.id.isEmpty)
    return false;
  if (_provider.route.isEmpty)
    return false;

  List<pu.LatLng> _route = [];
  for (var item in _provider.route)
    _route.add(pu.LatLng(item.latitude, item.longitude));

  return pu.PolygonUtil.containsLocation(pu.LatLng(_address.lat, _address.lng), _route, false);
}
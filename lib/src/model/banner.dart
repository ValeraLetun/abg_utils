
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../abg_utils.dart';

List<BannerData> banners = [];

Future<String?> loadBanners() async{
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("banner")
        .where("visible", isEqualTo: true).get();
    banners = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      // dprint("Banner $_data");
      var t = BannerData.fromJson(result.id, _data);
      banners.add(t);
    }
    addStat("banner", querySnapshot.docs.length);
  }catch(ex){
    return "loadBanners " + ex.toString();
  }
  return null;
}

class BannerData {
  String id;
  String name;
  String type;
  String open;
  bool visible;
  String localImage;
  String serverImage;

  BannerData({this.id = "", this.name = "",
    this.type = "service", this.open = "", this.visible = true,
    this.localImage = "", this.serverImage = ""
  });

  factory BannerData.createEmpty(){
    return BannerData();
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'open': open,
    'visible': visible,
    'localImage' : localImage,
    'serverImage' : serverImage,
  };

  factory BannerData.fromJson(String id, Map<String, dynamic> data){
    return BannerData(
      id: id,
      name: (data["name"] != null) ? data["name"] : "",
      type: (data["type"] != null) ? data["type"] : "",
      open: (data["open"] != null) ? data["open"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      localImage: (data["localImage"] != null) ? data["localImage"] : "",
      serverImage: (data["serverImage"] != null) ? data["serverImage"] : "",
    );
  }
}

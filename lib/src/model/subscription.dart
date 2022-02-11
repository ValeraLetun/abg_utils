import 'dart:ui';

import '../../abg_utils.dart';

List<SubscriptionData> subscriptions = [];
SubscriptionData currentSubscription = SubscriptionData.createEmpty();

subscriptionSetText(String val, String locale){
  for (var item in currentSubscription.text)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentSubscription.text.add(StringData(code: locale, text: val));
}

subscriptionSetText2(String val, String locale){
  for (var item in currentSubscription.text2)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentSubscription.text2.add(StringData(code: locale, text: val));
}

subscriptionSetDesc(String val, String locale){
  for (var item in currentSubscription.desc)
    if (item.code == locale) {
      item.text = val;
      return;
    }
  currentSubscription.desc.add(StringData(code: locale, text: val));
}

Future<String?> loadSubscriptions() async{
  try{
    subscriptions = await dbGetDocument("settings", "subscriptions");
  }catch(ex){
    return "loadSubscriptions " + ex.toString();
  }
  return null;
}

Future<String?> deleteSubscription(SubscriptionData item) async {
  subscriptions.remove(item);
  return saveSubscriptions();
}

Future<String?> saveSubscriptions() async{
  try{
    await dbSetDocumentInTable("settings", "subscriptions", {
      "subscriptions" : subscriptions.map((i) => i.toJson()).toList(),
    });
  }catch(ex){
    return "saveSubscriptions " + ex.toString();
  }
  return null;
}

class SubscriptionData{
  String id;
  bool visible;
  List<StringData> text;
  List<StringData> text2;
  double price;
  Color color;
  List<StringData> desc;
  bool defaultItem;
  int days;
  //
  double scale = 1;

  SubscriptionData({this.id = "", required this.text, this.price = 0, required this.desc,
    this.defaultItem = false, this.visible = true,
    this.color = const Color(0xfff7a062), required this.text2, this.days = 0
  });

  factory SubscriptionData.createEmpty(){
    return SubscriptionData(text: [], desc: [], text2: []);
  }

  Map<String, dynamic> toJson() => {
    "text": text.map((i) => i.toJson()).toList(),
    "text2": text2.map((i) => i.toJson()).toList(),
    "price": price,
    'color': color.value.toString(),
    'desc': desc.map((i) => i.toJson()).toList(),
    'defaultItem': defaultItem,
    'visible': visible,
    'days': days,
  };

  factory SubscriptionData.fromJson(String _id, Map<String, dynamic> data){
    List<StringData> _text = [];
    if (data['text'] != null)
      for (var element in List.from(data['text'])) {
        _text.add(StringData.fromJson(element));
      }
    List<StringData> _text2 = [];
    if (data['text2'] != null)
      for (var element in List.from(data['text2'])) {
        _text2.add(StringData.fromJson(element));
      }
    List<StringData> _desc = [];
    if (data['desc'] != null)
      for (var element in List.from(data['desc'])) {
        _desc.add(StringData.fromJson(element));
      }
    return SubscriptionData(
      id : _id,
      visible: (data["visible"] != null) ? data["visible"] : true,
      text: _text,
      text2: _text2,
      price: data["price"] != null ? toDouble(data["price"].toString()) : 0.0,
      color: (data["color"] != null) ? toColor(data["color"]) : Color(0xfff7a062),
      desc: _desc,
      defaultItem: (data["defaultItem"] != null) ? data["defaultItem"] : "",
      days: (data["days"] != null) ? toInt(data["days"].toString()) : 0,
    );
  }
}

DateTime getSubscriptionExpiredDate(){
  if (currentProvider.subscriptions.isNotEmpty){
    DateTime date = currentProvider.subscriptions.first.timeStart;
    // date = date.add(Duration(days: currentProvider.freeTrialDays));
    for (var item in currentProvider.subscriptions)
      date = date.add(Duration(days: item.days));
    return date.toLocal();
  }
  return DateTime.now();
}

String getSubscriptionExpiredDateString(){
  return appSettings.getDateTimeString(getSubscriptionExpiredDate());
}

bool isSubscriptionDateExpired(){
  DateTime expire = getSubscriptionExpiredDate();
  return expire.isBefore(DateTime.now());
}

subscriptionFinish(String paymentMethod) async {
  // if (currentProvider.subscriptions.isEmpty)
    // currentProvider.freeTrialDays = appSettings.subscriptionsFreeTrialDays;
  currentProvider.subscriptions.add(
      ProviderSubscriptionsData(DateTime.now().toUtc(), currentSubscription.price, paymentMethod, currentSubscription.days));
  await saveProviderFromAdmin();
}


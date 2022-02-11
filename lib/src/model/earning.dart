import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<PayoutData> payout = [];

Future<String?> loadPayout() async{
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("payout").get();
    payout = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      // print("Payout $_data");
      var t = PayoutData.fromJson(result.id, _data);
      payout.add(t);
      payoutsSort("timeDesc");
    }
    //addStat("(admin) payout", payout.length);
  }catch(ex){
    return "loadPayout " + ex.toString();
  }
  return null;
}

Future<String?> loadPayoutForProvider(String providerId) async{
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("payout")
        .where("providerId", isEqualTo: providerId).get();
    payout = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      // print("Payout $_data");
      var t = PayoutData.fromJson(result.id, _data);
      payout.add(t);
      payoutsSort("timeDesc");
    }
    //addStat("(admin) payout", payout.length);
  }catch(ex){
    return "loadPayout " + ex.toString();
  }
  return null;
}


Future<String?> loadPayoutProvider(String providerId) async{
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("payout").where("providerId", isEqualTo: providerId).get();
    payout = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      // print("Payout $_data");
      var t = PayoutData.fromJson(result.id, _data);
      payout.add(t);
      payoutsSort("timeDesc");
    }
    addStat("(admin) payout", payout.length);
  }catch(ex){
    return "loadPayoutProvider " + ex.toString();
  }
  return null;
}

List<EarningData> getEarningData(ProviderData item){
  List<EarningData> items = [];
  EarningData data = EarningData();
  ordersDataCache.sort((a, b) => b.time.compareTo(a.time));
  //
  DateTime _now = DateTime.now();
  DateTime _firstDayOfWeek = _now.subtract(Duration(days: _now.weekday));
  DateTime _firstDayOfMonth = _now.subtract(Duration(days: _now.day));

  for (var booking in ordersDataCache)
    if (booking.finished && booking.providerId == item.id){
      data.count++;
      //
      EarningData item = EarningData();
      item.id = booking.id;
      item.time = booking.time;
      item.name = booking.name;
      item.customerName = booking.customerName;
      //
      // subtotal = price - coupon + addon
      // total = subtotal + subtotal*tax
      //
      //
      //
      item.total = booking.total;
      data.total += item.total;
      //
      if (!appSettings.enableSubscriptions){
        // если включены подписки, то администратору ничего не положено (оставляем 0)
        item.admin = booking.toAdmin;
        data.admin += item.admin;
      }

      //
      item.provider = booking.subtotal - item.admin;
      data.provider += item.provider;
      //
      item.tax = booking.tax; //item.total*booking.tax/100;
      data.tax += item.tax;
      // print("booking.id=${booking.id} booking.providerId =${booking.providerId} _total=$_total _toAdmin=$_toAdmin provider=${data.total - _toAdmin} data.total=${data.total} data.count=${data.count}");
      //
      if (item.time.year == _now.year && item.time.month == _now.month && item.time.day == _now.day){
        data.todayEarning += booking.total;
        data.todayBooking++;
      }
      if (item.time.millisecondsSinceEpoch > _firstDayOfWeek.millisecondsSinceEpoch){ // this week
        data.thisWeekEarning += booking.total;
        data.thisWeekBooking++;
      }
      if (item.time.millisecondsSinceEpoch > _firstDayOfMonth.millisecondsSinceEpoch){ // this month
        data.thisMonthEarning += booking.total;
      }
      data.totalBooking++;
      //
      items.add(item);
    }
  data.payout = data.provider;
  for (var item2 in payout)
    if (item2.providerId == item.id)
      data.payout -= item2.total;
  if (data.payout < 0)
    data.payout = 0;

  items.sort((a, b) => b.time.compareTo(a.time));

  items.add(data);
  return items;
}

class EarningData {
  int count = 0;
  String name = "";
  String customerName = "";
  String id = "";
  double total = 0; // walletBalans
  double provider = 0;
  double admin = 0;
  double tax = 0;
  double payout = 0; // walletTotalToProviderCache
  DateTime time = DateTime.now();
  //
  double todayEarning = 0;
  double thisWeekEarning = 0;
  double thisMonthEarning = 0;
  int todayBooking = 0;
  int thisWeekBooking = 0;
  int totalBooking = 0;
}


class PayoutData {
  String id;
  String providerId;
  List<StringData> providerName;
  double total;
  String comment;
  DateTime time;
  PayoutData({this.id = "", this.providerId = "", required this.providerName,
    this.total = 0, this.comment = "", required this.time
  });

  factory PayoutData.fromJson(String id, Map<String, dynamic> data){
    var _time = DateTime.now();
    if (data["time"] != null)
      if (data["time"] != "")
        _time = data["time"].toDate().toLocal();
    List<StringData> _provider = [];
    if (data['providerName'] != null)
      for (var element in List.from(data['providerName'])) {
        _provider.add(StringData.fromJson(element));
      }
    return PayoutData(
        id: id,
        providerId: (data["providerId"] != null) ? data["providerId"] : "",
        providerName: _provider,
        total: (data["total"] != null) ? toDouble(data["total"].toString()) : 0,
        comment: (data["comment"] != null) ? data["comment"] : "",
        time: _time
    );
  }

  int compareToTotalDesc(PayoutData b){
    return b.total.compareTo(total);
  }

  int compareToTotalAsc(PayoutData b){
    var t = b.total.compareTo(total);
    if (t == 1) return -1;
    if (t == -1) return 1;
    return 0;
  }

  int compareToNameDesc(PayoutData b){
    return getTextByLocale(b.providerName, locale).compareTo(getTextByLocale(providerName, locale));
  }

  int compareToNameAsc(PayoutData b){
    var t = getTextByLocale(b.providerName, locale).compareTo(getTextByLocale(providerName, locale));
    if (t == 1) return -1;
    if (t == -1) return 1;
    return 0;
  }

  int compareToTimeDesc(PayoutData b){
    return b.time.compareTo(time);
  }

  int compareToTimeAsc(PayoutData b){
    var t = b.time.compareTo(time);
    if (t == 1) return -1;
    if (t == -1) return 1;
    return 0;
  }
}

payoutsSort(String sort){
  if (sort == "timeDesc")
    payout.sort((a, b) => a.compareToTimeDesc(b));
  if (sort == "timeAsc")
    payout.sort((a, b) => a.compareToTimeAsc(b));
  if (sort == "nameAsc")
    payout.sort((a, b) => a.compareToNameAsc(b));
  if (sort == "nameDesc")
    payout.sort((a, b) => a.compareToNameDesc(b));
  if (sort == "totalAsc")
    payout.sort((a, b) => a.compareToTotalAsc(b));
  if (sort == "totalDesc")
    payout.sort((a, b) => a.compareToTotalDesc(b));
}
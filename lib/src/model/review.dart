import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../abg_utils.dart';

int reviewsRate = 0;
String reviewsRateString = "";
late DateTime _last;
List<ReviewsData> reviews = [];

Future<String?> loadReviewsForProviderScreen(String providerId) async{
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("reviews")
        .where("provider", isEqualTo: providerId).get(); //  parent.currentProvider.id
    reviewsRate = 0;
    reviewsRateString = "";
    _work(querySnapshot);
    if (reviews.isNotEmpty)
      _calculateReview();
  }catch(ex){
    return "model loadReviews " + ex.toString();
  }
  return null;
}

Future<String?> loadReviewsForServiceScreen(String serviceId) async{ // currentService.id
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("reviews")
        .where("service", isEqualTo: serviceId).get();
    _work(querySnapshot);
  }catch(ex){
    return "model loadReviews " + ex.toString();
  }
  return null;
}

_work(querySnapshot){
  reviews = [];
  for (var result in querySnapshot.docs) {
    var _data = result.data();
    // dprint("loadReviews $_data");
    var r = ReviewsData.fromJson(result.id, _data);
    if (!r.delete)
      reviews.add(r);
  }
  addStat("review", querySnapshot.docs.length);
  reviews.sort((a, b) => b.time.compareTo(a.time));
  reviews.sort((a, b) => b.timeModify.compareTo(a.timeModify));
}

Future<String?> initReviews() async{    // admin panel - all reviews
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("reviews").get();
    _work(querySnapshot);
    if (reviews.isEmpty)
      _last = DateTime.now();
    else
      _last = reviews[0].timeModify; //timeUtc;

    //
    FirebaseFirestore.instance.collection("reviews").where("timeModify", isGreaterThan: _last)
        .snapshots().listen((querySnapshot) async {
      for (var result in querySnapshot.docs) {
        var _data = result.data();
        // dprint("loadReviews $_data");
        var r = ReviewsData.fromJson(result.id, _data);
        if (!r.delete) {
          for (var item in reviews)
            if (item.id == r.id){
              reviews.remove(item);
              break;
            }
          reviews.add(r);
        }
      }
      addStat("review listen", querySnapshot.docs.length);
      reviews.sort((a, b) => b.time.compareTo(a.time));
      reviews.sort((a, b) => b.timeModify.compareTo(a.timeModify));
      redrawMainWindow();
    });
  }catch(ex){
    return "initReviews " + ex.toString();
  }
  return null;
}

Future<String?> deleteReview(ReviewsData item) async{
  try{
    await FirebaseFirestore.instance.collection("reviews").doc(item.id).set({
      "delete": true,
      "timeModify": DateTime.now().toUtc(),
    });
    await FirebaseFirestore.instance.collection("settings").doc("main")
        .set({"service_reviews": FieldValue.increment(-1)}, SetOptions(merge:true));
    await FirebaseFirestore.instance.collection("service").doc(item.serviceId).set({
      "rating${item.rating}": FieldValue.increment(-1),
      "timeModify": FieldValue.serverTimestamp(),
    }, SetOptions(merge:true));
    reviews.remove(item);
    appSettings.serviceReviews--;
  } catch (e) {
    return e.toString();
  }
  return null;
}

Future<String?> addReview(int rating, String text, List<Uint8List> images, OrderData jobInfo) async{  // addRating
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "addRating user == null";
  List<ImageData> _images = [];
  try{
    for (var item in images){
      var ret = await uploadImage("rating", item);
      if (ret != null)
        return ret;
      _images.add(ImageData(localFile: localFile, serverPath: serverPath));
    }
    //
    if (jobInfo.ver4){
      for (var item in jobInfo.products){
        if (item.thisIsArticle){
          dbSetDocumentInTable("article", item.id, {
            "timeModify": DateTime.now().toUtc(),
          });
          dbIncrementCounter("article", item.id, "rating$rating", 1);
        }else{
          dbSetDocumentInTable("service", item.id, {
            "timeModify": DateTime.now().toUtc(),
          });
          dbIncrementCounter("service", item.id, "rating$rating", 1);
        }
      }
    }else{
      await dbSetDocumentInTable("service", jobInfo.serviceId, {
        "timeModify": DateTime.now().toUtc(),
      });
      await dbIncrementCounter("service", jobInfo.serviceId, "rating$rating", 1);
      // await FirebaseFirestore.instance.collection("service").doc(jobInfo.serviceId).set({
      //   "rating$rating": FieldValue.increment(1),
      //   "timeModify": DateTime.now().toUtc(),
      // }, SetOptions(merge:true));
    }
    await dbAddDocumentInTable("reviews", {
      "rating": rating,
      "text": text,
      "images": _images.map((i) => i.toJson()).toList(),
      "user": user.uid,
      "service": jobInfo.serviceId,
      'serviceName': getTextByLocale(jobInfo.service, locale),
      "provider": jobInfo.providerId,
      "userName": userAccountData.userName,
      "userAvatar": userAccountData.userAvatar,
      'time': DateTime.now().toUtc(),
      "timeModify": DateTime.now().toUtc(),
    });
    // await FirebaseFirestore.instance.collection("reviews").add({
    //   "rating": rating,
    //   "text": text,
    //   "images": _images.map((i) => i.toJson()).toList(),
    //   "user": user.uid,
    //   "service": jobInfo.serviceId,
    //   'serviceName': getTextByLocale(jobInfo.service, locale),
    //   "provider": jobInfo.providerId,
    //   "userName": userAccountData.userName,
    //   "userAvatar": userAccountData.userAvatar,
    //   'time': FieldValue.serverTimestamp(),
    //   "timeModify": FieldValue.serverTimestamp(),
    // });
    await dbSetDocumentInTable("booking", jobInfo.id, {
      "rated": true,
      "timeModify": DateTime.now().toUtc(),
    });
    // await FirebaseFirestore.instance.collection("booking").doc(jobInfo.id).set({
    //   "rated": true,
    //   "timeModify": FieldValue.serverTimestamp(),
    // }, SetOptions(merge:true));
    await dbIncrementCounter("settings", "main", "service_reviews", 1);
    // await FirebaseFirestore.instance.collection("settings").doc("main")
    //     .set({"service_reviews": FieldValue.increment(1)}, SetOptions(merge:true));

    await bookingSaveInCache(jobInfo);
  } catch (e) {
    return "addReview " + e.toString();
  }
  jobInfo.rated = true;
  return null;
}

_calculateReview(){
  double rating = 0;
  for (var item in reviews)
    rating += item.rating;
  reviewsRate = rating~/reviews.length;
  reviewsRateString = (rating/reviews.length).toStringAsFixed(1);
}

class ReviewsData{
  final String id;
  final int rating;
  final String text;
  List<ImageData> images = [];
  final String user;
  final String serviceId;
  final String serviceName;
  final String providerId;
  final String userName;
  final String userAvatar;
  final DateTime time;
  final bool delete;
  final DateTime timeModify;

  ReviewsData({this.id = "", this.rating = 0, this.text = "", required this.images, this.user = "",
    this.serviceId = "", this.serviceName = "", this.providerId = "", this.userName = "",
    this.userAvatar = "", required this.time, this.delete = false, required this.timeModify,});

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "text": text,
    "images": images.map((i) => i.toJson()).toList(),
    "user": user,
    "service": serviceId,
    'serviceName': serviceName,
    "provider": providerId,
    "userName": userName,
    "userAvatar": userAvatar,
    "time" : time,
    "delete" : delete,
    'timeModify': DateTime.now().toUtc(),
  };

  factory ReviewsData.fromJson(String _id, Map<String, dynamic> data){
    List<ImageData> _images = [];
    if (data['images'] != null)
      for (var element in List.from(data['images'])) {
        _images.add(ImageData(serverPath: element["serverPath"], localFile: element["localFile"]));
      }
    //
    var _time = (data["time"] != null) ? data["time"].toDate().toLocal() : DateTime.now();
    return ReviewsData(
      id : _id,
      rating: (data["rating"] != null) ? toInt(data["rating"].toString()) : 0,
      text: (data["text"] != null) ? data["text"] : "",
      images: _images,
      user: (data["user"] != null) ? data["user"] : "",
      serviceId: (data["service"] != null) ? data["service"] : "",
      serviceName: (data["serviceName"] != null) ? data["serviceName"] : "",
      providerId: (data["provider"] != null) ? data["provider"] : "",
      userName: (data["userName"] != null) ? data["userName"] : "",
      userAvatar: (data["userAvatar"] != null) ? data["userAvatar"] : "",
      time: _time,
      delete: (data["delete"] != null) ? data["delete"] : false,
      timeModify: (data["timeModify"] != null) ? data["timeModify"].toDate() : _time,
    );
  }
}


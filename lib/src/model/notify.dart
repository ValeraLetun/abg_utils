
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../abg_utils.dart';

List<MessageData> messages = [];

Future<String?> setEnableDisableNotify(bool _enable) async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "enableNotify": _enable,
    }, SetOptions(merge:true));
  }catch(ex){
    return "setEnableNotify " + ex.toString();
  }
  return null;
}

Future<String?> loadMessages() async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "not register";

    var querySnapshot = await FirebaseFirestore.instance.collection("messages").where('user', isEqualTo: user.uid).get();
    messages = [];
    int _unread = 0;
    for (var result in querySnapshot.docs) {
      // dprint("loadMessages");
      // dprint(result.data().toString());
      // dprint(result.data()["time"].toDate().toString());
      var t = MessageData.fromJson(result.id, result.data());
      // var t = MessageData(result.id, result.data()["title"], result.data()["body"], result.data()["time"].toDate().toLocal());
      messages.add(t);
      if (!t.read)
        _unread++;
    }

    messages.sort((a, b) => a.compareTo(b));
    if (currentScreen() == "notify")
      userNotificationsSetToRead();

    addStat("notify", querySnapshot.docs.length);

    setNumberOfUnreadMessages(_unread);

  }catch(ex){
    return "loadMessages " + ex.toString();
  }
  return null;
}

Future<String?> userNotificationsSetToRead() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "user == null";

  try{
    for (var item in messages) {
      if (!item.read) {
        await dbSetDocumentInTable("messages", item.id, {
        "read": true,
        });
        // FirebaseFirestore.instance.collection("messages").doc(result.id).set({
        //   "read": true,
        // }, SetOptions(merge: true)).then((value2) {});
        item.read = true;
      }
    }
  }catch(ex){
    return "userNotificationsSetToRead " + ex.toString();
  }
  return null;
  // FirebaseFirestore.instance.collection("messages").where('user', isEqualTo: user.uid).where('read', isEqualTo: false)
  //     .get().then((querySnapshot) {
  //   for (var result in querySnapshot.docs) {
  //     print(result.data());
  //     FirebaseFirestore.instance.collection("messages").doc(result.id).set({
  //       "read": true,
  //     }, SetOptions(merge:true)).then((value2) {});
  //   }
  // });
}

deleteMessage(MessageData item) async {
  try{
    await FirebaseFirestore.instance.collection("messages").doc(item.id).delete();
    messages.remove(item);
  }catch(ex){
    return "deleteMessage " + ex.toString();
  }
  return null;
}

class MessageData{
  MessageData({required this.id, required this.title, required this.body,
    required this.time, this.read = false});
  final String id;
  final String title;
  final String body;
  final DateTime time;
  bool read;

  factory MessageData.fromJson(String id, Map<String, dynamic> data, {bool local = false}){
    return MessageData(
      id: id,
      title: (data["title"] != null) ? data["title"] : "",
      body: (data["body"] != null) ? data["body"] : "",
      time: (data["time"] != null) ? data["time"].toDate().toLocal() : DateTime.now(),
      read: (data["read"] != null) ? data["read"] : false,
    );
  }

  int compareTo(MessageData b){
    if (time.isAfter(b.time))
      return -1;
    if (time.isBefore(b.time))
      return 1;
    return 0;
  }
}

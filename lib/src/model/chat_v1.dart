import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../abg_utils.dart';

List<UserData> users = [];
int chatCount = 0;
List<UserData> customersChat = [];
String chatId = "";
String chatRoomId = "";
Stream<QuerySnapshot>? chats;
String chatName = "";
int unread = 0;
String chatLogo = "";

setChatData(String _title, int _unread, String _logo, String _chatId){
  chatName = _title;
  unread = _unread;
  chatLogo = _logo;
  chatId = _chatId;
}

String getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}

Future<String?> loadUsersForChatInAdminPanel() async{
  if (users.isNotEmpty)
    return null;
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").get();
    users = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      //dprint("User $_data");
      var user = UserData.fromJson(result.id, _data);
      if (user.role.isNotEmpty)
        continue;
      if (user.name.isEmpty)
        continue;
      users.add(user);
    }
    addStat("chat list users", querySnapshot.docs.length);
  }catch(ex){
    return "loadUsersForChatInAdminPanel " + ex.toString();
  }
}

Future<String?> loadUsersForChatInCustomerApp() async{
  if (users.isNotEmpty)
    return null;
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").where("providerApp", isEqualTo: true).get();
    users = [];
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      //dprint("User $_data");
      var us = UserData.fromJson(result.id, _data);
      for (var item in providers)
        if (item.login == us.email)
          users.add(us);
    }
    addStat("chat list users", querySnapshot.docs.length);
  }catch(ex){
    return "loadUsersForChatInCustomerApp " + ex.toString();
  }

  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").where("role", isEqualTo: "owner").get();
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      //dprint("User $_data");
      users.add(UserData.fromJson(result.id, _data));
    }
    addStat("chat list users", querySnapshot.docs.length);
  }catch(ex){
    return "loadUsersForChatInCustomerApp " + ex.toString();
  }
  return null;
}

bool _ifInUsers(String id){
  for (var _user in users)
    if (_user.id == id)
      return true;
  return false;
}

Future<String?> loadUsersForChatInProviderApp() async{
  users = [];
  for (var item in bookings){
    if (!_ifInUsers(item.customerId)) {
      if (item.customer.isNotEmpty && item.customerId.isNotEmpty)
        users.add(UserData(id: item.customerId,
          name: item.customer,
          logoServerPath: item.customerAvatar,
          email: "",
          address: [],
        ));
    }
  }
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").where("role", isEqualTo: "owner").get();
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      //dprint("User $_data");
      var admin = UserData.fromJson(result.id, _data);
      if (!_ifInUsers(admin.id))
        users.add(admin);
    }
    addStat("chat list users", querySnapshot.docs.length);
  }catch(ex){
    return "loadUsersForChatInCustomerApp " + ex.toString();
  }
  return null;
}

Future<String?> getChatMessages(Function() _redraw, {String app = "customer", }) async {
  var _unread = 0;
  try{
    if (app == "provider"){
      customersChat = [];
      customersChat.addAll(users);
    }
    if (app == "customer")
      _createChatUsersList();
    if (app == "admin"){
      customersChat = [];
      customersChat.addAll(users);
    }

    var user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    //
    for (var item in customersChat) {
      var data = await FirebaseFirestore.instance.collection("chatRoom").doc(
          getChatRoomId(item.id, user.uid)).get();
      if (data.data() != null) {
        var _data = data.data()!;
        item.all = (_data['all'] != null) ? _data['all'] : 0;
        item.unread = (_data['unread_${user.uid}'] != null) ? _data['unread_${user.uid}'] : 0;
        item.lastMessage = (_data['last_message'] != null) ? _data['last_message'] : "";
        item.lastMessageTime = (_data['last_message_time'] != null) ? _data['last_message_time'].toDate().toLocal() : DateTime.now();
        _unread += item.unread;
      }
      if (!userAccountData.blockedUsers.contains(item.id))
        item.listen = FirebaseFirestore.instance.collection("chatRoom")
            .doc(getChatRoomId(item.id, user.uid)).snapshots().listen((querySnapshot) async {
          if (querySnapshot.data() != null) {
            var _data = querySnapshot.data()!;
            addStat("chat listen", _data.length);
            item.all = (_data['all'] != null) ? _data['all'] : 0;
            item.unread = (_data['unread_${user.uid}'] != null) ? _data['unread_${user.uid}'] : 0;
            item.lastMessage = (_data['last_message'] != null) ? _data['last_message'] : "";
            item.lastMessageTime = (_data['last_message_time'] != null) ? _data['last_message_time'].toDate().toLocal() : DateTime.now();
            if (chatId == item.id) {
              if (item.unread != 0) {
                await FirebaseFirestore.instance.collection("chatRoom").doc(getChatRoomId(item.id, user.uid)).set({
                  "unread_${user.uid}": 0,}, SetOptions(merge: true));
                await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
                  "unread_chat": FieldValue.increment(-item.unread),
                }, SetOptions(merge: true));
              }
            }
            customersChat.sort((a, b) => a.compareToAll(b));
            customersChat.sort((a, b) => a.compareToUnread(b));
            redrawMainWindow();
          }
        });
    }
    customersChat.sort((a, b) => a.compareToAll(b));
    customersChat.sort((a, b) => a.compareToUnread(b));
    if (_unread != chatCount)
      await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "unread_chat": _unread,
      }, SetOptions(merge: true));
  }catch(ex){
    return "getChatMessages " + ex.toString();
  }
  return null;
}

// _createChatUsersListAll(){
//   var user = FirebaseAuth.instance.currentUser;
//   if (user == null)
//     return;
//   customersChat = [];
//   for (var item in users){
//     if (item.id == user.uid)
//       continue;
//     if (item.providerApp){
//       for (var item2 in providers) {
//         if (item2.login == item.email) {
//           item.name = getTextByLocale(item2.name, locale);
//           item.logoServerPath = item2.logoServerPath;
//           break;
//         }
//       }
//     }
//     customersChat.add(item);
//   }
// }

_createChatUsersList(){
  var user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return;
  //dprint("_createChatUsersList");
  customersChat = [];
  for (var item in users){
    if (item.id == user.uid)
      continue;
    //dprint("${item.email} ${item.providerApp}");
    if (item.providerApp) {
      for (var item2 in providers) {
        if (item2.login == item.email) {
          item.name = getTextByLocale(item2.name, locale);
          item.logoServerPath = item2.logoServerPath;
          //dprint("add ${item.id} ${item.name}");
          customersChat.add(item);
          break;
        }
      }
      continue;
    }
    if (item.role.isNotEmpty) { // admin
      //dprint("add ${item.id} ${item.name}");
      customersChat.add(item);
    }
  }
  //dprint("_createChatUsersList -----------------------------------");
}

Future<String?> addMessage(String text,
    String stringChatMessage, /// strings.get(103)  /// "Chat message"
    ) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "User == null";

  try{

    await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add({
          "sendBy": user.uid,
          'read': false,
          "message": text,
          'time': FieldValue.serverTimestamp(),
        });

    await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set({
      "all": FieldValue.increment(1),
      "unread_$chatId": FieldValue.increment(1),
      "last_message": text,
      "last_message_time": FieldValue.serverTimestamp(),
      "last_message_from": user.uid,
    }, SetOptions(merge: true));

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(chatId).get();
    if (querySnapshot.exists){
      var data = querySnapshot.data();
      if (data != null){
        if (data["blockedUsers"] != null){
          List<String> _blockedUsers = [];
          for (dynamic key in data['blockedUsers']){
            _blockedUsers.add(key.toString());
          }
          if (!_blockedUsers.contains(user.uid)){
            await FirebaseFirestore.instance.collection("listusers").doc(chatId).set({
              "unread_chat": FieldValue.increment(1),
            }, SetOptions(merge: true));
            sendMessage(text, stringChatMessage, chatId, false, appSettings.cloudKey); /// "Chat message"
          }
        }
      }
    }
  }catch(ex){
    return "model addMessage " + ex.toString();
  }
  return null;
}

// ignore: cancel_subscriptions
StreamSubscription<DocumentSnapshot>? _listen;

disposeChatNotify(){
  if (_listen != null)
    _listen!.cancel();
}

listenChat(User? user, {Function()? playSound}){
  _listen = FirebaseFirestore.instance.collection("listusers")
      .doc(user!.uid).snapshots().listen((querySnapshot) {
    if (querySnapshot.data() != null) {
      var _data = querySnapshot.data()!;
      // dprint(_data["unread_chat"].toString());
      var _chatCount = _data["unread_chat"] != null ? toDouble(_data["unread_chat"].toString()).toInt() : 0;
      if (_chatCount != chatCount) {
        if (playSound != null)
          playSound()!;
        // sound
        //parent.playSound();
      }
      chatCount = _chatCount;
      if (chatCount < 0) {
        chatCount = 0;
        FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
          "unread_chat": chatCount,
        }, SetOptions(merge: true));
      }
      redrawMainWindow();
    }
  });
}

Future<String?> initChat(Function() _redraw) async {
  try{
    User? user = FirebaseAuth.instance.currentUser;
    List<String> users = [user!.uid, chatId];

    chatRoomId = getChatRoomId(user.uid, chatId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
    chats = null;
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom, SetOptions(merge:true));
    _getChats(_redraw);
  }catch(ex){
    return "initChat " + ex.toString();
  }
  _redraw();
  return null;
}

_getChats(Function() _redraw) async {
  try{
    chats = FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
    _redraw();
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set({
      "unread_${user!.uid}" : 0,
    }, SetOptions(merge:true));
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "unread_chat": FieldValue.increment(-unread),
    }, SetOptions(merge: true));
  }catch(ex){
    return "_getChats " + ex.toString();
  }
}



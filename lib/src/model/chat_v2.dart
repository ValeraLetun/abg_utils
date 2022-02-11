import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../abg_utils.dart';

int unreadMessagesInChat = 0;

// ignore: cancel_subscriptions
StreamSubscription<DocumentSnapshot>? chatListenMe;
// ignore: cancel_subscriptions
StreamSubscription<DocumentSnapshot>? chatListenCompanion;

Map<String, dynamic> _meData = {};
UserData userForChat = UserData.createEmpty();

int _getCountMyMessagesToUser(String id){
  for (var item in _meData.entries) {
    if (item.key == id) {
      return List.from(item.value).length;
    }
  }
  return 0;
}

initChatV2(Function() callback){
  var user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return;
  chatListenMe = FirebaseFirestore.instance.collection("chat")
      .doc(user.uid).snapshots().listen((querySnapshot) {
    if (querySnapshot.data() != null) {
      _meData = querySnapshot.data()!;
      int _chatCount = _meData["unread_chat"] != null ? toInt(_meData["unread_chat"].toString()) : 0;
      //print("listen main chat_chatCount=$_chatCount");
      for (var item in _meData.entries){
        //print("${item.key} ${item.value}");
        //
        if (item.key.startsWith("from_")){
          var _id = item.key.substring(5);
          for (var u in users){
            if (_id == u.id)
              u.lastMessage = item.value;
          }
        }
        if (item.key.startsWith("time_")){
          var _id = item.key.substring(5);
          if (item.value != null)
            for (var u in users){
              if (_id == u.id) {
                u.lastMessageTime = item.value.toDate().toLocal();
              }
            }
        }
        if (item.key.startsWith("count_")){
          var _id = item.key.substring(6);
          for (var u in users){
            if (_id == u.id)
              u.all = toInt(item.value.toString()) + _getCountMyMessagesToUser(_id);
          }
        }
        if (item.key.startsWith("unread_")){
          var _id = item.key.substring(7);
          for (var u in users){
            if (_id == u.id)
              u.unread = toInt(item.value.toString());
          }
        }
      }

      if (unreadMessagesInChat != _chatCount && _chatCount != 0)
        callback();
      // if (_chatCount != chatCount) {
      //   if (playSound != null)
      //     playSound()!;
      //   // sound
      //   //parent.playSound();
      // }

      unreadMessagesInChat = _chatCount;
      users.sort((a, b) => a.compareToAll(b));
      users.sort((a, b) => a.compareToUnread(b));
      redrawMainWindow();
    }
  });
}

Future<String?> clearChatCount() async{
  var user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";
  try{
    FirebaseFirestore.instance.collection("chat").doc(user.uid).set({
      "unread_chat": chatCount,
    }, SetOptions(merge: true));
  }catch(ex){
    return "clearChatCount " + ex.toString();
  }
  return null;
}

Future<String?> _clearUnreadMessagesCount() async{
  var user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";
  try{
    FirebaseFirestore.instance.collection("chat").doc(user.uid).set({
      'unread_${userForChat.id}' : 0,
    }, SetOptions(merge: true));
  }catch(ex){
    return "clearChatCount " + ex.toString();
  }
  return null;
}

setChat2Data(UserData _user){
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";
  userForChat = _user;
  _me = [];
  for (var item in _meData.entries){
    if (item.key == userForChat.id){
      for (var element in List.from(item.value)) {
        _me.add(ChatMessageData.fromJson(element, user.uid));
      }
    }
  }
}

Future<String?> initChatCompanion(Function() _redraw) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "not register";
  _clearUnreadMessagesCount();
  chatListenCompanion = FirebaseFirestore.instance.collection("chat")
      .doc(userForChat.id).snapshots().listen((querySnapshot) {
    if (querySnapshot.data() != null) {
      var _data = querySnapshot.data()!;
      dprint("listen companion");
      _companion = [];
      for (var item in _data.entries){
        if (item.key == user.uid){
          for (var element in List.from(item.value)) {
            _companion.add(ChatMessageData.fromJson(element, userForChat.id));
          }
        }
      }
      // chatCount = _chatCount;
      // if (chatCount < 0) {
      //   chatCount = 0;
      //   FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      //     "unread_chat": chatCount,
      //   }, SetOptions(merge: true));
      // }
      _redraw();
    }
  });
  return null;
}

class ChatMessageData{
  ChatMessageData(this.text, this.time, this.sendBy, this.read);
  final String text;
  final DateTime time;
  final bool read;
  final String sendBy;

  Map<String, dynamic> toJson() => {
    'text': text,
    'time': time,
    'read': read,
  };

  factory ChatMessageData.fromJson(Map<String, dynamic> data, String sendBy){
    return ChatMessageData(
      data["text"] ?? "",
      data["time"] != null ? data["time"].toDate() : DateTime.now(),
      sendBy,
      true,
    );
  }
}

List<ChatMessageData> getMessagesChat2(){
  List<ChatMessageData> _all = [];
  _all.addAll(_me);
  _all.addAll(_companion);
  _all.sort((a, b) => a.time.compareTo(b.time));
  return _all;
}

List<ChatMessageData> _me = [];
List<ChatMessageData> _companion = [];

Future<String?> sendChat2Message(String text,
    String stringChatMessage, /// strings.get(183) "Chat message"
  ) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "User == null";

  _me.add(ChatMessageData(text, DateTime.now().toUtc(), user.uid, false));

  try{
    await FirebaseFirestore.instance.collection("chat")
        .doc(userForChat.id).set({
      "from_${user.uid}": text,
      "time_${user.uid}": DateTime.now().toUtc(),
      'count_${user.uid}': _me.length,
      'unread_${user.uid}': FieldValue.increment(1),
      "unread_chat" : FieldValue.increment(1)
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection("chat")
        .doc(user.uid).set({
      "from_${userForChat.id}": text,
      "time_${userForChat.id}": FieldValue.serverTimestamp(),
      //
      "name": userAccountData.userName,
      userForChat.id: _me.map((i) => i.toJson()).toList(),
      "to_${userForChat.id}": text,
      "to_time_${userForChat.id}": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    sendMessage(text, stringChatMessage, userForChat.id, false, appSettings.cloudKey);

  }catch(ex){
    return "sendChat2Message " + ex.toString();
  }
  return null;
}
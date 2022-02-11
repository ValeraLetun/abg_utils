import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../../abg_utils.dart';

/*
    ondemand provider v2
      lib/model/account.dart
 */

Stream<String>? _tokenStream;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //dprint('Handling a background message ${message.messageId}');
  FlutterAppBadger.updateBadgeCount(1);
  //await Firebase.initializeApp();
}

void setToken(String? token) {
  if (token == null)
    return;
  //dprint('FCM Token: $token');
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null)
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "FCB": token,
    }, SetOptions(merge:true)).then((value2) {});
}

firebaseInitApp(BuildContext context) async {
  //dprint("firebaseInitApp");
  var supported = await FlutterAppBadger.isAppBadgeSupported();
  //dprint("FlutterAppBadger supported=$supported");
  FlutterAppBadger.removeBadge();

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null && message.notification != null) {
      //dprint("FCB message _notifyCallback=;_notifyCallback ${message.from}");
      if (message.data['chat'] != null){
        if (message.data['chat'] == "true") {
          // if (_chatCallback != null)
          //   _chatCallback!();
          return;
        }
      }
      _notifyCallback(message);
      }
    }
  );
}

firebaseGetToken(BuildContext context) async {
  dprint ("Firebase messaging: _getToken");

  // iOS
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //dprint('User granted permission: ${settings.authorizationStatus}');

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Create an Android Notification Channel.
  //
  // We use this channel in the `AndroidManifest.xml` file to override the
  // default FCM channel to enable heads up notifications.
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // Update the iOS foreground notification presentation options to allow
  // heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  setToken(await FirebaseMessaging.instance.getToken());
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  _tokenStream!.listen(setToken);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification == null)
      return;
    if (_lastMessageId != null)
      if (_lastMessageId == message.messageId)
        return;
    _lastMessageId = message.messageId;
    dprint("FirebaseMessaging.onMessageOpenedApp $message ${message.from}");
    if (message.data['chat'] != null){
      if (message.data['chat'] == "true") {
        // if (_chatCallback != null)
        //   _chatCallback!();
        return;
      }
    }
    _notifyCallback(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    dprint("FirebaseMessaging.onMessage ${message.messageId}" );
    dprint("${message.data['chat']}" );
    if (_lastMessageId != null)
      if (_lastMessageId == message.messageId)
        return;
    _lastMessageId = message.messageId;
    if (message.data['chat'] != null){
      if (message.data['chat'] == "true") {
        // if (_chatCallback != null)
        //   _chatCallback!();
        return;
      }
    }
    FlutterAppBadger.updateBadgeCount(1);
    _notifyCallback(message);
  });
}

String? _lastMessageId;

// Function(RemoteMessage message)? _notifyCallback;

// setNotifyCallback(Function(RemoteMessage message) notifyCallback){
//   _notifyCallback = notifyCallback;
// }

// removeBadge(){
//   FlutterAppBadger.removeBadge();
// }

int _numberOfUnreadMessages = 0;

Function()? updateNotifyPage;

_notifyCallback(RemoteMessage message){
  if (message.notification != null) {
    dprint("setNotifyCallback ${message.notification!.title}");
    _numberOfUnreadMessages++;
    if (updateNotifyPage != null) {
      _numberOfUnreadMessages = 0;
      updateNotifyPage!();
    }
    // if (parent.currentPage == "notify"){
    //   if (parent.updateNotify != null) {
    //     parent.numberOfUnreadMessages = 0;
    //     parent.updateNotify!();
    //   }
    // }
    // dprint("_numberOfUnreadMessages=${parent.numberOfUnreadMessages}");
    redrawMainWindow();
  }
}

setNumberOfUnreadMessages(int val){
  _numberOfUnreadMessages = val;
  redrawMainWindow();
  if (val == 0)
    FlutterAppBadger.removeBadge();
}

getNumberOfUnreadMessages() {
  if (currentScreen() == "notify")
    _numberOfUnreadMessages = 0;
  return _numberOfUnreadMessages;
}

// setUnreadMessagesCount() async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user == null)
//     return;
//   await dbGetAllDocumentInTable("messages", field1: "user", isEqualTo1: user.uid,
//
//   );
//
//   FirebaseFirestore.instance.collection("messages")
//       .where('user', isEqualTo: user.uid).where("read", isEqualTo: false )
//       .get().then((querySnapshot) {
//     _numberOfUnreadMessages = querySnapshot.size;
//     addStat("user messages size", querySnapshot.size);
//   });
// }
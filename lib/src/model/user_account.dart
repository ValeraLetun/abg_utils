import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../../abg_utils.dart';

UserAccountData userAccountData = UserAccountData.createEmpty();

class UserAccountData{
  String userEmail = "";
  String userName = "";
  String userPhone = "";
  String userAvatar = "";
  String userSocialLogin = "";
  bool enableNotify = true;
  List<String> userFavorites = [];
  List<String> userFavoritesProviders = [];
  // List<String> cartList = []; // старая версия, заменена на cartData
  List<CartData> cartData = [];
  List<AddressData> userAddress = [];
  List<String> blockedUsers = [];

  UserAccountData({this.userEmail = "", this.userName = "", this.userPhone  = "",
    this.userAvatar = "", this.userSocialLogin = "", this.enableNotify = true,
    this.userFavorites = const [], this.userFavoritesProviders = const [],
    // this.cartList = const [],
    this.userAddress = const [], this.blockedUsers = const [], this.cartData = const[],
  });

  Map<String, dynamic> toJson() => {
    'userEmail' : userEmail,
    'userName': userName,
    'userPhone': userPhone,
    'userAvatar': userAvatar,
    'userSocialLogin': userSocialLogin,
    'enableNotify': enableNotify,
    'userFavorites': userFavorites,
    'userFavoritesProviders': userFavoritesProviders,
    // 'cartList': cartList,
    'userAddress': userAddress.map((i) => i.toJson()).toList(),
    'cartData': cartData.map((i) => i.toJson()).toList(),
    'blockedUsers': blockedUsers,
  };

  factory UserAccountData.createEmpty(){
    return UserAccountData();
  }

  factory UserAccountData.fromJson(Map<String, dynamic> data, String _userEmail){
    List<String> _userFavorites = [];
    if (data['userFavorites'] != null)
      for (dynamic key in data['userFavorites']){
        _userFavorites.add(key.toString());
      }
    List<String> _userFavoritesProviders = [];
    if (data['userFavoritesProviders'] != null)
      for (dynamic key in data['userFavoritesProviders']){
        _userFavoritesProviders.add(key.toString());
      }
    List<String> _cartList = [];
    if (data['cartList'] != null)
      for (dynamic key in data['cartList']){
        _cartList.add(key.toString());
      }
    List<CartData> _cartData = [];
    if (data['cartData'] != null)
      for (var element in List.from(data['cartData'])) {
        _cartData.add(CartData.fromJson(element));
      }
    List<AddressData> _userAddress = [];
    if (data["address"] != null)
      for (var element in List.from(data['address'])) {
        _userAddress.add(AddressData.fromJson(element));
      }
    _userAddress = _ifAddressDuplicate(_userAddress);
    List<String> _blockedUsers = [];
    if (data['blockedUsers'] != null)
      for (dynamic key in data['blockedUsers']){
        _blockedUsers.add(key.toString());
      }
    return UserAccountData(
        userEmail: _userEmail,
        userName: data["name"] ?? "",
        userPhone: data["phone"] ?? "",
        userAvatar: data["logoServerPath"] ?? "",
        userSocialLogin: data["socialLogin"] ?? "",
        enableNotify: data["enableNotify"] ?? true,
        userFavorites: _userFavorites,  //
        userFavoritesProviders: _userFavoritesProviders,
        // cartList: _cartList,
        cartData: _cartData,
        userAddress: _userAddress,
        blockedUsers: _blockedUsers,
    );
  }
}

List<AddressData> _ifAddressDuplicate(List<AddressData> _userAddress){
  List<AddressData> _added = [];
  for (var item in _userAddress)
    if (!_containAddress(_added, item))
      _added.add(item);
  return _added;
}

bool _containAddress(List<AddressData> list, AddressData address){
  for (var item in list)
    if (item.id == address.id)
      return true;
  return false;
}

Future<String?> changeInfo(String name, String email, String phone) async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    if (userAccountData.userSocialLogin.isEmpty)
      await user.updateEmail(email);
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "name": name,
      "phone": phone,
      "email": email
    }, SetOptions(merge:true));
    userAccountData.userPhone = phone;
    userAccountData.userEmail = email;
    userAccountData.userName = name;
  }catch(ex){
    return "changeInfo " + ex.toString();
  }
  return null;
}

Future<String?> googleLogin() async {

  localSettings.saveLogin("", "", "");

  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    userAccountData.userSocialLogin = "google";
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
    if (userCredential.user == null)
      return "userCredential.user == null";

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(userCredential.user!.uid).get();
    var data = querySnapshot.data();
    if (data != null && data.isNotEmpty)
      return null;

    FirebaseFirestore.instance.collection("listusers").doc(userCredential.user!.uid).set({
      "visible": true,
      "phoneVerified": false,
      "email": userCredential.user!.email,
      "phone": "",
      "name": userCredential.user!.displayName,
      "date_create" : FieldValue.serverTimestamp(),
      "socialLogin" : "google"
    });

    dprint("Sign In ${userCredential.user} with Google");
  } catch (ex) {
    return "googleLogin " + ex.toString();
  }
  return null;
}

Future<String?> facebookLogin() async {
  try {

    localSettings.saveLogin("", "", "");

    if (!kIsWeb)
      await FacebookAuth.instance.logOut();
    LoginResult result = await FacebookAuth.instance.login();

    userAccountData.userSocialLogin = "facebook";

    final AuthCredential credential = FacebookAuthProvider.credential(  // String accessToken
      result.accessToken!.token,
    );
    var t = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = t.user;
    if (user == null)
      return "user == null";

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
    var data = querySnapshot.data();
    if (data != null && data.isNotEmpty)
      return null;

    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "visible": true,
      "phoneVerified": false,
      "email": user.email,
      "phone": "",
      "name": user.displayName,
      "date_create" : FieldValue.serverTimestamp(),
      "socialLogin" : "facebook"
    });
    //_message("Sign In ${user!.uid} with Facebook");
  } catch (ex) {
    return "facebookLogin " + ex.toString();
  }
  return null;
}

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

// Returns the sha256 hash of [input] in hex notation.
// String sha256ofString(String input) {
//   final bytes = utf8.encode(input);
//   final digest = sha256.convert(bytes);
//   return digest.toString();
// }

Future<String?> appleLogin() async {
  AuthorizationCredentialAppleID? credential;

  localSettings.saveLogin("", "", "");

  credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  if (credential.email != null)
    dprint(credential.email!);

  try {
    userAccountData.userSocialLogin = "apple";

    final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      rawNonce: rawNonce,
    );

    var t = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    final User? user = t.user;
    if (user == null)
      return "user == null";

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
    var data = querySnapshot.data();
    if (data != null && data.isNotEmpty)
      return null;

    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "visible": true,
      "phoneVerified": false,
      "email": user.email,
      "phone": "",
      "name": user.displayName ?? "",
      "date_create" : FieldValue.serverTimestamp(),
      "socialLogin" : "apple"
    });
  } catch (e) {
    print(e);
    return "appleLogin " + e.toString();
  }
  return null;
}

logout() async {
  if (!kIsWeb){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null)
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "FCB": "",
      }, SetOptions(merge:true)).then((value2) {});
  }
  await FirebaseAuth.instance.signOut();
  dprint("=================logout===============");
  if (userAccountData.userSocialLogin == "facebook")
    FacebookAuth.instance.logOut();
  // if (userAccountData.userSocialLogin == "google")

  userAccountData = UserAccountData.createEmpty();
  //
  localSettings.saveLogin("", "", "");

}

// stringUserDontCreate - strings.get(182); /// User don't create
Future<String?> register(String email, String pass, String name, String stringUserDontCreate) async {
  try {
    final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: pass,)).user;

    if (user == null)
      return stringUserDontCreate;

    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "visible": true,
      "phoneVerified": false,
      "email": user.email,
      "phone": "",
      "name": name,
      "date_create" : FieldValue.serverTimestamp()
    });

    await FirebaseFirestore.instance.collection("settings").doc("main")
        .set({"customersCount": FieldValue.increment(1)}, SetOptions(merge:true));

    localSettings.saveLogin(email, pass, "email");

  }catch(ex){
    return "register " + ex.toString();
  }
  return null;
}

String? changeFavorites(ProductData item){
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "user == null";
  try{
    if (userAccountData.userFavorites.contains(item.id)) {
      userAccountData.userFavorites.remove(item.id);
      FirebaseFirestore.instance.collection("service").doc(item.id).set({
        "favoritesCount": FieldValue.increment(-1),
        "timeModify": FieldValue.serverTimestamp(),
      }, SetOptions(merge:true));
    }else {
      userAccountData.userFavorites.add(item.id);
      FirebaseFirestore.instance.collection("service").doc(item.id).set({
        "favoritesCount": FieldValue.increment(1),
        "timeModify": FieldValue.serverTimestamp(),
      }, SetOptions(merge:true));
    }

    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "userFavorites": userAccountData.userFavorites,
    }, SetOptions(merge:true)).then((value2) {});

  }catch(ex){
    return "changeFavorites " + ex.toString();
  }
  return null;
}

changeFavoritesProviders(ProviderData item){
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return;
  try{
    if (userAccountData.userFavoritesProviders.contains(item.id)) {
      userAccountData.userFavoritesProviders.remove(item.id);
      FirebaseFirestore.instance.collection("provider").doc(item.id).set({
        "favoritesCount": FieldValue.increment(-1),
      }, SetOptions(merge:true));
    }else {
      userAccountData.userFavoritesProviders.add(item.id);
      FirebaseFirestore.instance.collection("provider").doc(item.id).set({
        "favoritesCount": FieldValue.increment(1),
      }, SetOptions(merge:true));
    }

    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "userFavoritesProviders": userAccountData.userFavoritesProviders,
    }, SetOptions(merge:true)).then((value2) {});

  }catch(ex){
    return "changeFavoritesProviders " + ex.toString();
  }
  return;
}

Future<String?> saveAddress() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "_saveAddress user == null";

  try {
    await dbSetDocumentInTable("listusers", user.uid, {
      "address": userAccountData.userAddress.map((i) => i.toJson()).toList(),
    });

    // FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
    //   "address": userAccountData.userAddress.map((i) => i.toJson()).toList(),
    // }, SetOptions(merge:true)).then((value2) {});
  }catch(ex){
    return "_saveAddress " + ex.toString();
  }
  return null;
}

Future<String?> deleteLocation(AddressData item) async {
  userAccountData.userAddress.remove(item);
  return saveAddress();
}

Future<String?> uploadAvatar(Uint8List _imageData) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "uploadAvatar user == null";
  try{
    var f = Uuid().v4();
    var name = "avatar/$f.jpg";
    userAccountData.userAvatar = await dbSaveFile(name, _imageData);
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putFile(File(_imageFile));
    // userAccountData.userAvatar = await s.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "localFile": name,
      "logoServerPath": userAccountData.userAvatar
    }, SetOptions(merge:true));
  } catch (e) {
    return "uploadAvatar " + e.toString();
  }
  return null;
}

Future<String?> changePassword(String password) async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    await user.updatePassword(password);
  }catch(ex){
    return "changePassword " + ex.toString();
  }
  return null;
}

Future<String?> login(String email, String pass, bool _remember,
    String stringUserNotFound, // strings.get(177) User not found
    String stringUserDisabled  // strings.get(178) "User is disabled. Connect to Administrator for more information.",
    ) async {
  try {
    User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: pass)).user;

    if (user == null)
      return stringUserNotFound; /// User not found

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
    if (!querySnapshot.exists) {
      logout();
      return stringUserNotFound; /// User not found
    }

    var t = querySnapshot.data()!["visible"];
    if (t != null)
      if (!t){
        dprint("User not visible. Don't enter...");
        logout();
        return stringUserDisabled; /// "User is disabled. Connect to Administrator for more information.",
      }

    if (_remember)
      localSettings.saveLogin(email, pass, "email");
    else
      localSettings.saveLogin("", "", "");
  }catch(ex){
    return "login " + ex.toString();
  }
  return null;
}

Future<String?> loginProvider(String email, String pass, bool _remember,
      String stringUserNotFound,        // User not found
      String stringUserMustBeProvider,  // User must be Provider
      String stringUserDisabled         //  "User is disabled. Connect to Administrator for more information.",
    ) async {
  try {
    User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: pass)).user;

    if (user == null)
      return stringUserNotFound; /// User not found

    var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
    if (!querySnapshot.exists) {
      logout();
      return stringUserNotFound; /// User not found
    }

    var querySnapshot2 = await FirebaseFirestore.instance.collection("provider")
        .where('login', isEqualTo: email).get();
    if (querySnapshot2.docs.isEmpty){
      logout();
      return stringUserMustBeProvider; /// User must be Provider
    }

    var _visible = true;
    for (var result in querySnapshot2.docs) {
      dprint("model login " + result.data().toString());
      if (!result.data()["visible"])
        _visible = false;
    }

    if (!_visible){
      dprint("User not visible. Don't enter...");
      logout();
      return stringUserDisabled; /// "User is disabled. Connect to Administrator for more information."
    }

    if (_remember)
      localSettings.saveLogin(email, pass, "email");
    else
      localSettings.saveLogin("", "", "");
  }catch(ex){
    return "model login " + ex.toString();
  }
  dprint("=================login===============");
  return null;
}

Future<String?> addBlockedUser(String id) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "addBlockedUser user == null";
  if (userAccountData.blockedUsers.contains(id))
    return null;
  userAccountData.blockedUsers.add(id);
  try {
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "blockedUsers": userAccountData.blockedUsers,
    }, SetOptions(merge:true));
  }catch(ex){
    return "addBlockedUser " + ex.toString();
  }
  return null;
}

Future<String?> removeBlockedUser(String id) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "removeBlockedUser user == null";
  if (!userAccountData.blockedUsers.contains(id))
    return null;
  userAccountData.blockedUsers.remove(id);
  try {
    await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "blockedUsers": userAccountData.blockedUsers,
    }, SetOptions(merge:true));
  }catch(ex){
    return "removeBlockedUser " + ex.toString();
  }
  return null;
}

Future<List<AddressData>> getUserAddress(String customerId) async{
  List<AddressData> _userAddress = [];
  var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(customerId).get();
  if (!querySnapshot.exists)
    return _userAddress;
  var data = querySnapshot.data();
  if (data == null)
    return _userAddress;
  if (data["address"] != null)
    for (var element in List.from(data['address'])) {
      _userAddress.add(AddressData.fromJson(element));
    }
  return _userAddress;
}
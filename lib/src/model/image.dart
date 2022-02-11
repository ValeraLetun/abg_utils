import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../abg_utils.dart';

class ImageData{
  String serverPath = "";
  String localFile = "";

  ImageData({this.serverPath = "", this.localFile = ""});

  Map<String, dynamic> toJson() => {
    'serverPath': serverPath,
    'localFile': localFile,
  };

  factory ImageData.fromJson(Map<String, dynamic> data){
    return ImageData(
      serverPath: (data["serverPath"] != null) ? data["serverPath"] : "",
      localFile: (data["localFile"] != null) ? data["localFile"] : "",
    );
  }

  factory ImageData.createEmpty(){
    return ImageData();
  }
}

String localFile = "";
String serverPath = "";

Future<String?> uploadImage(String _type, Uint8List _imageData) async {
  if (_type != "customerAppLogo" && _type != "providerAppLogo" && _type != "webSiteAppLogo"
      && _type != "adminPanelAppLogo" && _type != "webSiteAvatar" && _type != "rating"
  )
    return "uploadImage: Unregistered type";

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "uploadImage not register";

  try{
    var f = Uuid().v4();
    localFile = "$f.jpg";

    if (_type == "customerAppLogo" || _type == "providerAppLogo" || _type == "webSiteAppLogo"
        || _type == "adminPanelAppLogo")
      localFile = "settings/$f.jpg";
    if (_type == "webSiteAvatar")
      localFile = "avatar/$f.jpg";
    if (_type == "rating")
      localFile = "rate/$f.jpg";

    serverPath = await dbSaveFile(localFile, _imageData);

    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(localFile);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    // serverPath = await s.ref.getDownloadURL();

    if (_type == "customerAppLogo"){
      appSettings.customerLogoLocal = localFile;
      appSettings.customerLogoServer = serverPath;
    }
    if (_type == "providerAppLogo"){
      appSettings.providerLogoLocal = localFile;
      appSettings.providerLogoServer = serverPath;
    }
    if (_type == "webSiteAppLogo"){
      appSettings.websiteLogoLocal = localFile;
      appSettings.websiteLogoServer = serverPath;
    }
    if (_type == "adminPanelAppLogo"){
      appSettings.adminPanelLogoLocal = localFile;
      appSettings.adminPanelLogoServer = serverPath;
    }
    if (_type == "webSiteAvatar"){
      userAccountData.userAvatar = serverPath;
      await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "localFile": localFile,
        "logoServerPath": userAccountData.userAvatar
      }, SetOptions(merge:true));
    }

  }catch(ex){
    return "uploadFile " + ex.toString();
  }
}

Future<String?> deleteImage(String _type) async {
  if (_type != "customerAppLogo" && _type != "webSiteAppLogo"
      && _type != "providerAppLogo" && _type != "adminPanelAppLogo")
    return "uploadImage: Unregistered type";

  try{
    if (_type == "customerAppLogo"){
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(appSettings.customerLogoLocal);
      // await firebaseStorageRef.delete();
      await dbFileDeleteServerPath(appSettings.customerLogoServer);
      appSettings.customerLogoLocal = "";
      appSettings.customerLogoServer = "";
    }
    if (_type == "providerAppLogo"){
      await dbFileDeleteServerPath(appSettings.providerLogoServer);
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(appSettings.providerLogoLocal);
      // await firebaseStorageRef.delete();
      appSettings.providerLogoLocal = "";
      appSettings.providerLogoServer = "";
    }
    if (_type == "webSiteAppLogo"){
      await dbFileDeleteServerPath(appSettings.websiteLogoServer);
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(appSettings.websiteLogoLocal);
      // await firebaseStorageRef.delete();
      appSettings.websiteLogoLocal = "";
      appSettings.websiteLogoServer = "";
    }
    if (_type == "adminPanelAppLogo"){
      await dbFileDeleteServerPath(appSettings.adminPanelLogoServer);
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(appSettings.adminPanelLogoLocal);
      // await firebaseStorageRef.delete();
      appSettings.adminPanelLogoLocal = "";
      appSettings.adminPanelLogoServer = "";
    }

  }catch(ex){
    return "deleteImage " + ex.toString();
  }
}
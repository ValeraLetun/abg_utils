import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../abg_utils.dart';

Future<List<T>> dbGetDocument<T>(String tableName, String doc, {
        String? field1, String? isEqualTo1
        }) async{

  // if (defaultTargetPlatform == TargetPlatform.windows){
  //   Map<String, dynamic>? querySnapshot = await dbGetDocumentInTableFirebaseRestApi(tableName, doc);
  //   if (querySnapshot == null)
  //     return [];
  //
  //   List<T> t = [];
  //   switch (T){
  //     case SubscriptionData:
  //       if (querySnapshot["subscriptions"] != null){
  //         for (var item in querySnapshot["subscriptions"]) {
  //           var s = SubscriptionData.fromJson(doc, item);
  //           t.add(s as T);
  //         }
  //       }
  //       break;
  //     default:
  //       throw Exception("not supported");
  //   }
  //   return t;
  // }

  var querySnapshot = await FirebaseFirestore.instance.collection(tableName).doc(doc).get();
  if (!querySnapshot.exists)
    return [];

  var d = querySnapshot.data();
  if (d == null)
    return [];

  List<T> t = [];
  switch (T){
    case UserData:
        t.add(UserData.fromJson(querySnapshot.id, d) as T);
      break;
    case SubscriptionData:
      if (d["subscriptions"] != null)
        for (var item in querySnapshot["subscriptions"]) {
          var s = SubscriptionData.fromJson(doc, item);
          t.add(s as T);
        }
      break;
    default:
      throw Exception("not supported");
  }
  return t;
}

Future<List<T>> dbGetAllDocumentInTable<T>(String tableName, {
      String? field1, String? isEqualTo1, String? arrayContains1
  }) async{

  QuerySnapshot<Map<String, dynamic>>? querySnapshot;
  if (field1 != null && (isEqualTo1 != null || arrayContains1 != null)){
    if (isEqualTo1 != null)
      querySnapshot = await FirebaseFirestore.instance.collection(tableName).where(field1, isEqualTo: isEqualTo1).get();
    if (arrayContains1 != null)
      querySnapshot = await FirebaseFirestore.instance.collection(tableName).where(field1, arrayContains: arrayContains1).get();
  }else
    querySnapshot = await FirebaseFirestore.instance.collection(tableName).get();

  if (querySnapshot == null)
    return [];

  addStat(tableName, querySnapshot.docs.length);
  return _makeList(querySnapshot);
}

List<T> _makeList<T>(querySnapshot){
  List<T> t = [];
  switch (T){
    case CategoryData:
      for (var result in querySnapshot.docs)
        t.add(CategoryData.fromJson(result.id, result.data()) as T);
      break;
    case ProviderData:
      for (var result in querySnapshot.docs)
        t.add(ProviderData.fromJson(result.id, result.data()) as T);
      break;
    case UserData:
      for (var result in querySnapshot.docs)
        t.add(UserData.fromJson(result.id, result.data()) as T);
      break;
    case ProductData:
      for (var result in querySnapshot.docs)
        t.add(ProductData.fromJson(result.id, result.data()) as T);
      break;
    case OfferData:
      for (var result in querySnapshot.docs)
        t.add(OfferData.fromJson(result.id, result.data()) as T);
      break;
      default:
        throw Exception("Not implemented");
  }
  return t;
}

dbListenChanges<T>(String tableName, Function(List<T> data) _callback, {String? document}){
  FirebaseFirestore.instance.collection(tableName).snapshots().listen((querySnapshot){
    addStat(tableName, querySnapshot.docs.length);
    List<T> t = _makeList(querySnapshot);
    _callback(t);
  }).onError((ex){
    messageError(buildContext, "dbListenChanges $tableName $document " + ex.toString());
  });
}

Future<String> dbAddDocumentInTable(String tableName, Map<String, dynamic> _data) async{
  var t = await FirebaseFirestore.instance.collection(tableName).add(_data);
  return t.id;
}

dbSetDocumentInTable(String tableName, String document, Map<String, dynamic> _data) async{
  // if (Platform.isWindows){
  //   await dbSetDocumentInTableFirebaseRestApi(tableName, document, _data);
  //   return;
  // }
  await FirebaseFirestore.instance.collection(tableName).doc(document)
      .set(_data, SetOptions(merge:true));
}

dbDeleteDocumentInTable(String tableName, String document) async{
  await FirebaseFirestore.instance.collection(tableName).doc(document).delete();
}

dbIncrementCounter(String tableName, String document, String field, int value) async{
  await FirebaseFirestore.instance.collection(tableName).doc(document).set(
      {field: FieldValue.increment(value)}, SetOptions(merge:true));
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////// FILES ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// если такого файла нет, надо создать
Future<String> dbSaveFile(String name, Uint8List _fileData) async {
  var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
  TaskSnapshot s = await firebaseStorageRef.putData(_fileData);
  return await s.ref.getDownloadURL();
}

dbFileDelete(ImageData name) async {
  await FirebaseStorage.instance.refFromURL(name.serverPath).delete();
}

dbFileDeleteServerPath(String serverPath) async {
  await FirebaseStorage.instance.refFromURL(serverPath).delete();
}

// используется в ondemand - admin - загрузка sample data
dbDeleteAllFilesInFolder(String _folderName) async {
  ListResult result = await FirebaseStorage.instance.ref().child(_folderName).listAll();
  for (var file in result.items){
    var reference = FirebaseStorage.instance.ref(file.fullPath);
    await reference.delete();
  }
}
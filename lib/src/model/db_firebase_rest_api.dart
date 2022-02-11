import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String firebaseKey = "";
String firebaseProjectId = "";

// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password
authToFirebase() async {
  var url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseKey";
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };
  //{"email":"[user@example.com]","password":"[PASSWORD]","returnSecureToken":true}'
  var body = convert.jsonEncode({""
      "email" : "admin@admin.com","password":"123456","returnSecureToken":true
  }
  );
  // var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
  // dprint('Response status: ${response.statusCode}');
  // dprint('Response body: ${response.body}');
  /*
  flutter: Response body: {
  "kind": "identitytoolkit#VerifyPasswordResponse",
  "localId": "LbfmZIzrqDYmn8w6tyO6yun6DOq2",
  "email": "admin@admin.com",
  "displayName": "",
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMxMGM5MGJhNGMzNjYzNTE2ZTA3MDdkMGU5YTg5NDgxMDYyODUxNTgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYnJldml4IiwiYXVkIjoiYnJldml4IiwiYXV0aF90aW1lIjoxNjQ0MTQ4OTQ5LCJ1c2VyX2lkIjoiTGJmbVpJenJxRFltbjh3NnR5TzZ5dW42RE9xMiIsInN1YiI6IkxiZm1aSXpycURZbW44dzZ0eU82eXVuNkRPcTIiLCJpYXQiOjE2NDQxNDg5NDksImV4cCI6MTY0NDE1MjU0OSwiZW1haWwiOiJhZG1pbkBhZG1pbi5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInBob25lX251bWJlciI6Iis0MDc5MDI1NTc0NiIsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsicGhvbmUiOlsiKzQwNzkwMjU1NzQ2Il0sImVtYWlsIjpbImFkbWluQGFkbWluLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.mNG8WFOSNSkQBADj1kMBVqwS5vD5w_u7_jfKfuITRALo7jJRNAz2sw15G9q5qlJ5Faod7vMFqsAT73ZDMG2Zb0gs4zjhZOUFEnbZBkrPc8jScO-0QoW2j2EweAYkQxNJSfvRf7nyW4wJSlTj7KttHkmSp07LYPHYImVwF0LzB4XSTH1mIInzpHbz6jZ74X3FmBg1SCzjEhCvskL2JiFo0lauVzoyahelazndBawVnzAtzWtVsaWcbQEkf3EWdz8wpv1VOEKM92sYPaJk_pgvFhk9hjV4-DCiWVKxxQZb6mJF_4oxJibpXH6GeS7MRkJzdQdMs-jJBxCSrZvZROK4tA",
  "registered": true,
  "refreshToken": "AFxQ4_o4XGBypgKkDSxR3o6dphLNuYFCOmlzGqGTKejsdbB1lNsZDfoTSIZCRgH7p_4f8Spnes43I0m4XgTcfXUluuCWqmqJD0cQMzHsHPBxTYmGFt2WtLonSjn-CXkJuns6hxgIo4N_bQYzAkZL37mn5KIK0_ef7fvmiXffF4HN3aBmlRWE_9qDrx4Bux7NgvApZ0ceXpDl",
  "expiresIn": "3600"
}
   */

}


dbSetDocumentInTableFirebaseRestApi(String collection, String doc, Map<String, dynamic> _data) async {
  var path = "https://firestore.googleapis.com/v1beta1/projects/$firebaseProjectId/databases/(default)/documents/$collection/$doc?&key=$firebaseKey";
  var _dataFB = _encodeFirebaseData(_data);
  var t = _dataFB.toJson();
  var body = convert.jsonEncode(t);
  //print(body);
  await http.patch(Uri.parse(path), body: body);
  // var response =
  // dprint('Response status: ${response.statusCode}');
  // dprint('Response body: ${response.body}');
}

Future<Map<String, dynamic>?> dbGetDocumentInTableFirebaseRestApi(String collection, String doc) async {
  //  GET https://firestore.googleapis.com/v1beta1/{name=projects/*/databases/*/documents/*/**}
  // чтение одного конкретного документа
  var path = "https://firestore.googleapis.com/v1beta1/projects/$firebaseProjectId/databases/(default)/documents/$collection/$doc?&key=$firebaseKey";

  var response = await http.get(Uri.parse(path));
  // dprint('Response status: ${response.statusCode}');
  // dprint('Response body: ${response.body}');
  final body = convert.jsonDecode(response.body);
  var _dataFB = _decodeFirebaseData(body);
  return _dataFB;
}


FirebaseData _encodeFirebaseData(Map<String, dynamic> _data){
  FirebaseData _dataFB = FirebaseData("name", {});
  _data.forEach((key, value) {
    if (value is String) {
      _dataFB.fields.addAll({key: FBValue("stringValue", value)});
      return;
    }
    if (value is bool) {
      _dataFB.fields.addAll({key: FBValue("booleanValue", value)});
      return;
    }
    if (value is double) {
      _dataFB.fields.addAll({key: FBValue("doubleValue", value)});
      return;
    }
    if (value is int) {
      _dataFB.fields.addAll({key: FBValue("integerValue", value)});
      return;
    }
    if (value is List) {
      var values = _fbBuildList(value);
      _dataFB.fields.addAll({key: FBValue("arrayValue", FBValueList(values))});
      return;
    }
    throw Exception("not supported");
  });
  return _dataFB;
}

_parseArrayMapValues2(Map value){
  Map<String, dynamic> fields = {};
  value.forEach((key4, value4) {
    value4.forEach((key, value) {
      //print("key=$key $value");
      value.forEach((key2, value3) {
        if (key2 == "doubleValue" || key2 == "integerValue" || key2 == "booleanValue" || key2 == "stringValue") {
          fields.addAll({key: value3});
          return;
        }
        if (key2 == "arrayValue") {
          List<dynamic> fields2 = _parseArray(value3);
          fields.addAll({key : fields2});
          return;
        }
        throw Exception("not supported");
      });
    });
  });
  return fields;
}

_parseArrayMapValues(value){
  Map<String, dynamic> fields = {};
  value.forEach((key4, value4) {

    if (key4 == "mapValue")
      fields = _parseArrayMapValues2(value4);
    else
      throw Exception("not supported");
  });
  return fields;
}

_parseArrayValues(List value){
  List<dynamic> fields = [];
  for (var value2 in value) {
    var t = _parseArrayMapValues(value2);
    fields.add(t);
  }
  return fields;
}

_parseArray(Map value3){
  List<dynamic> fields = [];
  value3.forEach((key, value4) {
    if (key == "values")
      fields = _parseArrayValues(value4);
    else
      throw Exception("not supported");
  });
  return fields;
}

Map<String, dynamic> _decodeFirebaseData(Map<String, dynamic> data){
  Map<String, dynamic> fields = {};
  if (data['fields'] != null){
    data['fields'].forEach((key, value) {
      value.forEach((key2, value3) {
        if (key2 == "arrayValue"){
          List<dynamic> fields2 = _parseArray(value3);
          fields.addAll({key : fields2});
        }else
          fields.addAll({key : value3});
      });
    });
  }
  return fields;
}


class FBValue{
  FBValue(this.name, this.value);
  String name;
  dynamic value;
  Map<String, dynamic> toJson() => {
    name: value
  };

  factory FBValue.fromJson(Map<String, dynamic> data){
    dynamic _value;
    data.forEach((key, value) {
      if (key == "stringValue")
        _value = value as String;
    });
    return FBValue(
      "",
      _value,
    );
  }
}

class FBValueList{
  FBValueList(this.values);
  List<FBValue> values;
  Map<String, dynamic> toJson() => {
    "values": values
  };
}

class FBValueMap{
  FBValueMap(this.fields);
  Map<String, FBValue> fields = {};
  Map<String, dynamic> toJson() => {
    "fields": fields
  };
}

class FirebaseData{
  String name = "";
  Map<String, FBValue> fields = {};
  FirebaseData(this.name, this.fields);

  Map<String, dynamic> toJson() => {
    "name": name,
    'fields' : fields,
  };
  factory FirebaseData.fromJson(Map<String, dynamic> data){
    Map<String, FBValue> _fields = {};
    if (data['fields'] != null)
      data['fields'].forEach((k, v){
        _fields.addAll({k: FBValue.fromJson(v)});
      });
    return FirebaseData(
      (data["name"] != null) ? data["name"] : "",
      _fields,
    );
  }
}

List<FBValue> _fbBuildList(List value){
  List<FBValue> values = [];
  for (var item in value){
    if (item is String) {
      values.add(FBValue("stringValue", item));
      continue;
    }
    if (item is bool) {
      values.add(FBValue("booleanValue", item));
      continue;
    }
    if (item is double) {
      values.add(FBValue("doubleValue", item));
      continue;
    }
    if (item is int) {
      values.add(FBValue("integerValue", item));
      continue;
    }
    if (item is Map){
      Map<String, FBValue> fl = {};
      item.forEach((key, value) {
        if (value is String) {
          fl.addAll({key: FBValue("stringValue", value)});
          return;
        }
        if (value is bool) {
          fl.addAll({key: FBValue("booleanValue", value)});
          return;
        }
        if (value is double) {
          fl.addAll({key: FBValue("doubleValue", value)});
          return;
        }
        if (value is int) {
          fl.addAll({key: FBValue("integerValue", value)});
          return;
        }
        if (value is List) {
          var values = _fbBuildList(value);
          fl.addAll({key: FBValue("arrayValue", FBValueList(values))});
          return;
        }
        throw Exception("not supported");
      });
      values.add(FBValue("mapValue", FBValue("fields", fl)));
      continue;
    }
    if (item is List){
      var values2 = _fbBuildList(item);
      values.add(FBValue("arrayValue", values2));
      continue;
    }
    throw Exception("not supported");
  }
  return values;
}


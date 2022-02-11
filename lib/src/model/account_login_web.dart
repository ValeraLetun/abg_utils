import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/src/model/pref.dart';
import 'package:firebase_auth/firebase_auth.dart';

var pref = Pref();

Future<String?> accountLoginToDashboard(String _email, String _password, bool _checkValues,
    String stringUserOrPasswordIsIncorrect,  /// strings.get(191); /// "Username or password is incorrect"
    String stringPermissionDenied,          /// strings.get(250); /// "Permission denied"
    ) async {
  User? user;
  try{
    user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,)).user;
  }catch(ex){
    return ex.toString();
  }

  if (user != null){
    if (_checkValues){
      var t = 0;
      String email = "";
      do{
        email = pref.get("email$t");
        if (email == _email)
          break;
        t++;
      }while(email.isNotEmpty);
      if (email != _email) {
        int n = toInt(pref.get(Pref.numPasswords));
        pref.set("email$n", _email);
        pref.set("pass$n", _password);
        n++;
        pref.set(Pref.numPasswords, n.toString());
      }
    }

    var userData = await getUserById(user.uid);
    if (userData == null) {
      logout();
      return stringUserOrPasswordIsIncorrect; /// "Username or password is incorrect"
    }else{
      if (userData.role.isEmpty){
        logout();
        return stringPermissionDenied;
       }
    }
  }
  return null;
}


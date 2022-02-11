import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../abg_utils.dart';
import 'dart:convert' as convert;

String _verificationId = "";
String _lastPhone = "";
String _codeSent = "";

Future<String?> sendOTPCode(String phone, BuildContext context,
    Function() login, Function() _goToCode, AppSettings appSettings,
    String stringCodeSent, //  Code sent. Please check your phone for the verification code.
    ) async { // parent.appSettings

  _lastPhone = checkPhoneNumber("${appSettings.otpPrefix}$phone");
  // var _sym = localAppSettings.otpPrefix.length+localAppSettings.otpNumber;
  // if (_lastPhone.length != _sym)
  //   return "${strings.get(141)} $_sym ${strings.get(142)}"; /// "Phone number must be xx symbols",

  try {

    //
    // Twilio
    //
    if (appSettings.otpTwilioEnable) {
      var serviceId = appSettings.twilioServiceId;
      var url = 'https://verify.twilio.com/v2/Services/$serviceId/Verifications';
      Map<String, String> requestHeaders = {
        'Accept': "application/json",
        'Authorization' : "Basic ${base64Encode(
            utf8.encode("${appSettings.twilioAccountSID}:${appSettings.twilioAuthToken}"))}",
      };

      Map<String, dynamic> map = {};
      map['To'] = _lastPhone;
      map['Channel'] = "sms";

      var response = await http.post(Uri.parse(url), headers: requestHeaders,
          body: map).timeout(const Duration(seconds: 30));
      if (response.statusCode == 201) {
        messageOk(context, stringCodeSent); /// Code sent. Please check your phone for the verification code.
        _goToCode();
        return null;
      }else
        return response.reasonPhrase;
    }

    if (appSettings.otpEnable) {
      _verificationId = "";
      dprint("sendOTPCode $_lastPhone}");

      if (kIsWeb){
        dprint("sendOTPCode $_lastPhone}");
        ConfirmationResult? result;
        result = await FirebaseAuth.instance.signInWithPhoneNumber(_lastPhone);
        _verificationId = result.verificationId;
        print("verificationId=$_verificationId");
        _goToCode();
      }else{
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: _lastPhone,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) async {
              dprint("Verification complete. number=$_lastPhone code=${credential.smsCode}");
              await FirebaseAuth.instance.signInWithCredential(credential);
              login();
            },
            verificationFailed: (FirebaseAuthException e) {
              dprint('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
              messageError(context, 'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
            },
            codeSent: (String _verificationId, int? resendToken) {
              _verificationId = _verificationId;
              dprint('Code sent. Please check your phone for the verification code. verificationId=$_verificationId');
              messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
              _goToCode();
            },
            codeAutoRetrievalTimeout: (String _verificationId) {
              dprint('codeAutoRetrievalTimeout Time Out');
              _verificationId = "";
              messageError(context, 'Time Out');
            }
        );
      }
    }

    //
    // Nexmo
    //
    if (appSettings.otpNexmoEnable) {
      _codeSent = generateCode6();
      var _text = appSettings.nexmoText.replaceFirst("{code}", _codeSent);
      dprint("otpNexmoEnable $_text}");
      if (_lastPhone.startsWith("+"))
        _lastPhone = _lastPhone.substring(1);

      Response response;
      if (kIsWeb){
        Map<String, dynamic> _body = {};
        _body['url'] = "https://rest.nexmo.com/sms/json";
        _body['backurl'] = currentHost;
        _body['from'] = appSettings.nexmoFrom;
        _body['text'] = "$_text ";
        _body['to'] = _lastPhone;
        _body['api_key'] = appSettings.nexmoApiKey;
        _body['api_secret'] = appSettings.nexmoApiSecret;
        response = await http.post(Uri.parse("https://www.abg-studio.com/proxyNexmo.php"),
            body: _body,
            headers: {
              'Accept': "application/json",
            });
        final body = convert.jsonDecode(response.body);
        print("otpNexmo Send body=$body");
        if (body["code"] == 200){
          messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
          _goToCode();
        }
      }else{
        response = await http.post(Uri.parse("https://rest.nexmo.com/sms/json"),
            body: convert.jsonEncode({
              "from": appSettings.nexmoFrom,
              "text" : "$_text ",
              "to" : _lastPhone,
              "api_key": appSettings.nexmoApiKey,
              "api_secret": appSettings.nexmoApiSecret
            }),
            headers: {
              "content-type": "application/json",
            });
        final body = convert.jsonDecode(response.body);
        dprint("otpNexmo Send body=$body");
        if (response.statusCode == 200){
          messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
          _goToCode();
        }
      }


    }

    //
    // SMS.to
    //
    if (appSettings.otpSMSToEnable) {
      _codeSent = generateCode6();
      // DEBUG
      // messageOk(context, strings.get(179)); /// 'Code sent. Please check your phone for the verification code.'
      // return _goToCode();

      var _text = appSettings.smsToText.replaceFirst("{code}", _codeSent);

      Response response;
      if (kIsWeb){
        //curl -L -X GET "https://api.sms.to/sms/send?api_key={api_key}&to=+35794000001&message=This is test and %0A this is a new line&sender_id=smsto"\
        response = await http.get(Uri.parse(
            "https://api.sms.to/sms/send?api_key=${appSettings.smsToApiKey}&to=$_lastPhone"
                "&message=$_text&sender_id=${appSettings.smsToFrom}"),
        );
      }else {
        dprint("otpSMSToEnable $_text}");
        response = await http.post(Uri.parse("https://api.sms.to/sms/send"),
            body: convert.jsonEncode({
              "message": _text,
              "to": _lastPhone,
              "bypass_optout": false,
              "sender_id": appSettings.smsToFrom,
              "callback_url": ""
            }),
            headers: {
              "content-type": "application/json",
              "Authorization": "Bearer ${appSettings.smsToApiKey}",
            });
      }
      final body = convert.jsonDecode(response.body);
      dprint("SMSTo Send body=$body");
      if (response.statusCode == 200){
        messageOk(context, stringCodeSent); /// 'Code sent. Please check your phone for the verification code.'
        _goToCode();
      }
    }

  }catch(ex){
    return "sendOTPCode " + ex.toString();
  }

  return null;
}

bool needOTPParam = false;

Future<String?> otp(String code, AppSettings appSettings,
    String stringPleaseEnterCode, // Please enter valid code
    ) async {
  try {

    //
    // Twilio
    //
    if (appSettings.otpTwilioEnable) {
      var serviceId = appSettings.twilioServiceId;

      var url = 'https://verify.twilio.com/v2/Services/$serviceId/VerificationCheck';
      Map<String, String> requestHeaders = {
        'Accept': "application/json",
        'Authorization' : "Basic ${base64Encode(
            utf8.encode("${appSettings.twilioAccountSID}:${appSettings.twilioAuthToken}"))}",
      };
      Map<String, dynamic> map = {};
      map['To'] = _lastPhone;
      map['Code'] = code;

      var response = await http.post(Uri.parse(url), headers: requestHeaders, body: map).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['status'] != "approved")
          return stringPleaseEnterCode; /// Please enter valid code
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null)
          return "user = null";
        await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
          "phoneVerified": true,
          "phone": _lastPhone,
        }, SetOptions(merge:true));
        needOTPParam = false;
        userAccountData.userPhone = _lastPhone;
        return null;
      }
      return response.reasonPhrase;
    }

    //
    // Firebase
    //
    if (appSettings.otpEnable) {
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: code);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var user1 = await user.linkWithCredential(_credential);
        dprint("linkWithCredential =${user1.user!.uid}");
        await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
          "phoneVerified": true,
          "phone": _lastPhone,
        }, SetOptions(merge:true));
        needOTPParam = false;
        userAccountData.userPhone = _lastPhone;
      }
    }

    //
    // Nexmo
    //
    if (appSettings.otpNexmoEnable) {
      if (_codeSent == code){
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
            "phoneVerified": true,
            "phone": _lastPhone,
          }, SetOptions(merge:true));
          needOTPParam = false;
          userAccountData.userPhone = _lastPhone;
        }else
          return stringPleaseEnterCode; /// "Please enter valid code",
      }
    }

    //
    // SMS to
    //
    if (appSettings.otpSMSToEnable) {
      if (_codeSent == code){
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
            "phoneVerified": true,
            "phone": _lastPhone,
          }, SetOptions(merge:true));
          needOTPParam = false;
          userAccountData.userPhone = _lastPhone;
        }
      }else
        return stringPleaseEnterCode; /// "Please enter valid code",
    }

  }catch(ex){
    return "otp " + ex.toString();
  }
  return null;

}
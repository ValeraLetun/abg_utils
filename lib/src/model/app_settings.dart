import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as df;
import 'package:path_provider/path_provider.dart';
import '../../abg_utils.dart';

AppSettings appSettings = AppSettings.createEmpty();

Future<String?> loadSettings(Function() callbackLoad) async {

  FirebaseFirestore.instance.collection("settings").doc("main").snapshots().listen((querySnapshot){
      var data = querySnapshot.data();
      if (data != null) {
        appSettings = AppSettings.fromJson(data, appSettings.currentServiceAppLanguage);
        appSettings.setPriceStringDataForUtils();
        callbackLoad();
        if (redrawMainWindowInitialized)
          redrawMainWindow();
      }
    }).onError((ex){
      messageError(buildContext, "settings " + ex.toString());
    });

  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("settings").doc("main").get();
    var data = querySnapshot.data();
    if (data != null)
      appSettings.setPriceStringDataForUtils();
  }catch(ex){
    return "loadSettings " + ex.toString();
  }
  return null;
}

Future<String?> saveSettings() async {
  try{
    var _data = appSettings.toJson();
    FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
  }catch(ex){
    return "saveSettings " + ex.toString();
  }
}

class AppSettings{

  int ver;
  int langVer;
  //
  bool demo = false;
  bool rightSymbol = false;
  int digitsAfterComma = 2;
  String code = "USD";
  String symbol = "\$";
  String distanceUnit = "km";
  String timeFormat = "24h";
  getTimeFormat(){
    if (timeFormat == "12h")
      return 'hh:mm a';
    return 'HH:mm';
  }
  setPriceStringDataForUtils() => setPriceStringData(rightSymbol, digitsAfterComma, symbol, distanceUnit);

  String dateFormat = "yyyy.MM.dd";
  String getDateTimeString(DateTime _time){
    return df.DateFormat(dateFormat).format(_time).toString() + " " +
        df.DateFormat(getTimeFormat()).format(_time).toString();
  }
  String googleMapApiKey = "";
  String cloudKey = "";
  String copyright = "";
  String policy = "";
  String about = "";
  String terms = "";
  String googlePlayLink = "";
  String appStoreLink = "";
  // Stripe, PayPal, Razorpay
  bool stripeEnable = false;
  String stripeKey = "";
  String stripeSecretKey = "";
  bool paypalEnable = false;
  String paypalSecretKey = "";
  String paypalClientId = "";
  bool paypalSandBox = false;
  bool razorpayEnable = false;
  String razorpayName = "";
  String razorpayKey = "";
  // payStack
  bool payStackEnable = false;
  String payStackKey = "";
  // FlutterWave
  bool flutterWaveEnable = false;
  String flutterWaveEncryptionKey = "";
  String flutterWavePublicKey = "";
  // MercadoPago
  bool mercadoPagoEnable = false;
  String mercadoPagoAccessToken = "";
  String mercadoPagoPublicKey = "";
  // PayMob
  bool payMobEnable = false;
  String payMobApiKey = "";
  String payMobFrame = "";
  String payMobIntegrationId = "";
  // Instamojo
  bool instamojoEnable = false;
  String instamojoToken = "";
  String instamojoApiKey = "";
  bool instamojoSandBoxMode = true;
  // PayU
  bool payUEnable = false;
  String payUApiKey = "";
  String payUMerchantId = "";
  bool payUSandBoxMode = true;
  //
  bool otpEnable = false;
  String otpPrefix = "";
  int otpNumber = 10;
  bool otpTwilioEnable = false;
  String twilioAccountSID = "";
  String twilioAuthToken = "";
  String twilioServiceId = "";
  // nexmo
  bool otpNexmoEnable = false;
  String nexmoFrom = "";
  String nexmoText = "";
  String nexmoApiKey = "";
  String nexmoApiSecret = "";
  // smsTo
  bool otpSMSToEnable = false;
  String smsToFrom = "";
  String smsToText = "";
  String smsToApiKey = "";
  //
  String defaultServiceAppLanguage = "en";
  String defaultProviderAppLanguage = "en";
  String defaultSiteAppLanguage = "en";
  String defaultAdminAppLanguage = "en";
  String currentServiceAppLanguage = "";
  String currentAdminLanguage = "en";
  List<String> inMainScreenServices = [];
  List<String> customerAppElements = [];
  List<String> customerAppElementsDisabled = [];
  //
  List<StatusData> statuses = statusesDataInit;
  bool statusesFound = false;
  bool adminDarkMode = false; // Admin Panel dark Mode
  // admin counts
  int bookingCount = 0;
  int bookingCountUnread = 0;
  int blogCount = 0;
  int providerCount = 0;
  int serviceCount = 0;
  int customersCount = 0;
  int providerRequestCount = 0;
  int providerNewRequestCount = 0;
  int serviceReviews = 0;
  int offersCount = 0;
  //
  int langVersion = 0;
  // admin panel provider map coordinates
  double providerAreaMapZoom = 0;
  double providerAreaMapLat = 0;
  double providerAreaMapLng = 0;
  int defaultAdminComission = 0;

  // customer app v2
  Color customerMainColor;
  String customerLogoLocal = "";
  String customerLogoServer = "";
  double customerFontSize = 14;
  double customerCategoryImageSize = 80;
  // provider App
  Color providerMainColor;
  String providerLogoLocal = "";
  String providerLogoServer = "";
  // website
  Color websiteMainColor;
  String websiteLogoLocal = "";
  String websiteLogoServer = "";
  // admin Panel
  Color adminPanelMainColor;
  String adminPanelLogoLocal = "";
  String adminPanelLogoServer = "";
  //
  bool bookingToCashMigrate;
  //
  String adminEmail = "";
  String adminPhone = "";
  //
  bool enableSubscriptions;
  // bool enableSubscriptionsFreeTrial;
  // int subscriptionsFreeTrialDays;
  String subscriptionsPromotionText;
  bool subscriptionsInitialized;

  bool isOtpEnable(){
    return (otpEnable || otpTwilioEnable || otpNexmoEnable || otpSMSToEnable);
  }

  //
  AppSettings({this.ver = 1, this.langVer = 0, this.demo = false, this.rightSymbol = false,
    this.digitsAfterComma = 2, this.code = "USD", this.symbol = "\$",
    this.distanceUnit = "km", this.timeFormat = "24h", this.dateFormat = "yyyy.MM.dd",
    this.googleMapApiKey = "", this.cloudKey = "", this.copyright = "© 2021 Handyman & Team", this.policy = "",
    this.about = "", this.terms = "", this.googlePlayLink = "", this.appStoreLink = "",
    //
    this.stripeEnable = false, this.stripeKey = "", this.stripeSecretKey = "",
    this.paypalEnable = false, this.paypalSecretKey = "", this.paypalClientId = "",
    this.razorpayEnable = false, this.razorpayName = "", this.razorpayKey = "",
    this.payStackEnable = false, this.payStackKey = "",
    this.flutterWaveEnable = false, this.flutterWaveEncryptionKey = "",
    this.flutterWavePublicKey = "", this.mercadoPagoEnable = false,
    this.mercadoPagoAccessToken = "", this.mercadoPagoPublicKey = "",
    this.payMobEnable = false, this.payMobApiKey = "", this.payMobFrame = "",
    this.payMobIntegrationId = "", this.instamojoEnable = false, this.instamojoToken = "",
    this.instamojoApiKey = "", this.instamojoSandBoxMode = true,
    this.payUEnable = false, this.payUApiKey = "", this.payUMerchantId = "",
    this.payUSandBoxMode = true,
    //
    this.otpEnable = false, this.otpPrefix = "", this.otpNumber = 10,
    this.defaultServiceAppLanguage = "en", this.defaultProviderAppLanguage = "en",
    this.defaultAdminAppLanguage = "en", this.defaultSiteAppLanguage = "en",
    this.currentServiceAppLanguage = "", this.currentAdminLanguage = "en",
    required this.statuses, this.statusesFound = false,
    this.twilioAccountSID = "", this.twilioAuthToken = "", this.twilioServiceId = "",
    this.otpTwilioEnable = false, this.paypalSandBox = true,
    this.otpNexmoEnable = false, this.nexmoFrom = "", this.nexmoText = "",
    this.nexmoApiKey = "", this.nexmoApiSecret = "", this.otpSMSToEnable = false,
    this.smsToFrom = "", this.smsToText = "", this.smsToApiKey = "",
    //
    this.inMainScreenServices = const [], this.customerAppElements = const [],
    this.customerAppElementsDisabled = const [],
    this.adminDarkMode = false,
    //
    this.bookingCount = 0, this.bookingCountUnread = 0,
    this.blogCount = 0, this.providerCount = 0, this.serviceCount = 0,
    this.customersCount = 0, this.providerRequestCount = 0, this.providerNewRequestCount = 0,
    this.serviceReviews = 0, this.offersCount = 0, this.langVersion = 0,
    //
    this.providerAreaMapZoom = 0, this.providerAreaMapLat = 0, this.providerAreaMapLng = 0,
    this.defaultAdminComission = 0,
    //
    this.customerMainColor = const Color(0xff3c7396), this.customerLogoLocal = "", this.customerLogoServer = "",
    this.customerFontSize = 14, this.customerCategoryImageSize = 80,
    this.providerMainColor = const Color(0xff3c7396), this.providerLogoLocal = "",
    this.providerLogoServer = "", this.websiteMainColor = const Color(0xff3c7396),
    this.websiteLogoLocal = "", this.websiteLogoServer = "", this.adminPanelMainColor = const Color(0xff3c7396),
    this.adminPanelLogoLocal = "", this.adminPanelLogoServer = "",

    this.bookingToCashMigrate = false,
    this.adminEmail = "", this.adminPhone = "",
    this.enableSubscriptions = false,
    // this.enableSubscriptionsFreeTrial = false,
    // this.subscriptionsFreeTrialDays = 0,
    this.subscriptionsPromotionText = "", this.subscriptionsInitialized = false,
  });

  Map<String, dynamic> toJson() => {
    'ver' : ver,
    'lang_ver' : langVer,
    'demo' : demo,
    'right_symbol' : rightSymbol,
    'digits_after_comma' : digitsAfterComma,
    'code' : code,
    'symbol' : symbol,
    'distance_unit' : distanceUnit,
    'time_format' : timeFormat,
    'date_format' : dateFormat,
    'google_map_apikey' : googleMapApiKey,
    'cloud_key' : cloudKey,
    'copyright' : copyright,
    'policy' : policy,
    'about' : about,
    'terms' : terms,
    'googlePlayLink' : googlePlayLink,
    'appStoreLink' : appStoreLink,
    //
    'stripe_enable' : stripeEnable,
    'stripe_key' : stripeKey,
    'stripe_secret_key' : stripeSecretKey,
    'paypal_enable' : paypalEnable,
    'paypalSandBox' : paypalSandBox,
    'paypal_secret_key' : paypalSecretKey,
    'paypal_client_id' : paypalClientId,
    'razorpay_enable' : razorpayEnable,
    'razorpay_name' : razorpayName,
    'razorpay_key' : razorpayKey,
    'payStack_enable': payStackEnable,
    'payStackKey': payStackKey,
    'flutterWaveEnable': flutterWaveEnable,
    'flutterWaveEncryptionKey': flutterWaveEncryptionKey,
    'flutterWavePublicKey' : flutterWavePublicKey,
    'mercadoPagoEnable': mercadoPagoEnable,
    'mercadoPagoAccessToken': mercadoPagoAccessToken,
    'mercadoPagoPublicKey': mercadoPagoPublicKey,
    'payMobEnable': payMobEnable,
    'payMobApiKey': payMobApiKey,
    'payMobFrame': payMobFrame,
    'payMobIntegrationId': payMobIntegrationId,
    'instamojoEnable': instamojoEnable,
    'instamojoToken': instamojoToken,
    'instamojoApiKey': instamojoApiKey,
    'instamojoSandBoxMode': instamojoSandBoxMode,
    'payUEnable': payUEnable,
    'payUApiKey': payUApiKey,
    'payUMerchantId': payUMerchantId,
    'payUSandBoxMode': payUSandBoxMode,
    //
    'otpEnable' : otpEnable,
    'otpPrefix' : otpPrefix,
    'otpNumber' : otpNumber,
    'otpTwilioEnable' : otpTwilioEnable,
    'twilioAccountSID': twilioAccountSID,
    'twilioAuthToken': twilioAuthToken,
    'twilioServiceId': twilioServiceId,
    // nexmo
    "otpNexmoEnable" : otpNexmoEnable,
    "nexmoFrom" : nexmoFrom,
    "nexmoText" : nexmoText,
    "nexmoApiKey" : nexmoApiKey,
    "nexmoApiSecret" : nexmoApiSecret,
    // sms.to
    "otpSMSToEnable" : otpSMSToEnable,
    "smsToFrom" : smsToFrom,
    "smsToText" : smsToText,
    "smsToApiKey" : smsToApiKey,
    //
    'defaultServiceAppLanguage' : defaultServiceAppLanguage,
    'defaultProviderAppLanguage' : defaultProviderAppLanguage,
    'defaultSiteAppLanguage' : defaultSiteAppLanguage,
    'defaultAdminAppLanguage' : defaultAdminAppLanguage,
    'currentServiceAppLanguage' : currentServiceAppLanguage,
    "currentAdminLanguage": currentAdminLanguage,
    //
    'adminDarkMode' : adminDarkMode,
    'bookingCount' : bookingCount,
    'bookingCountUnread' : bookingCountUnread,
    'blogCount': blogCount,
    'providerCount': providerCount,
    'serviceCount': serviceCount,
    'customersCount': customersCount,
    'providerRequestCount': providerRequestCount,
    'providerNewRequestCount': providerNewRequestCount,
    'serviceReviews': serviceReviews,
    'offersCount': offersCount,
    //
    'langVersion': langVersion,
    //
    'providerAreaMapZoom': providerAreaMapZoom,
    'providerAreaMapLat': providerAreaMapLat,
    'providerAreaMapLng': providerAreaMapLng,
    'def_admin_comission': defaultAdminComission,
    //
    'customerMainColor': providerMainColor.value.toString(),
    'customerLogoLocal': customerLogoLocal,
    'customerLogoServer': customerLogoServer,
    'customerFontSize': customerFontSize,
    'customerCategoryImageSize': customerCategoryImageSize,
    'providerMainColor': providerMainColor.value.toString(),
    'providerLogoLocal': providerLogoLocal,
    'providerLogoServer': providerLogoServer,
    'websiteMainColor': websiteMainColor.value.toString(),
    'websiteLogoLocal': websiteLogoLocal,
    'websiteLogoServer': websiteLogoServer,
    'adminPanelMainColor': adminPanelMainColor.value.toString(),
    'adminPanelLogoLocal': adminPanelLogoLocal,
    'adminPanelLogoServer': adminPanelLogoServer,

    'bookingToCashMigrate': bookingToCashMigrate,
    'adminEmail': adminEmail,
    'adminPhone': adminPhone,

    'enableSubscriptions': enableSubscriptions,
    // 'enableSubscriptionsFreeTrial': enableSubscriptionsFreeTrial,
    // 'subscriptionsFreeTrialDays': subscriptionsFreeTrialDays,
    'subscriptionsPromotionText': subscriptionsPromotionText,
    'subscriptionsInitialized': subscriptionsInitialized,
  };

  factory AppSettings.fromJson(Map<String, dynamic> data, String _currentServiceAppLanguage){
    //
    List<StatusData> _statuses = [];
    bool _statusesFound = false;
    if (data['statuses'] != null) {
      _statusesFound = true;
      for (var element in List.from(data['statuses'])) {
        _statuses.add(StatusData.fromJson(element));
      }
    } else
      _statuses = statusesDataInit;
    initStatuses(_statuses);
    //
    if (_currentServiceAppLanguage.isEmpty)
      _currentServiceAppLanguage = data["defaultServiceAppLanguage"] ?? "en";
    //
    List<String> _inMainScreenServices = [];
    if (data['inMainScreenServices'] != null)
      for (dynamic key in data['inMainScreenServices']){
        _inMainScreenServices.add(key.toString());
      }
    //
    // OnDemand Customer ver 1
    //
    List<String> _customerAppElements = [];
    if (data['customerAppElements'] != null)
      for (dynamic key in data['customerAppElements']){
        _customerAppElements.add(key.toString());
      }
    if (!_customerAppElements.contains("search"))
      _customerAppElements.add("search");
    if (!_customerAppElements.contains("banner"))
      _customerAppElements.add("banner");
    if (!_customerAppElements.contains("category"))
      _customerAppElements.add("category");
    if (!_customerAppElements.contains("blog"))
      _customerAppElements.add("blog");
    if (!_customerAppElements.contains("providers"))
      _customerAppElements.add("providers");
    if (!_customerAppElements.contains("category_details"))
      _customerAppElements.add("category_details");
    if (!_customerAppElements.contains("related_products"))
      _customerAppElements.add("related_products");
    if (!_customerAppElements.contains("top_service"))
      _customerAppElements.add("top_service");
    if (!_customerAppElements.contains("favorites"))
      _customerAppElements.add("favorites");
    List<String> _customerAppElementsDisabled = [];
    if (data['customerAppElementsDisabled'] != null)
      for (dynamic key in data['customerAppElementsDisabled']){
        _customerAppElementsDisabled.add(key.toString());
      }

    //
    //
    //

    return AppSettings(
      ver: data["ver"] != null ? toInt(data["ver"].toString()) : 1,
      langVer: data["lang_ver"] != null ? toInt(data["lang_ver"].toString()) : 0,
      demo: data["demo"] ?? false,
      rightSymbol: data["right_symbol"] ?? false,
      digitsAfterComma: data["digits_after_comma"] != null ? toInt(data["digits_after_comma"].toString()) : 2,
      code: data["code"] ?? "USD",
      symbol: data["symbol"] ?? "\$",
      distanceUnit: data["distance_unit"] ?? "km",
      timeFormat: data["time_format"] ?? "24h",
      dateFormat: data["date_format"] ?? "yyyy.MM.dd",
      googleMapApiKey: data["google_map_apikey"] ?? "",
      cloudKey: data["cloud_key"] ?? "",
      //
      copyright: data["copyright"] ?? "",
      about: data["about"] ?? "",
      policy: data["policy"] ?? "",
      terms: data["terms"] ?? "",
      // payments gateway
      stripeEnable: data["stripe_enable"] ?? false,
      stripeKey: data["stripe_key"] ?? "",
      stripeSecretKey: data["stripe_secret_key"] ?? "",
      paypalEnable: data["paypal_enable"] ?? false,
      paypalSandBox: data["paypalSandBox"] ?? true,
      paypalSecretKey: data["paypal_secret_key"] ?? "",
      paypalClientId: data["paypal_client_id"] ?? "",
      razorpayEnable: data["razorpay_enable"] ?? false,
      razorpayName: data["razorpay_name"] ?? "",
      razorpayKey: data["razorpay_key"] ?? "",
      // payStack
      payStackEnable: data["payStack_enable"] ?? false,
      payStackKey: data["payStackKey"] ?? "",
      // FlutterWave
      flutterWaveEnable: data["flutterWaveEnable"] ?? false,
      flutterWaveEncryptionKey: data["flutterWaveEncryptionKey"] ?? "",
      flutterWavePublicKey: data["flutterWavePublicKey"] ?? "",
      // MercadoPago
      mercadoPagoEnable: data["mercadoPagoEnable"] ?? false,
      mercadoPagoAccessToken: data["mercadoPagoAccessToken"] ?? "",
      mercadoPagoPublicKey: data["mercadoPagoPublicKey"] ?? "",
      // PayMob
      payMobEnable: data["payMobEnable"] ?? false,
      payMobApiKey: data["payMobApiKey"] ?? "",
      payMobFrame: data["payMobFrame"] ?? "",
      payMobIntegrationId: data["payMobIntegrationId"] ?? "",
      // Instamojo
      instamojoEnable: data["instamojoEnable"] ?? false,
      instamojoToken: data["instamojoToken"] ?? "",
      instamojoApiKey: data["instamojoApiKey"] ?? "",
      instamojoSandBoxMode: data["instamojoSandBoxMode"] ?? true,
      // PayU
      payUEnable: data["payUEnable"] ?? false,
      payUApiKey: data["payUApiKey"] ?? "",
      payUMerchantId: data["payUMerchantId"] ?? "",
      payUSandBoxMode: data["payUSandBoxMode"] ?? true,
      //
      googlePlayLink: data["googlePlayLink"] ?? "",
      appStoreLink: data["appStoreLink"] ?? "",
      //darkMode: data["darkMode"] != null ? data["darkMode"] : false,
      //
      otpEnable: data["otpEnable"] ?? false,
      otpPrefix: data["otpPrefix"] ?? "",
      otpNumber: data["otpNumber"] != null ? toInt(data["otpNumber"].toString()) : 10,
      otpTwilioEnable: data["otpTwilioEnable"] ?? false,
      twilioAccountSID: data["twilioAccountSID"] ?? "",
      twilioAuthToken: data["twilioAuthToken"] ?? "",
      twilioServiceId: data["twilioServiceId"] ?? "",
      // nexmo
      otpNexmoEnable: data["otpNexmoEnable"] ?? false,
      nexmoFrom: data["nexmoFrom"] ?? "",
      nexmoText: data["nexmoText"] ?? "",
      nexmoApiKey: data["nexmoApiKey"] ?? "",
      nexmoApiSecret: data["nexmoApiSecret"] ?? "",
      // sms to
      otpSMSToEnable: data["otpSMSToEnable"] ?? false,
      smsToFrom: data["smsToFrom"] ?? "",
      smsToText: data["smsToText"] ?? "",
      smsToApiKey: data["smsToApiKey"] ?? "",
      //
      defaultServiceAppLanguage: data["defaultServiceAppLanguage"] ?? "en",
      defaultProviderAppLanguage: data["defaultProviderAppLanguage"] ?? "en",
      defaultSiteAppLanguage: data["defaultSiteAppLanguage"] ?? "en",
      defaultAdminAppLanguage: data["defaultAdminAppLanguage"] ?? "en",
      //
      currentServiceAppLanguage: _currentServiceAppLanguage,
      currentAdminLanguage: data["currentAdminLanguage"] ?? "en",
      //
      statuses: _statuses,
      statusesFound: _statusesFound,
      inMainScreenServices: _inMainScreenServices,
      customerAppElements: _customerAppElements,
      customerAppElementsDisabled: _customerAppElementsDisabled,
      adminDarkMode: data["adminDarkMode"] ?? false,
      //
      bookingCount: data["booking_count"] != null ? toInt(data["booking_count"].toString()) : 0,
      bookingCountUnread: data["booking_count_unread"] != null ? toInt(data["booking_count_unread"].toString()) : 0,
      providerCount: data["provider_count"] != null ? toInt(data["provider_count"].toString()) : 0,
      blogCount: data["blog_count"] != null ? toInt(data["blog_count"].toString()) : 0,
      serviceCount: data["service_count"] != null ? toInt(data["service_count"].toString()) : 0,
      providerRequestCount: data["provider_request_count"] != null ? toInt(data["provider_request_count"].toString()) : 0,
      providerNewRequestCount: data["provider_new_request_count"] != null ? toInt(data["provider_new_request_count"].toString()) : 0,
      customersCount: data["customersCount"] != null ? toInt(data["customersCount"].toString()) : 0,
      serviceReviews: data["service_reviews"] != null ? toInt(data["service_reviews"].toString()) : 0,
      offersCount: data["offer_count"] != null ? toInt(data["offer_count"].toString()) : 0,
      //
      langVersion: data["langVersion"] != null ? toInt(data["langVersion"].toString()) : 0,
      //
      providerAreaMapZoom: data["providerAreaMapZoom"] != null ? toDouble(data["providerAreaMapZoom"].toString()) : 0.0,
      providerAreaMapLat: data["providerAreaMapLat"] != null ? toDouble(data["providerAreaMapLat"].toString()) : 0.0,
      providerAreaMapLng: data["providerAreaMapLng"] != null ? toDouble(data["providerAreaMapLng"].toString()) : 0.0,
      defaultAdminComission: data["def_admin_comission"] != null ? toInt(data["def_admin_comission"].toString()) : 0,
      //
      customerMainColor: (data["customerMainColor"] != null) ? toColor(data["customerMainColor"]) : Color(0xff69c4ff),
      customerLogoLocal: data["customerLogoLocal"] ?? "",
      customerLogoServer: data["customerLogoServer"] ?? "",
      customerFontSize: data["customerFontSize"] != null ? toDouble(data["customerFontSize"].toString()) : 14.0,
      customerCategoryImageSize: data["customerCategoryImageSize"] != null ? toDouble(data["customerCategoryImageSize"].toString()) : 80.0,
      providerMainColor: (data["providerMainColor"] != null) ? toColor(data["providerMainColor"]) : Color(0xff69c4ff),
      providerLogoLocal: data["providerLogoLocal"] ?? "",
      providerLogoServer: data["providerLogoServer"] ?? "",
      websiteMainColor: (data["websiteMainColor"] != null) ? toColor(data["websiteMainColor"]) : Color(0xff69c4ff),
      websiteLogoLocal: data["websiteLogoLocal"] ?? "",
      websiteLogoServer: data["websiteLogoServer"] ?? "",
      adminPanelMainColor: (data["adminPanelMainColor"] != null) ? toColor(data["adminPanelMainColor"]) : Color(0xff69c4ff),
      adminPanelLogoLocal: data["adminPanelLogoLocal"] ?? "",
      adminPanelLogoServer: data["adminPanelLogoServer"] ?? "",

      bookingToCashMigrate: data["bookingToCashMigrate"] ?? false,
      adminEmail: data["adminEmail"] ?? "",
      adminPhone: data["adminPhone"] ?? "",

      enableSubscriptions: data["enableSubscriptions"] ?? false,
      // enableSubscriptionsFreeTrial: data["enableSubscriptionsFreeTrial"] ?? false,
      // subscriptionsFreeTrialDays: data["subscriptionsFreeTrialDays"] != null ? toInt(data["subscriptionsFreeTrialDays"].toString()) : 0,
      subscriptionsPromotionText: data["subscriptionsPromotionText"] ?? "",
      subscriptionsInitialized: data["enableSubscriptions"] ?? false,
    );
  }
  factory AppSettings.createEmpty(){
    return AppSettings(statuses: statusesDataInit);
  }

  String getStatusName(String id, String locale){
    for (var item in statuses)
      if (item.id == id)
        return getTextByLocale(item.name, locale);
    return "???";
  }
}

class StatusData {
  String id;
  List<StringData> name;
  int position;
  bool byCustomerApp;
  bool byProviderApp;
  bool cancel;
  String localFile = "";
  String serverPath = "";
  String assetName = "";

  StatusData({this.id = "", required this.name, this.position = 0,
    this.byCustomerApp = false, this.byProviderApp = false,
    this.localFile = "", this.serverPath = "", this.cancel = false,
    this.assetName = ""});

  factory StatusData.createEmpty(){
    return StatusData(name: []);
  }

  factory StatusData.clone(StatusData source){
    return StatusData(
      id: source.id,
      name: source.name,
      position: source.position,
      byCustomerApp: source.byCustomerApp,
      byProviderApp: source.byProviderApp,
      localFile: source.localFile,
      serverPath: source.serverPath,
      cancel: source.cancel,
      assetName: source.assetName
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name.map((i) => i.toJson()).toList(),
    'position': position,
    'byCustomerApp' : byCustomerApp,
    'byProviderApp' : byProviderApp,
    'cancel': cancel,
    'localFile': localFile,
    'serverPath': serverPath,
  };

  factory StatusData.fromJson(Map<String, dynamic> data){
    List<StringData> _name = [];
    if (data['name'] != null)
      for (var element in List.from(data['name'])) {
        _name.add(StringData.fromJson(element));
      }
    return StatusData(
      id : (data["id"] != null) ? data["id"]: "",
      name: _name,
      position: (data["position"] != null) ? toInt(data["position"].toString()): 0,
      byCustomerApp : (data["byCustomerApp"] != null) ? data["byCustomerApp"]: false,
      byProviderApp : (data["byProviderApp"] != null) ? data["byProviderApp"]: false,
      cancel : (data["cancel"] != null) ? data["cancel"]: false,
      localFile : (data["localFile"] != null) ? data["localFile"]: false,
      serverPath : (data["serverPath"] != null) ? data["serverPath"]: false,
    );
  }
}

List<StatusData> statusesDataInit = [
  StatusData(id: "1", name: [StringData(code: "en", text: "New request")], position: 1,
      byCustomerApp: true, byProviderApp: false, assetName: "assets/ondemands/ondemand8.png"),
  StatusData(id: "2", name: [StringData(code: "en", text: "Accept")], position: 2,
      byCustomerApp: false, byProviderApp: true, assetName: "assets/ondemands/ondemand9.png"),
  StatusData(id: "3", name: [StringData(code: "en", text: "Ready")], position: 3,
      byCustomerApp: false, byProviderApp: true, assetName: "assets/ondemands/ondemand10.png"),
  StatusData(id: "5", name: [StringData(code: "en", text: "Finish")], position: 4,
      byCustomerApp: true, byProviderApp: false, assetName: "assets/ondemands/ondemand11.png"),
  StatusData(id: "4", name: [StringData(code: "en", text: "Cancel")], position: 5,
      byCustomerApp: true, byProviderApp: true, cancel: true, assetName: "assets/ondemands/ondemand15.png"),
];


Future<String?> getSettingsFromFile(Function(AppSettings appSettings) onSuccess) async {
  if (kIsWeb)
    return null;
  try{
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var _file = File('$directoryPath/settings.json');
    if (!await _file.exists())
      return null;
      //await _file.writeAsString(json.encode(parent.localAppSettings.toJson()));
    final contents = await _file.readAsString();
    var data = json.decode(contents);
    // dprint("_getSettings $data");
    //parent.localAppSettings = AppSettings.fromJson(data);
    var t = AppSettings.fromJson(data, "");
    t.setPriceStringDataForUtils();
    onSuccess(t);
  }catch(ex){
    return "model getSettings " + ex.toString();
  }
  return null;
}

Future<String?> saveSettingsToLocalFile(AppSettings appSettings) async {
  if (kIsWeb)
    return null;
  var directory = await getApplicationDocumentsDirectory();
  var directoryPath = directory.path;
  var _file = File('$directoryPath/settings.json');
  var _data = json.encode(appSettings.toJson());
  await _file.writeAsString(_data);
}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

Future<String?> settingsSaveGeneral(String mapApi, String messageKey,
    String _comission, String adminEmail, String adminPhone) async{
  appSettings.googleMapApiKey = mapApi;
  appSettings.cloudKey = messageKey;
  appSettings.defaultAdminComission = toInt(_comission);
  Map<String, Object> _data = {
    // "appname": appSettings.appname,
    "google_map_apikey" : appSettings.googleMapApiKey,
    "cloud_key" : messageKey,
    "distance_unit" : appSettings.distanceUnit,
    "time_format" : appSettings.timeFormat,
    "date_format" : appSettings.dateFormat,
    "def_admin_comission" : appSettings.defaultAdminComission,
    'adminEmail': adminEmail,
    'adminPhone': adminPhone,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveSettingsGeneral " + ex.toString();
  }
  return null;
}

Future<String?> settingsSaveCurrency(String _code, String _symbol) async{
  // appSettings.code = _code;
  // appSettings.symbol = _symbol;
  var _data = {
    "code": _code,
    "symbol" : _symbol,
    "right_symbol" : appSettings.rightSymbol,
    "digits_after_comma" : appSettings.digitsAfterComma,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
    // appSettings.setPriceStringDataForUtils();
  }catch(ex){
    return "saveSettingsCurrency " + ex.toString();
  }
  return null;
}

Future<String?> saveSettingsPayments(String _stripeKey, String _stripeSecretKey, String _paypalSecretKey,
    String _paypalClientId, String _razorpayName, String _razorpayKey,
    String _payStackKey, String _flutterWaveEncryptionKey, String _flutterWavePublicKey,
    String _mercadoPagoAccessToken, String _mercadoPagoPublicKey,
    String _payMobApiKey, String _payMobFrame, String _payMobIntegrationId,
    String _instamojoToken, String _instamojoApiKey,
    String _payUApiKey, String _payUMerchantId
    ) async{
  appSettings.stripeKey = _stripeKey;
  appSettings.stripeSecretKey = _stripeSecretKey;
  appSettings.paypalSecretKey = _paypalSecretKey;
  appSettings.paypalClientId = _paypalClientId;
  appSettings.razorpayName = _razorpayName;
  appSettings.razorpayKey = _razorpayKey;
  // payStack
  appSettings.payStackKey = _payStackKey;
  // FlutterWave
  appSettings.flutterWaveEncryptionKey = _flutterWaveEncryptionKey;
  appSettings.flutterWavePublicKey = _flutterWavePublicKey;
  // MercadoPago
  appSettings.mercadoPagoAccessToken = _mercadoPagoAccessToken;
  appSettings.mercadoPagoPublicKey = _mercadoPagoPublicKey;
  // PayMob
  appSettings.payMobApiKey = _payMobApiKey;
  appSettings.payMobFrame = _payMobFrame;
  appSettings.payMobIntegrationId = _payMobIntegrationId;
  // Instamojo
  appSettings.instamojoToken = _instamojoToken;
  appSettings.instamojoApiKey = _instamojoApiKey;
  // PayU
  appSettings.payUApiKey = _payUApiKey;
  appSettings.payUMerchantId = _payUMerchantId;

  var _data = {
    "stripe_enable": appSettings.stripeEnable,
    "stripe_key": appSettings.stripeKey,
    "stripe_secret_key": appSettings.stripeSecretKey,
    "paypal_enable": appSettings.paypalEnable,
    "paypalSandBox": appSettings.paypalSandBox,
    "paypal_secret_key": appSettings.paypalSecretKey,
    "paypal_client_id": appSettings.paypalClientId,
    "razorpay_enable": appSettings.razorpayEnable,
    "razorpay_name": appSettings.razorpayName,
    "razorpay_key": appSettings.razorpayKey,
    // paystack
    "payStack_enable": appSettings.payStackEnable,
    'payStackKey': appSettings.payStackKey,
    // FlutterWave
    'flutterWaveEnable':  appSettings.flutterWaveEnable,
    'flutterWaveEncryptionKey': appSettings.flutterWaveEncryptionKey,
    'flutterWavePublicKey': appSettings.flutterWavePublicKey,
    // MercadoPago
    'mercadoPagoEnable' : appSettings.mercadoPagoEnable,
    'mercadoPagoAccessToken' : appSettings.mercadoPagoAccessToken,
    'mercadoPagoPublicKey' : appSettings.mercadoPagoPublicKey,
    // PayMob
    'payMobEnable' : appSettings.payMobEnable,
    'payMobApiKey' : appSettings.payMobApiKey,
    'payMobFrame' : appSettings.payMobFrame,
    'payMobIntegrationId' : appSettings.payMobIntegrationId,
    // Instamojo
    'instamojoEnable' : appSettings.instamojoEnable,
    'instamojoToken' : appSettings.instamojoToken,
    'instamojoApiKey' : appSettings.instamojoApiKey,
    'instamojoSandBoxMode' : appSettings.instamojoSandBoxMode,
    // payU
    'payUEnable': appSettings.payUEnable,
    'payUApiKey': appSettings.payUApiKey,
    'payUMerchantId': appSettings.payUMerchantId,
    'payUSandBoxMode': appSettings.payUSandBoxMode,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveSettingsPayments " + ex.toString();
  }
  return null;
}

Future<String?> saveSettingsOTP(String _otpPrefix, String _otpNumber,
    String _twilioAccountSID, String _twilioAuthToken, String _twilioServiceId,
    _nexmoFrom, _nexmoText, _nexmoApiKey, _nexmoApiSecret, _sMSToFrom,
    _sMSToText, _sMSToApiKey) async{

  appSettings.otpPrefix = _otpPrefix;
  appSettings.otpNumber = int.parse(_otpNumber);
  appSettings.twilioAccountSID = _twilioAccountSID;
  appSettings.twilioAuthToken = _twilioAuthToken;
  appSettings.twilioServiceId = _twilioServiceId;
  // nexmo
  appSettings.nexmoFrom = _nexmoFrom;
  appSettings.nexmoText = _nexmoText;
  appSettings.nexmoApiKey = _nexmoApiKey;
  appSettings.nexmoApiSecret = _nexmoApiSecret;
  // sms.to
  appSettings.smsToFrom = _sMSToFrom;
  appSettings.smsToText = _sMSToText;
  appSettings.smsToApiKey = _sMSToApiKey;
  var _data = {
    "otpEnable": appSettings.otpEnable,
    "otpPrefix": appSettings.otpPrefix,
    "otpNumber": appSettings.otpNumber,
    "otpTwilioEnable": appSettings.otpTwilioEnable,
    "twilioAccountSID": appSettings.twilioAccountSID,
    "twilioAuthToken": appSettings.twilioAuthToken,
    "twilioServiceId": appSettings.twilioServiceId,
    // nexmo
    "otpNexmoEnable" : appSettings.otpNexmoEnable,
    "nexmoFrom" : appSettings.nexmoFrom,
    "nexmoText" : appSettings.nexmoText,
    "nexmoApiKey" : appSettings.nexmoApiKey,
    "nexmoApiSecret" : appSettings.nexmoApiSecret,
    // sms.to
    "otpSMSToEnable" : appSettings.otpSMSToEnable,
    "smsToFrom" : appSettings.smsToFrom,
    "smsToText" : appSettings.smsToText,
    "smsToApiKey" : appSettings.smsToApiKey,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveSettingsOTP " + ex.toString();
  }
  return null;
}

Future<String?> saveSettingsShare(String _googlePlayLink, String _appStoreLink) async{
  appSettings.googlePlayLink = _googlePlayLink;
  appSettings.appStoreLink = _appStoreLink;
  var _data = {
    "googlePlayLink": appSettings.googlePlayLink,
    "appStoreLink": appSettings.appStoreLink,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveSettingsShare " + ex.toString();
  }
  return null;
}

Future<String?> saveSettingsDocuments(String _copyright, String _about, String _policy, String _terms) async{
  appSettings.copyright = _copyright;
  appSettings.about = _about;
  appSettings.policy = _policy;
  appSettings.terms = _terms;
  var _data = {
    "copyright": appSettings.copyright,
    "about": appSettings.about,
    "policy": appSettings.policy,
    "terms": appSettings.terms,
  };
  try{
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveSettingsDocuments " + ex.toString();
  }
  return null;
}

Future<String?> saveAdminPanelDarkMode(bool darkMode) async{ // theme.darkMode
  try{
    var _data = {
      "adminDarkMode": darkMode,
    };
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveAdminPanelDarkMode " + ex.toString();
  }
  return null;
}

Future<String?> saveElementsList() async{
  try{
    var _data = {
      "customerAppElements": appSettings.customerAppElements,
      "customerAppElementsDisabled" : appSettings.customerAppElementsDisabled,
    };
    await dbSetDocumentInTable("settings", "main", _data);
  }catch(ex){
    return "saveElementsList " + ex.toString();
  }
  return null;
}
import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/src/payments/paymob/pay_mob_mobile2.dart';
import 'package:flutter/material.dart';

class PayMobMobile extends StatefulWidget {
  final Function onFinish;
  final String userFirstName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;
  final String code; //  _mainModel.localAppSettings.code
  final String userName;
  final PayMobStrings? strings;

  final Color mainColor;

  PayMobMobile({required this.onFinish, required this.userFirstName,
    required this.userEmail, required this.payAmount,
    required this.apiKey, required this.frame, required this.integrationId, required this.userPhone,
    required this.userName, required this.code, this.strings, this.mainColor = Colors.green});

  @override
  State<StatefulWidget> createState() {
    return PayMobMobileState();
  }
}

class PayMobMobileState extends State<PayMobMobile> {

  var windowWidth = 0.0;
  var windowHeight = 0.0;
  final editControllerCity = TextEditingController();
  final editControllerCountry = TextEditingController();
  final editControllerPostalCode = TextEditingController();
  final editControllerState = TextEditingController();
  final editControllerFirstName = TextEditingController();
  final editControllerLastName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerStreet = TextEditingController();
  final editControllerBuilding = TextEditingController();
  final editControllerFloor = TextEditingController();
  final editControllerApartment = TextEditingController();

  PayMobStrings strings = PayMobStrings();

  @override
  void initState() {
    editControllerFirstName.text = widget.userName;
    textFieldToEnd(editControllerFirstName);
    editControllerEmail.text = widget.userEmail;
    textFieldToEnd(editControllerEmail);
    editControllerPhone.text = widget.userPhone;
    textFieldToEnd(editControllerPhone);
    if (widget.strings != null)
      strings = widget.strings!;
    super.initState();
  }

  @override
  void dispose() {
    editControllerCity.dispose();
    editControllerCountry.dispose();
    editControllerPostalCode.dispose();
    editControllerState.dispose();
    editControllerFirstName.dispose();
    editControllerLastName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerStreet.dispose();
    editControllerBuilding.dispose();
    editControllerFloor.dispose();
    editControllerApartment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: appBar("PayMob"),
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _getList(),
              ),),

          ],
        )
    );
  }

  appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
      ),
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(Container(
      alignment: Alignment.center,
      child: Text(strings.info, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,))
    );

    list.add(SizedBox(height: 20,));

    // editControllerCountry.text = "Egypt";
    list.add(Text(strings.country));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerCountry, type: TextInputType.text));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.postalCode));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerPostalCode, type : TextInputType.number,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.state));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerState, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.city));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerCity, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.street));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerStreet, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.building));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerBuilding, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.floor));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerFloor, type : TextInputType.number,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.apartment));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerApartment, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.firstName));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerFirstName, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.lastName));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerLastName, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.email));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerEmail, type : TextInputType.text,));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.phone));
    list.add(SizedBox(height: 5,));
    list.add(edit9(editControllerPhone, type : TextInputType.text,));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      alignment: Alignment.center,
      child: button2(strings.next, widget.mainColor, _next),
    ),);

    list.add(SizedBox(height: 100,));

    return list;
  }

  _next(){
    // editControllerCountry.text = "Egypt";
    // editControllerPostalCode.text = "121212";
    // editControllerState.text = "d";
    // editControllerCity.text = "Bani Sweif";
    // editControllerStreet.text = "Qism Bani Sweif";
    // editControllerBuilding.text = "1";
    // editControllerFloor.text = "1";
    // editControllerApartment.text = "1";
    // editControllerFirstName.text = "Abdul";
    // editControllerLastName.text = "salai";
    // editControllerEmail.text = "s@m.ru";
    // editControllerPhone.text = "+20822207098";

    if (editControllerCountry.text.isEmpty)
      return messageError(context, strings.needCountry);
    if (editControllerPostalCode.text.isEmpty)
      return messageError(context, strings.needCode);
    if (editControllerState.text.isEmpty)
      return messageError(context, strings.needState);
    if (editControllerCity.text.isEmpty)
      return messageError(context, strings.needCity);
    if (editControllerStreet.text.isEmpty)
      return messageError(context, strings.needStreet);
    if (editControllerBuilding.text.isEmpty)
      return messageError(context, strings.needBuilding);
    if (editControllerFloor.text.isEmpty)
      return messageError(context, strings.needFloor);
    if (editControllerApartment.text.isEmpty)
      return messageError(context, strings.needApartment);
    if (editControllerFirstName.text.isEmpty)
      return messageError(context, strings.needFirstName);
    if (editControllerLastName.text.isEmpty)
      return messageError(context, strings.needLastName);
    if (editControllerEmail.text.isEmpty)
      return messageError(context, strings.needEmail);
    if (editControllerPhone.text.isEmpty)
      return messageError(context, strings.needPhone);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobMobile2(
            userFirstName: editControllerFirstName.text,
            userEmail: editControllerEmail.text,
            userPhone: editControllerPhone.text,
            payAmount: widget.payAmount,
            apiKey: widget.apiKey,
            frame: widget.frame,
            integrationId: widget.integrationId,
            //
            country: editControllerCountry.text,
            postalCode: editControllerPostalCode.text,
            state: editControllerState.text,
            city: editControllerCity.text,
            street: editControllerStreet.text,
            building: editControllerBuilding.text,
            floor: editControllerFloor.text,
            apartment: editControllerApartment.text,
            lastName: editControllerLastName.text,
            //
            onFinish: (w){
              widget.onFinish(w);
            },
            code: widget.code,
        ),
      ),
    );
  }

}

/*

"country": "Egypt",
"postal_code": "2",
"state": "2"
"city": "1",

"street": "2",
"building": "2",
"floor": "1",
"apartment": "1",

"first_name": userFirstName,
"last_name": "2",
"email": email,
"phone_number": "$phone",

?????? "shipping_method": "2",
 */

class PayMobStrings{
  String country;
  String postalCode;
  String state;
  String city;
  String street;
  String building;
  String floor;
  String apartment;
  String firstName;
  String lastName;
  String email;
  String phone;
  String next;
  String info;
  String needCountry;
  String needCode;
  String needState;
  String needCity;
  String needStreet;
  String needBuilding;
  String needFloor;
  String needApartment;
  String needFirstName;
  String needLastName;
  String needEmail;
  String needPhone;

  PayMobStrings({
    this.country = "Country",
    this.postalCode = "Postal code",
    this.state = "State",
    this.city = "City",
    this.street = "Street",
    this.building = "Building",
    this.floor = "Floor",
    this.apartment = "Apartment",
    this.firstName = "First Name",
    this.lastName = "Last Name",
    this.email = "Email",
    this.phone = "Phone",
    this.next = "Next",
    this.info = "Provide the following information for payment",
    //
    this.needCountry = "Need enter country",
    this.needCode = "Need enter postal code",
    this.needState = "Need enter State",
    this.needCity = "Need enter City",
    this.needStreet = "Need enter Street",
    this.needBuilding = "Need enter Building",
    this.needFloor = "Need enter Floor",
    this.needApartment = "Need enter Apartment",
    this.needFirstName = "Need enter First Name",
    this.needLastName = "Need enter Last Name",
    this.needEmail = "Need enter Email",
    this.needPhone = "Need enter Phone",
});
}

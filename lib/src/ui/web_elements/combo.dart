import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class ComboData{
  final String id;
  final String text;
  final String email;
  final bool selected;
  final bool divider;
  bool checkSelected = false;

  ComboData(this.text, this.id, {this.email = "", this.selected = false,
    this.divider = false});
}

class Combo extends StatefulWidget {
  final List<ComboData> data;
  final String value;
  final Function(String value) onChange;
  final String text;
  final bool inRow;

  const Combo({Key? key, required this.onChange,
    required this.data, required this.value, required this.text, this.inRow = false}) : super(key: key);

  @override
  _ComboState createState() => _ComboState();
}

class _ComboState extends State<Combo> {

  GlobalKey dropdownKey = GlobalKey();

  double windowWidth = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    if (widget.inRow)
      return Row(
        children: [
          SelectableText(widget.text, style: aTheme.style14W400,),
          SizedBox(width: 5,),
          Expanded(child: _combo())
        ],
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        SelectableText(widget.text, style: aTheme.style14W400,),
        SizedBox(height: 5,),
        _combo()
      ],
    );
  }

  _combo(){
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: focusNode.hasFocus ?
        BoxDecoration(
            color: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: Border.all(
              color: Colors.blue,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              )]) :
        BoxDecoration(
          color: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
          borderRadius: BorderRadius.circular(aTheme.radius),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: _comboBox1()
    );
  }

  _comboBox1(){
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in widget.data)
      menuItems.add(DropdownMenuItem(
        child: Text(item.text, style: aTheme.style14W400),
        value: item.id,
      ),);
    return Form(
        key: _formKey,
        child: Container(
        width: windowWidth,
        height: 40,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
                child:  DropdownButton<String>(
                key: dropdownKey,
                focusNode: focusNode,
                focusColor: Colors.transparent,
                dropdownColor: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
                isExpanded: true,
                autofocus: true,
                value: widget.value,
                items: menuItems,
                onChanged: (value) {
                  widget.onChange(value as String);
                  setState(() {});
                })
            ))));
  }
}

/* provider v1
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/theme.dart';

class ComboData{
  final String id;
  final String text;

  ComboData(this.text, this.id);
}

class Combo extends StatefulWidget {
  final List<ComboData> data;
  final String value;
  final Function(String value) onChange;
  final String text;
  final bool inRow;

  const Combo({Key? key, required this.onChange,
    required this.data, required this.value, required this.text, this.inRow = false}) : super(key: key);

  @override
  _ComboState createState() => _ComboState();
}

class _ComboState extends State<Combo> {

  GlobalKey dropdownKey = GlobalKey();

  var windowWidth;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    if (widget.inRow)
      return _combo();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        SelectableText(widget.text, style: theme.style14W400,),
        SizedBox(height: 5,),
        _combo()
      ],
    );
  }

  _combo(){
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: focusNode.hasFocus ?
        BoxDecoration(
            color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
            border: new Border.all(
              color: Colors.blue,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              )]) :
        BoxDecoration(
          color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
          border: new Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: _comboBox1()
    );
  }

  _comboBox1(){
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in widget.data)
      menuItems.add(DropdownMenuItem(
        child: Text(item.text, style: theme.style14W400),
        value: item.id,
      ),);
    return Form(
        key: _formKey,
        child: Container(
        width: windowWidth,
        height: 40,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
                child:  DropdownButton<String>(
                key: dropdownKey,
                focusNode: focusNode,
                focusColor: Colors.transparent,
                dropdownColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                isExpanded: true,
                autofocus: true,
                value: widget.value,
                items: menuItems,
                onChanged: (value) {
                  widget.onChange(value as String);
                  setState(() {});
                })
            ))));
  }
}


 */
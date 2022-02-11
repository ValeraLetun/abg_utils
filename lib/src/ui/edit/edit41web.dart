import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

//
// цена
// цена с знаком (+/- в начале обязательно)
// цифры только до 100
//
//

class Edit41web extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final Function(String)? onChange;
  final bool price;
  final bool priceOnly100;
  final bool multiline;
  final int numberOfDigits;
  final bool pricePlusMinus;

  const Edit41web({Key? key, this.controller, this.hint = "",
    this.price = false, this.numberOfDigits = 2, this.pricePlusMinus = false,
    this.onChange, this.multiline = false, this.priceOnly100 = false,
  }) : super(key: key);

  @override
  _Edit11State createState() => _Edit11State();
}

class _Edit11State extends State<Edit41web> {

  final bool _obscure = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode focusNode;

  var regx = r'(^\d*[.]?\d{0,2})';

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
    //
    if (widget.numberOfDigits == 0)
      regx = r'(^\d*)';
    if (widget.numberOfDigits == 1)
      regx = r'(^\d*[.]?\d{0,1})';
    if (widget.numberOfDigits == 3)
      regx = r'(^\d*[.]?\d{0,3})';

    if (widget.pricePlusMinus){
      if (widget.numberOfDigits == 0)
        regx = r'(^[\-|\+]\d*)';
      if (widget.numberOfDigits == 1)
        regx = r'(^[\-|\+]\d*[.]?\d{0,1})';
      if (widget.numberOfDigits == 2)
        regx = r'(^[\-|\+]\d*[.]?\d{0,2})';
      if (widget.numberOfDigits == 3)
        regx = r'(^[\-|\+]\d*[.]?\d{0,3})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: (widget.multiline) ? 200 : 40,
      padding: EdgeInsets.only(left: 10, right: 10, top: (widget.multiline) ? 10 : 0, bottom: (widget.multiline) ? 10 : 0),
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
      child: Form(
        key: _formKey,
        child: TextField(
          focusNode: focusNode,
          controller: widget.controller,
          onChanged: (String value) async {
            if (widget.onChange != null) {
              widget.onChange!(value);
            }
          },
          cursorColor: aTheme.style14W400.color,
          style: aTheme.style14W400,
          cursorWidth: 1,
          keyboardType: (widget.price || widget.pricePlusMinus || widget.priceOnly100) ? TextInputType.numberWithOptions()
              : (widget.multiline) ? TextInputType.multiline : TextInputType.text,
          inputFormatters: (widget.price || widget.pricePlusMinus) ? [
            FilteringTextInputFormatter.allow(RegExp(regx)),
          ] : (widget.priceOnly100) ? [
            FilteringTextInputFormatter.digitsOnly,
            CustomRangeTextInputFormatter(100),
          ] : [],
          maxLines: (widget.multiline) ? 10 : 1,
          obscureText: _obscure,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: aTheme.style14W400Grey,
              // TextStyle(fontFamily: widget.style.fontFamily, fontSize: widget.style.fontSize,
              //     fontWeight: widget.style.fontWeight, color: widget.style.color!.withAlpha(100)),
              contentPadding: EdgeInsets.only(bottom: 10)
          ),
        ),
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final int max;
  CustomRangeTextInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if(newValue.text == '') {
      return TextEditingValue();
    } else if(int.parse(newValue.text) < 0) {
      return TextEditingValue(selection: TextSelection.collapsed(offset: 2)).copyWith(text: '0');
    }
    return int.parse(newValue.text) > max ? TextEditingValue(selection: TextSelection.collapsed(offset: 3)).copyWith(text: max.toString()) : newValue;
  }
}


class Edit41Number extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final Color color;
  final double radius;
  final Function(String)? onChange;
  final TextStyle style;
  final Color backgroundColor;

  const Edit41Number({Key? key, this.controller, this.hint = "", this.color = Colors.black, required this.radius,
    this.backgroundColor = Colors.white,
    this.onChange, this.style = const TextStyle(),}) : super(key: key);

  @override
  _Edit41NumberState createState() => _Edit41NumberState();
}

class _Edit41NumberState extends State<Edit41Number> {

  final bool _obscure = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height:  40,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: focusNode.hasFocus ?
      BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.radius),
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
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: widget.color,
          width: 1.0,
        ),
      ),
      child: Form(
        key: _formKey,
        child: TextField(
          focusNode: focusNode,
          controller: widget.controller,
          onChanged: (String value) async {
            if (widget.onChange != null)
              widget.onChange!(value);
          },
          cursorColor: widget.style.color,
          style: widget.style,
          cursorWidth: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLines: 1,
          obscureText: _obscure,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(fontFamily: widget.style.fontFamily, fontSize: widget.style.fontSize,
                  fontWeight: widget.style.fontWeight, color: widget.style.color!.withAlpha(100)),
              contentPadding: EdgeInsets.only(bottom: 10)
          ),
        ),
      ),
    );
  }
}

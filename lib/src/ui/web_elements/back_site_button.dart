import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class BackSiteButton extends StatefulWidget {
  final String text;

  const BackSiteButton({Key? key, required this.text}) : super(key: key);

  @override
  _BackSiteButtonState createState() => _BackSiteButtonState();
}

class _BackSiteButtonState extends State<BackSiteButton> {

  double windowWidth = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;

    return Row(
        children: [
          Text("<-", style: aTheme.style14W400),
          SizedBox(width: 10,),
          ButtonTextWeb(text: widget.text, onTap: (){
            goBack();
          },)
        ]
    );
  }

}
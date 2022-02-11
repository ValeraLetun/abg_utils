import 'package:flutter/material.dart';

class Button197 extends StatelessWidget {
  final Function()? pressButton;
  final Color color;
  final String text;
  final String text2;
  final double height;
  final TextStyle textStyle;
  final TextStyle? textStyle2;
  final bool onlyBorder;
  final Widget icon;
  Button197({required this.icon, this.pressButton, this.text = "", this.color = Colors.grey, required this.textStyle, this.height = 45,
    this.onlyBorder = false, this.text2 = "", this.textStyle2});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
        ),
        child: Stack(children: [

            Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    icon,
                    SizedBox(width: 15,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(text, style: textStyle, textAlign: TextAlign.left,),
                        SizedBox(height: 5,),
                        Text(text2, style: textStyle2, textAlign: TextAlign.left,),
                      ],
                    )),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey.withAlpha(250),),
                    SizedBox(width: 10,)
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),

          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0) ),
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    if (pressButton != null)
                      pressButton!();
                  }, // needed
                )),
          )
        ],)
    );
  }
}

// customer v1
// import 'package:flutter/material.dart';
//
// class Button197 extends StatelessWidget {
//   final Function()? pressButton;
//   final Color color;
//   final String text;
//   final String text2;
//   final double height;
//   final TextStyle textStyle;
//   final TextStyle? textStyle2;
//   final bool onlyBorder;
//   final Widget icon;
//   Button197({required this.icon, this.pressButton, this.text = "", this.color = Colors.grey, required this.textStyle, this.height = 45,
//     this.onlyBorder = false, this.text2 = "", this.textStyle2});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//           color: (onlyBorder) ? Colors.transparent : color,
//           border: (onlyBorder) ? Border.all(color: color) : null,
//         ),
//         child: Stack(children: [
//
//           Column(
//             children: [
//               SizedBox(height: 10,),
//               Row(
//                 children: <Widget>[
//                   SizedBox(width: 15,),
//                   icon,
//                   SizedBox(width: 15,),
//                   Expanded(child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(text, style: textStyle, textAlign: TextAlign.left,),
//                       SizedBox(height: 5,),
//                       Text(text2, style: textStyle2, textAlign: TextAlign.left,),
//                     ],
//                   )),
//                   Icon(Icons.arrow_forward_ios, color: Colors.grey.withAlpha(250),),
//                   SizedBox(width: 10,)
//                 ],
//               ),
//               SizedBox(height: 10,),
//             ],
//           ),
//
//           Positioned.fill(
//             child: Material(
//                 color: Colors.transparent,
//                 clipBehavior: Clip.hardEdge,
//                 shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0) ),
//                 child: InkWell(
//                   splashColor: Colors.grey[400],
//                   onTap: (){
//                     if (pressButton != null)
//                       pressButton!();
//                   }, // needed
//                 )),
//           )
//         ],)
//     );
//   }
// }
import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget displayImageWithCloseButton(double width, double height, String path, Function() onTap, Function() onDelete,
    {String type = "network", BoxFit fit = BoxFit.contain, Uint8List? imageBytes}){
  return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              if (type == "network")
                Image.network(path, fit: fit, errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ){
                  return Container(child: Image.asset("assets/noimage.png"));
                }),
              if (type == "memory" && imageBytes != null)
                Image.memory(imageBytes, fit: BoxFit.contain,),
              Container(
                margin: EdgeInsets.only(right: width/10, left: width/10),
                alignment: Alignment.topRight,
                child: IconButton(icon: Icon(Icons.cancel, color: Colors.red,),
                    onPressed: onDelete),
              )
            ],
          ))
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../abg_utils.dart';

// showImage(image, fit: BoxFit.cover),

showImage(String image, {double? width, double? height,
  BoxFit fit = BoxFit.contain, Alignment alignment = Alignment.center}){

  Widget _noImage = Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(10),
      child: Image.asset("assets/noimage.png", package: 'abg_utils', fit: BoxFit.contain,));

  // if (kIsWeb)
  //   return image.isNotEmpty
  //     ? Container(
  //       width: width,
  //       height: height,
  //       child: Image.network(image, fit: fit,
  //     errorBuilder: (
  //         BuildContext context,
  //         Object error,
  //         StackTrace? stackTrace,
  //         ) {
  //       return _noImage;
  //     })) : _noImage;

  return image.isNotEmpty ? CachedNetworkImage(
      imageUrl: image,
      errorWidget: (
          BuildContext context,
          String url,
          dynamic error,
          ){
        return _noImage;
      },
      placeholder: (context, url) =>
          UnconstrainedBox(child:
          Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: CircularProgressIndicator(color: aTheme.mainColor,),
          )),
      imageBuilder: (context, imageProvider) => Container(
        width: alignment == Alignment.center ? null : double.maxFinite,
        alignment: alignment,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
              )),
        ),
      )
  ) : _noImage;
}

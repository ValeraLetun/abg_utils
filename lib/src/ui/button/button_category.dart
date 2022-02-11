import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

buttonCategory(CategoryData item, double width, Function() _callback, {Decoration? decor}) {
  return Stack(
    children: [
      Positioned.fill(
          child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              decoration: decor,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: width, height: width,
                        child: showImage(item.serverPath),
                        // item.serverPath.isNotEmpty ? CachedNetworkImage(
                        //   imageUrl: item.serverPath,
                        //   imageBuilder: (context, imageProvider) =>
                        //       Container(
                        //         decoration: BoxDecoration(
                        //             image: DecorationImage(
                        //               image: imageProvider,
                        //               fit: BoxFit.contain,
                        //             )),
                        //       ),
                        // ) : Container(),)
                      )),
                  SizedBox(height: 8),
                  Container(
                    //width: 65,
                      child: Text(getTextByLocale(item.name, locale), style: aTheme.style11W600,
                        textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,))
                ],
              )
          )),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.2),
              onTap: (){
                _callback();
              }, // needed
            )),
      )
    ],
  );
}

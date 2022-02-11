import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

card47(String image,
    String title,
    String text2,
    String text3,
    List<ImageData> images,
    int stars,
    BuildContext context,
    TextDirection textDirection,
    {double? radius, Color iconStarsColor = Colors.orange,}
    ){

  var _tag = UniqueKey().toString();
  //dprint("card47  tag=$_tag");

  return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              if (image.isNotEmpty)
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: showImage(image, width: 40, height: 40, fit: BoxFit.cover)
                    // CachedNetworkImage(
                    //     imageUrl: image,
                    //     imageBuilder: (context, imageProvider) => Container(
                    //       width: double.maxFinite,
                    //       alignment: Alignment.bottomRight,
                    //       child: Container(
                    //         //width: height,
                    //         decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: imageProvider,
                    //               fit: BoxFit.cover,
                    //             )),
                    //       ),
                    //     )
                    // ),
                  ),
                ),
              SizedBox(width: 10,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: aTheme.style16W800,),
                      SizedBox(height: 5,),
                      Row(
                        children: [

                          Expanded(child: Text(text2, style: aTheme.style12W600Grey,)),
                          SizedBox(width: 10,),

                          Row(children: [
                            if (stars >= 1)
                              Icon(Icons.star, color: iconStarsColor, size: 16,),
                            if (stars < 1)
                              Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            if (stars >= 2)
                              Icon(Icons.star, color: iconStarsColor, size: 16,),
                            if (stars < 2)
                              Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            if (stars >= 3)
                              Icon(Icons.star, color: iconStarsColor, size: 16,),
                            if (stars < 3)
                              Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            if (stars >= 4)
                              Icon(Icons.star, color: iconStarsColor, size: 16,),
                            if (stars < 4)
                              Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            if (stars >= 5)
                              Icon(Icons.star, color: iconStarsColor, size: 16,),
                            if (stars < 5)
                              Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                          ]
                          ),

                          SizedBox(width: 10,),

                        ],
                      ),
                      SizedBox(height: 5,),
                    ],))

            ],
          ),

          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(text3, style: aTheme.style14W400,),
          ),

          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Wrap(
              spacing: 10,
              children: images.map((e) {
                return InkWell(
                  onTap: (){
                    if (kIsWeb)
                      openGalleryScreen(images, e);
                    else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryScreen(item: e, gallery: images,
                              tag: _tag, textDirection: textDirection,),
                          )
                      );
                    }
                  },
                  child: Hero(
                  tag: _tag,
                  child: UnconstrainedBox(
                      child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius ?? aTheme.radius),
                child: Container(
                        width: 60,
                        height: 60,
                        child: showImage(e.serverPath, width: 60, height: 60, fit: BoxFit.cover)

                        // CachedNetworkImage(
                        //     imageUrl: e.serverPath,
                        //     imageBuilder: (context, imageProvider) => Container(
                        //       width: double.maxFinite,
                        //       alignment: Alignment.bottomRight,
                        //       child: Container(
                        //         //width: height,
                        //         decoration: BoxDecoration(
                        //             image: DecorationImage(
                        //               image: imageProvider,
                        //               fit: BoxFit.cover,
                        //             )),
                        //       ),
                        //     )
                        // ),
                      )),
                )));
              }).toList(),
            ),
          ),

          Divider(color: Colors.grey,)
        ],
      )

  );
}



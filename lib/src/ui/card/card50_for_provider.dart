import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class Card50forProvider extends StatefulWidget {
  final List<CategoryData> category;
  final TextDirection direction;
  final String shadowText;
  final ProviderData provider;
  final String locale;

  Card50forProvider({
    this.shadowText = "", required this.category, required this.provider, required this.locale, required this.direction,
  });

  @override
  _Card50forProviderState createState() => _Card50forProviderState();
}

class _Card50forProviderState extends State<Card50forProvider>{

  @override
  Widget build(BuildContext context) {

    var imageUpperServerPath = widget.provider.logoServerPath;
    Widget image = showImage(imageUpperServerPath, fit: BoxFit.cover);
    // imageUpperServerPath.isNotEmpty ? CachedNetworkImage(
    //     imageUrl: imageUpperServerPath,
    //     imageBuilder: (context, imageProvider) => Container(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: imageProvider,
    //               fit: BoxFit.cover,
    //             )),
    //       ),
    //     )
    // ) : Container();

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: (aTheme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(aTheme.radius),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(aTheme.radius)),
                child: Stack(
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        child: image),
                    if (widget.shadowText.isNotEmpty)
                      Positioned.fill(
                          child: Container(
                            color: Colors.black.withAlpha(150),
                            child: Center(child: Text(widget.shadowText, style: aTheme.style12W600White,)),
                          ))
                  ],
                )),

            SizedBox(width: 10,),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10,),
                Container(
                  margin: widget.direction == TextDirection.ltr ? EdgeInsets.only(right: 20) : EdgeInsets.only(left: 20),
                    child: Text(getTextByLocale(widget.provider.name, widget.locale),
                      style: aTheme.style14W800, textAlign: TextAlign.start,)),
                SizedBox(height: 10,),
                Divider(color: aTheme.style14W800.color),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(widget.provider.address, style: aTheme.style10W400),)
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: aTheme.style14W800.color),
                SizedBox(height: 10,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: getCategories(widget.provider.category, widget.locale, widget.category).map((e) {
                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(aTheme.radius),
                      ),
                      child: Text(e, style: aTheme.style12W600White,),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
              ],
            ))

          ],
        )
    );
  }
}

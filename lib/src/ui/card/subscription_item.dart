import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

Widget subscriptionItem(double windowWidth, SubscriptionData item, String text, String stringFreeTrial, Function() onClickButton){
  appSettings.rightSymbol = true;
  return Container(
      width: windowWidth,
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(aTheme.radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: windowWidth,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(40),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(aTheme.radius), topRight: Radius.circular(aTheme.radius)),
            ),
            child: Text(getTextByLocale(item.text, locale), style: aTheme.style14W600White, textAlign: TextAlign.center,),
          ),
          if (item.price == 0)
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                    child: Text(stringFreeTrial, style: aTheme.style30W800White,)),
            ),
          if (item.price != 0)
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(),),
                  if (!appSettings.rightSymbol)
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (appSettings.rightSymbol)
                              Text("", style: aTheme.style14W600White,),
                            if (!appSettings.rightSymbol)
                              Text(appSettings.symbol, style: aTheme.style14W600White,),
                            Text("", style: aTheme.style14W600White,),
                          ],
                        )),
                  Text(item.price.toStringAsFixed(appSettings.digitsAfterComma), style: aTheme.style30W800White,),
                  if (appSettings.rightSymbol)
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appSettings.symbol, style: aTheme.style14W600White,),
                            Text("", style: aTheme.style14W600White,),
                          ],
                        )),
                  Expanded(child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("", style: aTheme.style14W600White,),
                          FittedBox(fit: BoxFit.scaleDown, child: Text(getTextByLocale(item.text2, locale), style: aTheme.style12W600White,)), /// month
                        ],
                      ))),
                ],
              )
          ),
          Container(
              width: windowWidth,
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: aTheme.darkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(aTheme.radius),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(getTextByLocale(item.desc, locale), style: aTheme.style12W400,),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: button2(text, item.color, onClickButton),
                  ),
                ],
              )
          ),

        ],
      )
  );
}

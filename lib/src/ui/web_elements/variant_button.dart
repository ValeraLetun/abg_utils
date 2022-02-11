import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

variantButton(Function() _redraw, String locale, GroupData item, PriceData item2){
  return InkWell(
      onTap: (){
        if (item2.stock == 0)
          return;
        for (var item3 in item.price){
          item3.selected = false;
          if (item2 == item3)
            item3.selected = true;
        }
        _redraw();
      },
      child: Container(
          child: item2.image.serverPath.isNotEmpty
              ? Container(width: 80, height: 80,
              child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: item2.selected && item2.stock != 0 ? Colors.red : Colors.grey, width: item2.selected ? 3 : 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Image.network(item2.image.serverPath, fit: BoxFit.contain,
                    color: item2.stock != 0 ? Colors.transparent : Colors.grey,
                    colorBlendMode: BlendMode.saturation,)))
              : Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: item2.selected && item2.stock != 0 ? Colors.red : Colors.grey, width: item2.selected ? 3 : 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(getTextByLocale(item2.name, locale),
                style: item2.stock != 0 ? aTheme.style12W400 : aTheme.style12W600Grey ,)))
  );
}

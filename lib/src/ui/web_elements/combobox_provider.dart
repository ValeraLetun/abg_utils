import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

String providerComboBoxValue = "not_select";

comboBoxProvider(
    String notSelect, /// "Not select"
    Function(String) callback,
    ){
  List<DropdownMenuItem<String>> menuItems = [];

  menuItems.add(DropdownMenuItem(
    child: Text(notSelect, style: aTheme.style14W400, maxLines: 1,), /// "Not select"
    value: "not_select",
  ),);

  for (var item in providers)
    menuItems.add(DropdownMenuItem(
      child: Text(getTextByLocale(item.name, locale), style: aTheme.style14W400, maxLines: 1,),
      value: item.id,
    ),);

  return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              dropdownColor: aTheme.darkMode ? Colors.black : Colors.white,
              isExpanded: true,
              value: providerComboBoxValue,
              items: menuItems,
              onChanged: (value) {
                providerComboBoxValue = value as String;
                callback(providerComboBoxValue);
              })
          )));
}
import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

List<ComboData> _paginData = [ComboData("5", "5"), ComboData("10", "10"), ComboData("15", "15"), ComboData("20", "20"),
  ComboData("30", "30"), ComboData("50", "50"), ComboData("100", "100"),];

addButtonsCopyExportSearch(List<Widget> list, Function() _copy, Function() _csv,
    Map<String, String> langCopyExportSearch, Function(String) _onSearch,
    {bool showSearchField = true}){
  if (langCopyExportSearch.isEmpty)
    return Container();

  setRange(String value) {
    pRange = int.parse(value);
    paginationSetPage(1);
    redrawMainWindow();
  }

  Widget stringSearch = Container(width: 220,
      child: textElement2(langCopyExportSearch["search"]!, "", null, (String val){  /// "Search",
        paginationSetPage(1);
        _onSearch(val);
      }));

  if (isMobile()) {
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: button2(langCopyExportSearch["copy"]!, aTheme.mainColor, _copy)), // "Copy",
        SizedBox(width: 10,),
        Expanded(child: button2(langCopyExportSearch["export_csv"]!, aTheme.mainColor, _csv)),// "Export to CSV",
      ],
    ));
    list.add(SizedBox(height: 10,));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(langCopyExportSearch["show"]!, style: aTheme.style14W400,), // "Show",
        Container(
            width: 120,
            child: Combo(inRow: true, text: "",
                data: _paginData,
                value: pRange.toString(),
                onChange: setRange
              // (String value){
              // _pRange = int.parse(value);
              // setState(() {});
              // },
            )
        ),
        SizedBox(width: 5,),
        Text(langCopyExportSearch["entries"]!, style: aTheme.style14W400,), // "entries",
      ],
    ));
    list.add(SizedBox(height: 10,));
    if (showSearchField)
      list.add(stringSearch); /// "Search",
  }else{
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        button2small(langCopyExportSearch["copy"]!, _copy), // "Copy",
        SizedBox(width: 10,),
        button2small(langCopyExportSearch["export_csv"]!, _csv), // "Export to CSV",
        Expanded(child: Container(),),
        //
        Text(langCopyExportSearch["show"]!, style: aTheme.style14W400,), // "Show",
        Container(
            width: 120,
            child: Combo(inRow: true, text: "",
                data: _paginData,
                value: pRange.toString(),
                onChange: setRange)
        ),
        SizedBox(width: 5,),
        Text(langCopyExportSearch["entries"]!, style: aTheme.style14W400,), // "entries",
        //
        SizedBox(width: 30,),
        if (showSearchField)
          stringSearch
      ],
    ));
  }
  list.add(SizedBox(height: 10,));
}
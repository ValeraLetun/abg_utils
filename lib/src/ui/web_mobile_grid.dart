import 'package:flutter/material.dart';

import '../../abg_utils.dart';

webMobileGrid(double windowWidth, List<Widget> list,
    List<Widget> source, List<int> size){

  //print("windowWidth=$windowWidth");
  List<Widget> row = [];
  int rowSize = 0;

  for (var pair in zip([source, size])){
    var s = pair[0] as Widget; // source
    var c = pair[1] as int; // size

    if (windowWidth < 400){ // mobile
      list.add(s);
      list.add(SizedBox(height: 10,));
    }
    if (windowWidth >= 400 && windowWidth <= 800){ // mobile
      if (c == 1) {
        if (rowSize + c <= 2) {
          if (rowSize != 0)
            row.add(SizedBox(width: 10,));
          row.add(Expanded(flex: c, child: s,));
          rowSize += c;
        } else {
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          row.add(Expanded(flex: c, child: s,));
          rowSize = c;
        }
      }
      if (c == 2){
        if (rowSize + c <= 2) {
          if (rowSize != 0)
            row.add(SizedBox(width: 10,));
          row.add(Expanded(flex: c, child: s,));
          rowSize += c;
        }else{
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          row.add(Expanded(flex: c, child: s,));
          rowSize = c;
        }
      }
      if (c == 3 || c == 4) {
        if (row.isNotEmpty) {
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          rowSize = 0;
        }
        list.add(s);
        list.add(SizedBox(height: 10,));
      }
    }

    if (windowWidth > 800){
      /*
          Добавляем в List View / Row в зависимости от размера (size)
          размер от 1,2,3,4
          если 4 Добавляем сразу
       */

      if (c == 4) {
        if (row.isNotEmpty) {
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          rowSize = 0;
        }
        list.add(s);
        list.add(SizedBox(height: 10,));
      }

      if (c == 1) {
        if (rowSize + c <= 4) {
          if (rowSize != 0)
            row.add(SizedBox(width: 10,));
          row.add(Expanded(flex: c, child: s,));
          rowSize += c;
        } else {
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          row.add(Expanded(flex: c, child: s,));
          rowSize = c;
        }
      }
      if (c == 2){
        if (rowSize + c <= 4) {
          if (rowSize != 0)
            row.add(SizedBox(width: 10,));
          row.add(Expanded(flex: c, child: s,));
          rowSize += c;
        }else{
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          row.add(Expanded(flex: c, child: s,));
          rowSize = c;
        }
      }
      if (c == 3){
        if (rowSize + c <= 4) {
          if (rowSize != 0)
            row.add(SizedBox(width: 10,));
          row.add(Expanded(flex: c, child: s,));
          rowSize += c;
        }else{
          list.add(Row(children: row,));
          list.add(SizedBox(height: 10,));
          row = [];
          row.add(Expanded(flex: c, child: s,));
          rowSize = c;
        }
      }
    }
  }
  if (row.isNotEmpty) {
    list.add(Row(children: row,));
    list.add(SizedBox(height: 10,));
  }
}

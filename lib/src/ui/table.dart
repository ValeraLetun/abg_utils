import 'package:flutter/material.dart';

import '../../abg_utils.dart';

// Widget itemColumnWithSort(String _sortBy, String _nameAsc, String _nameDesc,
//     String _text, Function() _callbackAsc, Function() _callbackDesc){
//   return Expanded(child: Row(children: [
//     IconButton(onPressed: (){
//       if (_sortBy == _nameAsc)
//         _callbackAsc();
//       else
//         _callbackDesc();
//     }, icon: Icon(_sortBy == _nameAsc ? Icons.arrow_upward : Icons.arrow_downward_sharp,
//         color: _sortBy == _nameAsc || _sortBy == _nameDesc ? Colors.black : Colors.grey )),
//     Text(_text, style: aTheme.style14W400Grey),
//   ],));
// }


Widget itemColumnWithSort(String _sortBy, String _nameAsc, String _nameDesc,
    String _text, Function(String) _callback){
  return Expanded(child: Row(children: [
    IconButton(onPressed: (){
      if (_sortBy == _nameAsc)
        _callback(_nameDesc);
      else
        _callback(_nameAsc);
    }, icon: Icon(_sortBy == _nameAsc ? Icons.arrow_upward : Icons.arrow_downward_sharp,
        color: _sortBy == _nameAsc || _sortBy == _nameDesc ? Colors.black : Colors.grey )),
    Text(_text, style: aTheme.style14W400Grey),
  ],));
}


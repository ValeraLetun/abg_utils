import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

plusMinus(String id, int count,
  Function(String id, int count) callback, {bool countMayBeNull = false}) {
  // dprint("plusMinus item.count=$count $id");
  var _color = count > 1 ? aTheme.mainColor : Colors.grey;
  if (countMayBeNull)
    _color = aTheme.mainColor;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
        child: InkWell(
            onTap: () {
              if (count > 1)
                count--;
              else
                if (countMayBeNull && count == 1)
                  count--;
              callback(id, count);
            },
            child: Icon(Icons.exposure_minus_1, size: 15, color: Colors.white,)),
      ),
      SizedBox(width: 5,),
      Text(count.toString(), style: aTheme.style14W800),
      SizedBox(width: 5,),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: aTheme.mainColor,
          shape: BoxShape.circle,
        ),
        child: InkWell(
            onTap: () {
              count++;
              // dprint("plusMinus item.count++=$count $id");
              callback(id, count);
            },
            child: Icon(Icons.plus_one, size: 15, color: Colors.white,)),
      ),
    ],
  );
}


//
// plusMinus2(Function() _redraw, AddonData item, {bool countMayBeNull = false}) {
//   // print("plusMinus2 ${item.needCount} ${item.needCount > 1 ? theme.mainColor : Colors.grey}");
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         padding: EdgeInsets.all(3),
//         decoration: BoxDecoration(
//           color: item.needCount > 1 ? theme.mainColor : Colors.grey,
//           shape: BoxShape.circle,
//         ),
//         child: InkWell(
//             onTap: () {
//               if (item.needCount > 1){
//                 item.needCount--;
//                 item.selected = item.needCount <= 0 ? false : true;
//                 _redraw();
//               }
//               if (countMayBeNull && item.needCount == 1){
//                 item.needCount--;
//                 item.selected = item.needCount <= 0 ? false : true;
//                 _redraw();
//               }
//             },
//             child: Icon(Icons.exposure_minus_1, size: 15, color: Colors.white,)),
//       ),
//       SizedBox(width: 5,),
//       Text(item.needCount.toString(), style: theme.style14W800),
//       SizedBox(width: 5,),
//       Container(
//         padding: EdgeInsets.all(3),
//         decoration: BoxDecoration(
//           color: theme.mainColor,
//           shape: BoxShape.circle,
//         ),
//         child: InkWell(
//             onTap: () {
//               item.needCount++;
//               item.selected = item.needCount <= 0 ? false : true;
//               _redraw();
//             },
//             child: Icon(Icons.plus_one, size: 15, color: Colors.white,)),
//       ),
//     ],
//   );
// }
//

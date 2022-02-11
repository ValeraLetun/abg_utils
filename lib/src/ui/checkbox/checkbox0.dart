import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

checkBox0(Color color, bool init, Function(bool?) callback){
  return SizedBox(
    height: 24.0,
    width: 24.0,
    child: Theme(
      data: Theme.of(buildContext).copyWith(
      unselectedWidgetColor: Colors.grey,
      disabledColor: Colors.grey
  ),
  child: Checkbox(
        value: init,
        activeColor: color,
        onChanged: callback
      ),
  ));
}

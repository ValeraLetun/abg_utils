import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';

class _PopupWindow{
  bool comboPopupShow;
  GlobalKey popupKey;
  ComboData2 data;
  Function(String) setValue;
  double dialogPositionX = 0;
  double dialogPositionY = 0;
  double dialogWidth = 0;
  bool selectMany;
  final ScrollController controllerScroll = ScrollController();
  final controllerSearch = TextEditingController();
  String searchText = "";

  _PopupWindow(this.popupKey, {this.comboPopupShow = false, required this.data,
      required this.setValue, this.selectMany = false});
}

bool _isPresent(GlobalKey _popupKey){
  for (var item in _popups)
    if (item.popupKey == _popupKey)
      return true;
  return false;
}

_PopupWindow? _getCurrentVisible(){
  for (var item in _popups)
    if (item.comboPopupShow)
      return item;
  return null;
}

closeAllPopups(){
  for (var item in _popups)
    if (item.comboPopupShow == true) {
      item.comboPopupShow = false;
      item.setValue(item.data.value);
    }
}

_PopupWindow _getCurrent(GlobalKey _popupKey){
  for (var item in _popups)
    if (item.popupKey == _popupKey)
      return item;
  return _PopupWindow(GlobalKey(), data: ComboData2("", []), setValue: (String _){});
}

List<_PopupWindow> _popups = [];
String _stringSearchText = "";

Widget popupWidget(GlobalKey _popupKey, ComboData2 data, Function(String) setValue,
    String stringSearchText,
    {selectMany = false}){

  _stringSearchText = stringSearchText;

  if (!_isPresent(_popupKey))
    _popups.add(_PopupWindow(_popupKey, data: data, setValue: setValue, selectMany: selectMany));

  _PopupWindow current = _getCurrent(_popupKey);
  current.setValue = setValue;
  current.data = data;
  //
  String _text = "";
  String _email = "";
  if (current.selectMany){
    for (var item in data.data){
      if (item.checkSelected) {
        if (_text.isNotEmpty)
          _text += " | ";
        _text += item.text;
      }
    }
  }
  if (!current.selectMany || _text.isEmpty) {
    for (var item in data.data)
      if (item.id == data.value) {
        _text = item.text;
        _email = item.email;
      }
  }

  return Container(
      key: _popupKey,
      height: 40,
      decoration: BoxDecoration(
        // color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(aTheme.radius),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: (){
          _openListPopup(current);
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
          children: [
            Expanded(child: Row(
              children: [
                Expanded(child: Text(_text, style: aTheme.style14W400, overflow: TextOverflow.ellipsis,)),
                SizedBox(width: 10,),
                Text(_email, style: aTheme.style12W600Grey,),
              ],
            )),
            Icon(Icons.arrow_downward_sharp, color: Colors.black, size: 20,)
          ],
        )),
      ),
  );
}

_openListPopup(_PopupWindow current){

  for (var item in _popups)
      item.comboPopupShow = false;

  final RenderBox? renderBox = current.popupKey.currentContext!.findRenderObject() as RenderBox;
  Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
  current.dialogPositionY = position.dy;
  current.dialogPositionX = position.dx;
  if (windowWidth - position.dx < 200)
    current.dialogPositionX = windowWidth - 200;
  current.dialogWidth = renderBox.size.width;
  //
  if (current.dialogPositionY > windowHeight/2)
    current.dialogPositionY = windowHeight/2;
  //
  current.comboPopupShow = true;
  redrawMainWindow();
}

_item(ComboData item, _PopupWindow current){
  return Stack(
    children: [

      Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(child: Text(item.text, style: item.selected ? aTheme.style14W800 : aTheme.style14W400, overflow: TextOverflow.ellipsis,)),
              SizedBox(width: 20,),
              if (item.email.isNotEmpty)
                Expanded(child: Text(item.email, style: aTheme.style12W600Grey, overflow: TextOverflow.ellipsis,)),
              if (current.selectMany)
                CheckBox12((){return item.checkSelected;},
                (bool val){
                  if (val && item.id != "1")
                    for (var v in current.data.data)
                      if (v.id == "1")
                        v.checkSelected = false;

                  if (val && item.id == "1") {
                    for (var v in current.data.data)
                      v.checkSelected = false;
                  }
                  item.checkSelected = val;
                  redrawMainWindow();
                })
            ],
          )),

      Positioned.fill(
        child: Container(
          margin: (current.selectMany) ? EdgeInsets.only(right: 100) : null,
            // color: Colors.red,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.2),
              onTap: (){
                current.setValue(item.id);
                current.comboPopupShow = false;
                redrawMainWindow();
              }, // needed
            )),
      )
    ],
  );
}

showPopup(){

  var current = _getCurrentVisible();

  // _redraw = redraw;
  if (current == null)
    return Container();

    if (current.dialogPositionY == 0)
      return Container();
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));
    list.add(Container(
      margin: EdgeInsets.all(10),
      child: Edit41web(controller: current.controllerSearch,
      hint: _stringSearchText, /// search
      onChange: (String val){
        current.searchText = val;
        redrawMainWindow();
      }
    )));
    list.add(SizedBox(height: 10,));

    for (var item in current.data.data) {
      if (item.divider){
        list.add(Divider(color: (aTheme.darkMode) ? Colors.white : Colors.grey,));
        continue;
      }
      if (current.searchText.isNotEmpty) {
        if (item.text.contains(current.searchText) || item.email.contains(current.searchText))
          list.add(_item(item, current));
      }
      else
        list.add(_item(item, current));
    }

    list.add(SizedBox(height: 10,));

    return Container(
      decoration: BoxDecoration(
        color: (aTheme.darkMode) ? Colors.black : Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(80)),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: current.dialogPositionY, left: current.dialogPositionX),
      width: current.dialogWidth,
      child: ListView(
        controller: current.controllerScroll,
        shrinkWrap: true,
        children: list,
      ),);
}

ComboData2 getComboData(
    String type, // "providers"
    String? stringAll, ///  strings.get(254)  /// "All"
    {ComboData2? providersForServices, String? stringOwner} ///  strings.get(457)  /// "Global (owner) item",
  ){

  ComboData2 combo = ComboData2("", []);

  if (stringAll != null) {
    combo.data.add(ComboData(stringAll, "1"));
    combo.value = "1";
    if (stringOwner != null)
      combo.data.add(ComboData(stringOwner, "2"));
    combo.data.add(ComboData("", "", divider: true));
  }else
    if (stringOwner != null)
      combo.data.add(ComboData(stringOwner, "2"));

  if (type == "users")
    for (var item in listUsers)
      combo.data.add(ComboData(item.name, item.id));

  if (type == "providers")
    for (var item in providers)
      combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));

  if (type == "category")
    for (var item in categories)
      combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));

  if (type == "service") {
    if (providersForServices == null) {
      for (var item in product)
        combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
    }else{
      for (var provider in providersForServices.data) {
        if (!provider.checkSelected)
          continue;
        for (var item in product) {
          if (provider.id == '1'){
            combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
            continue;
          }
          if (item.providers.contains(provider.id)) {
            if (!_isComboContain(combo, item.id))
              combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
          }
        }
      }
    }
  }

  if (type == "article")
    if (providersForServices == null) {
      for (var item in productDataCache)
        combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
    }else{
      for (var provider in providersForServices.data) {
        if (!provider.checkSelected)
          continue;
        if (provider.id == '2'){
          for (var item in productDataCache)
            if (item.providers.isEmpty)
              if (!_isComboContain(combo, item.id))
                combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
        }
        for (var item in productDataCache) {
          if (provider.id == '1'){
            combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
            continue;
          }
          if (item.providers.contains(provider.id)) {
            if (!_isComboContain(combo, item.id))
              combo.data.add(ComboData(getTextByLocale(item.name, locale), item.id));
          }
        }
      }
    }

  return combo;
}

_isComboContain(ComboData2 combo, String id){
  for (var item in combo.data)
    if (item.id == id)
      return true;
    return false;
}

class ComboData2{
  List<ComboData> data;
  String value;
  ComboData2(this.value, this.data);
}

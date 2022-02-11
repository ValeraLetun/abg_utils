import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class TreeInCategory extends StatefulWidget {
  final Function(CategoryData value)? deleteDialog;
  final Function(CategoryData value) select;
  final String stringCategoryTree; /// strings.get(232) /// Category tree
  final String? stringDelete; /// strings.get(62) /// "Delete",
  // provider screen
  final bool showDelete;
  final bool showCheckBoxes;
  final List<String> Function()? getSelectList;
  //
  final String? stringOnlySelected;
  final bool useKey;
  //
  final List<String>? permittedList;

  const TreeInCategory({Key? key, this.deleteDialog, required this.select,
    required this.stringCategoryTree, this.stringDelete,
    this.showDelete = true, this.showCheckBoxes = false, this.getSelectList,
    this.stringOnlySelected, this.useKey = true, this.permittedList}) : super(key: key);
  @override
  _TreeInCategoryState createState() => _TreeInCategoryState();
}

class _TreeInCategoryState extends State<TreeInCategory> {

  final ScrollController _controllerTree = ScrollController();

  List<String> selectCategories = [];

  @override
  void dispose() {
    _controllerTree.dispose();
    super.dispose();
  }

  bool _onlySelected = false;

  @override
  Widget build(BuildContext context) {

    if (widget.getSelectList != null)
      selectCategories = widget.getSelectList!();

    List<Widget> list2 = [];
    list2.add(SizedBox(height: 10,));
    list2.add(SelectableText(widget.stringCategoryTree, /// Category tree
      style: aTheme.style14W800,));
    list2.add(SizedBox(height: 10,));

    if (widget.stringOnlySelected != null){
      list2.add(checkBox1a(context, widget.stringOnlySelected!, /// "Only selected"
          aTheme.mainColor, aTheme.style14W400, _onlySelected,
              (val) {
            if (val == null) return;
            _onlySelected = val;
            setState(() {});
          }));
      list2.add(SizedBox(height: 10,));
    }

    getListTree(list2, "", 10,);

    return treeWindow(list2);
  }

  String selectId = "";

  // _listener(){
  //   selectId = currentCategory.id;
  //   var currentContext = currentCategory.dataKey2.currentContext;
  //   if (currentContext != null){
  //     Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
  //   }
  // }

  treeWindow(List<Widget> list2){
    return Container(
      decoration: BoxDecoration(
        color: (aTheme.darkMode) ? colorCardDark : colorCardGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: windowHeight*0.4,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Scrollbar(
        controller: _controllerTree,
        isAlwaysShown: true,
        child: ListView(
          controller: _controllerTree,
          children: list2,
        ),
      )
    );
  }

  getListTree(List<Widget> list2, String parent, double align){
    for (var item in categories){
      if (widget.permittedList != null)
        if (!widget.permittedList!.contains(item.id))
          continue;
      if (item.parent == parent) {
        if (_onlySelected && !selectCategories.contains(item.id))
          continue;
        Widget _image = (item.serverPath.isNotEmpty) ? showImage(item.serverPath, width: 40, height: 40)
            : Container();
        list2.add(Stack(
          children: [
            Container(
                key: widget.useKey ? item.dataKey2 : null,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: align, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: (selectId == item.id) ? aTheme.mainColor.withAlpha(120) : (aTheme.darkMode) ? Colors.black
                      : colorCardGreenGrey,
                  borderRadius: BorderRadius.circular(aTheme.radius),
                ),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      child: _image),
                  SizedBox(width: 20,),
                  Expanded(child: Text(getTextByLocale(item.name, locale),
                    style: aTheme.style14W400,)),
                ],)),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      widget.select(item);
                    },
                  )),
            ),
            if (widget.showDelete)
            Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.centerRight,
                  child: button2small(widget.stringDelete != null ? widget.stringDelete! : "Delete", (){ /// "Delete",
                      if (widget.deleteDialog != null)
                        widget.deleteDialog!(item);
                    }, color: Colors.red.withAlpha(150)),
                )
            ),
            if (widget.showCheckBoxes)
              Positioned.fill(
                  child: Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      alignment: Alignment.centerRight,
                      child: checkBox0(aTheme.mainColor, selectCategories.contains(item.id), (val) {
                        widget.select(item);
                      })
                  )
              )
          ],
        )
        );
        getListTree(list2, item.id, align+30);
      }
    }
  }
}

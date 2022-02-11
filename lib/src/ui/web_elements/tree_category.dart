// import 'dart:math';
// import 'package:abg_utils/abg_utils.dart';
// import 'package:flutter/material.dart';
//
// class TreeCategory extends StatefulWidget {
//   final String onlySelectedString; /// "Only selected"
//   final String locale;
//   final List<CategoryData> category;
//
//   const TreeCategory({Key? key, required this.onlySelectedString,
//     required this.locale, required this.category}) : super(key: key);
//
//   @override
//   _TreeCategoryState createState() => _TreeCategoryState();
// }
//
// class _TreeCategoryState extends State<TreeCategory> {
//
//   double windowWidth = 0;
//   double windowHeight = 0;
//   double windowSize = 0;
//   final ScrollController _controllerTree = ScrollController();
//
//   @override
//   void dispose() {
//     _controllerTree.dispose();
//     super.dispose();
//   }
//
//   bool _onlySelected = false;
//
//   _redraw(){
//     if (mounted)
//       setState(() {
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     windowWidth = MediaQuery.of(context).size.width;
//     windowHeight = MediaQuery.of(context).size.height;
//     windowSize = min(windowWidth, windowHeight);
//
//     List<Widget> list2 = [];
//
//     list2.add(SizedBox(height: 10,));
//     list2.add(checkBox1a(context, widget.onlySelectedString, /// "Only selected"
//         aTheme.mainColor, aTheme.style14W400, _onlySelected,
//             (val) {
//           if (val == null) return;
//           _onlySelected = val;
//           _redraw();
//         }));
//     list2.add(SizedBox(height: 10,));
//
//     getListTree(list2, "", 0,);
//
//     return treeWindow(list2);
//   }
//
//   String selectId = "";
//
//   treeWindow(List<Widget> list2){
//     return Container(
//             decoration: BoxDecoration(
//               color: (aTheme.darkMode) ? Colors.black : Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             //width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
//             height: windowHeight*0.5,
//             padding: EdgeInsets.only(left: 20, right: 20),
//             child: Scrollbar(
//               controller: _controllerTree,
//               isAlwaysShown: true,
//               child: ListView(
//                 controller: _controllerTree,
//                 children: list2,
//               ),
//             )
//     );
//   }
//
//   getListTree(List<Widget> list2, String parent, double align){
//     // List<CategoryData> _category = context.watch<MainModel>().category;
//
//     for (var item in widget.category){
//       if (item.parent == parent) {
//         if (_onlySelected && !item.select) {
//           getListTree(list2, item.id, align+30);
//           continue;
//         }
//         Widget _image = (item.serverPath.isNotEmpty) ? Image.network(item.serverPath, fit: BoxFit.contain) : Container();
//         list2.add(Stack(
//           children: [
//             Container(
//                 key: item.dataKey2,
//                 padding: EdgeInsets.all(10),
//                 margin: EdgeInsets.only(left: align, top: 5, bottom: 5),
//                 decoration: BoxDecoration(
//                   color: (selectId == item.id) ? aTheme.mainColor.withAlpha(120) : (aTheme.darkMode) ? Colors.black : Color(0xffddf1f3),
//                   borderRadius: BorderRadius.circular(aTheme.radius),
//                 ),
//                 child: Row(children: [
//                   Container(
//                       width: 40,
//                       height: 40,
//                       child: _image),
//                   SizedBox(width: 20,),
//                   Expanded(child: Text(getTextByLocale(item.name, widget.locale), style: aTheme.style14W400,)),
//                 ],)),
//             Positioned.fill(
//               child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     splashColor: Colors.grey[400],
//                     onTap: (){
//                       //Provider.of<ProviderModel>(context,listen:false).setSelectedId(item);
//                     },
//                   )),
//             ),
//             Positioned.fill(
//                 child: Container(
//                   margin: EdgeInsets.only(left: 40, right: 40),
//                   alignment: Alignment.centerRight,
//                  child: checkBox0(aTheme.mainColor, item.select, (val) {
//                    item.select = val!;
//                    // Provider.of<MainModel>(context,listen:false).service.changeCategory();
//                    setState(() {});
//                  })
//                 )
//             )
//           ],
//         )
//         );
//         getListTree(list2, item.id, align+30);
//       }
//     }
//   }
// }

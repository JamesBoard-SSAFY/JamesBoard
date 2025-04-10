import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../item/ItemCommonFilter.dart';

class BottomSheetCommonFilter extends StatefulWidget {
  final List<String> items;
  final String? initialValue;

  const BottomSheetCommonFilter({
    super.key,
    required this.items,
    this.initialValue,
  });

  @override
  _BottomSheetCommonFilterState createState() =>
      _BottomSheetCommonFilterState();
}

class _BottomSheetCommonFilterState extends State<BottomSheetCommonFilter> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      int index = widget.items.indexOf(widget.initialValue!);
      selectedIndex = index != -1 ? index : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = 60.0;
    final minItemCount = 1;
    final headerHeight = 72.0;
    final buttonHeight = 60.0;
    final paddingHeight = 20.0;

    final listHeight = widget.items.length * itemHeight;
    final totalHeight = headerHeight + listHeight + buttonHeight;
    final maxSheetHeight = screenHeight * 0.8;

    final sheetHeight =
        totalHeight > maxSheetHeight ? maxSheetHeight : totalHeight;
    final listViewHeight = sheetHeight - headerHeight - buttonHeight;

    // final totalExtraHeight = headerHeight + buttonHeight + paddingHeight;
    // final maxListHeight = widget.items.length * itemHeight;
    // final minListHeight = (minItemCount * itemHeight).clamp(0, maxListHeight);
    //
    // final calculatedHeight =
    //     (maxListHeight + totalExtraHeight).clamp(0, screenHeight);
    //
    // final maxChildSize = (calculatedHeight / screenHeight).clamp(0.3, 0.8);
    // final minChildSize = (minListHeight + totalExtraHeight) / screenHeight;

    // return DraggableScrollableSheet(
    //   initialChildSize: maxChildSize,
    //   minChildSize: minChildSize,
    //   maxChildSize: maxChildSize,
    //   expand: false,
    //   builder: (context, scrollController) {
    //     return Container(
    //       decoration: BoxDecoration(
    //         color: secondaryBlack,
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(8),
    //           topRight: Radius.circular(8),
    //         ),
    //       ),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.symmetric(vertical: 20),
    //             child: Text(
    //               '옵션 선택',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontFamily: FontString.pretendardBold,
    //                 color: mainGrey,
    //               ),
    //             ),
    //           ),
    //           Flexible(
    //             child: LayoutBuilder(
    //               builder: (context, constraints) {
    //                 final listHeight = widget.items.length * itemHeight;
    //                 final availableHeight = constraints.maxHeight;
    //
    //                 return ConstrainedBox(
    //                   constraints: BoxConstraints(
    //                     maxHeight: listHeight > availableHeight
    //                         ? availableHeight
    //                         : listHeight,
    //                   ),
    //                   child: ListView.builder(
    //                     controller: scrollController,
    //                     itemCount: widget.items.length,
    //                     itemBuilder: (context, index) {
    //                       return Container(
    //                         decoration: BoxDecoration(
    //                           color: mainRed,
    //                           border: Border.all(color: mainBlack),
    //                         ),
    //                         child: ItemCommonFilter(
    //                           title: widget.items[index],
    //                           checkIconPath: IconPath.filterCheck,
    //                           isSelected: selectedIndex == index,
    //                           onTap: () {
    //                             setState(() {
    //                               selectedIndex = index;
    //                             });
    //                           },
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),
    //           GestureDetector(
    //             onTap: () {
    //               Navigator.pop(
    //                 context,
    //                 selectedIndex != null ? widget.items[selectedIndex!] : null,
    //               );
    //             },
    //             behavior: HitTestBehavior.opaque,
    //             child: Container(
    //               height: 60,
    //               decoration: BoxDecoration(
    //                 color: secondaryBlack,
    //                 border: Border(
    //                   top: BorderSide(color: mainGrey, width: 1.0),
    //                 ),
    //               ),
    //               padding: EdgeInsets.symmetric(vertical: 20),
    //               alignment: Alignment.center,
    //               child: Text(
    //                 AppString.apply,
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: mainWhite,
    //                   fontFamily: FontString.pretendardBold,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: headerHeight,
            alignment: Alignment.center,
            child: Text(
              '옵션 선택',
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontString.pretendardBold,
                color: mainGrey,
              ),
            ),
          ),
          Container(
            height: listViewHeight,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: itemHeight,
                  alignment: Alignment.center,
                  // decoration: BoxDecoration(
                  //   color: mainRed,
                  //   border: Border.all(color: mainBlack),
                  // ),
                  child: ItemCommonFilter(
                    title: widget.items[index],
                    checkIconPath: IconPath.filterCheck,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
                selectedIndex != null ? widget.items[selectedIndex!] : null,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: buttonHeight,
              // margin: EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: secondaryBlack,
                border: Border(
                  top: BorderSide(color: mainGrey, width: 1.0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                AppString.apply,
                style: TextStyle(
                  fontSize: 16,
                  color: mainWhite,
                  fontFamily: FontString.pretendardBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

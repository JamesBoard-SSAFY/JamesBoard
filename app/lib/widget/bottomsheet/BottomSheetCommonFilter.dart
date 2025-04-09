import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../item/ItemCommonFilter.dart';

class BottomSheetCommonFilter extends StatefulWidget {
  final List<String> items;
  final String? initialValue;

  const BottomSheetCommonFilter(
      {super.key, required this.items, this.initialValue});

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
    final itemHeight = 64;
    final minItemCount = 1;
    final headerHeight = 60.0;
    final buttonHeight = 80.0;
    final paddingHeight = 20.0;

    final totalExtraHeight = headerHeight + buttonHeight + paddingHeight;
    final maxListHeight = widget.items.length * itemHeight;
    final minListHeight = (minItemCount * itemHeight).clamp(0, maxListHeight);

    final calculatedHeight =
        (maxListHeight + totalExtraHeight).clamp(0, screenHeight);

    final maxChildSize = (calculatedHeight / screenHeight).clamp(0.3, 0.8);
    final minChildSize = (minListHeight + totalExtraHeight) / screenHeight;

    return DraggableScrollableSheet(
      initialChildSize: maxChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: secondaryBlack,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '옵션 선택',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontString.pretendardBold,
                    color: mainGrey,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController, // 스크롤 컨트롤러 추가
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return ItemCommonFilter(
                      title: widget.items[index],
                      checkIconPath: IconPath.filterCheck,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(
                      context,
                      selectedIndex != null
                          ? widget.items[selectedIndex!]
                          : null);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryBlack,
                    border: Border(
                      top: BorderSide(color: mainGrey, width: 1.0),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(vertical: 20),
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
      },
    );
  }
}

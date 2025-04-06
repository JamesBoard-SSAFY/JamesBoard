import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../item/ItemCommonFilter.dart';

class BottomSheetCommonFilter extends StatefulWidget {
  final List<String> items;
  final String? initialValue; // 초기 선택값

  const BottomSheetCommonFilter(
      {super.key, required this.items, this.initialValue});

  @override
  _BottomSheetCommonFilterState createState() =>
      _BottomSheetCommonFilterState();
}

class _BottomSheetCommonFilterState extends State<BottomSheetCommonFilter> {
  int? selectedIndex; // 선택된 인덱스
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = 90.0; // 아이템 하나의 높이 (패딩 포함)
    final minItemCount = 2; // 최소한 표시할 아이템 개수
    final maxListHeight = widget.items.length * itemHeight;
    final minListHeight =
        (minItemCount * itemHeight).clamp(100.0, maxListHeight);
    final maxSheetHeight = screenHeight * 0.9;

    final calculatedHeight =
        maxListHeight > maxSheetHeight ? maxSheetHeight : maxListHeight;
    final maxChildSize = calculatedHeight / screenHeight;
    final minChildSize = minListHeight / screenHeight; // 최소 크기 설정

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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '옵션 선택',
                  style: TextStyle(
                    fontSize: 18,
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

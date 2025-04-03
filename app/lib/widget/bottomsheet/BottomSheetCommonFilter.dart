import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    // // 초기값이 있으면 해당 값의 인덱스를 찾아 selectedIndex에 설정
    // selectedIndex = widget.initialValue != null
    //     ? widget.items.indexOf(widget.initialValue!)
    //     : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                fontSize: 18,
                fontFamily: FontString.pretendardBold,
                color: mainGrey,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ItemCommonFilter(
                  title: widget.items[index],
                  checkIconPath: IconPath.filterCheck,
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // 선택 상태 업데이트 (닫기 전까지 유지)
                    });
                  },
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // 닫을 때만 선택된 값 전달
              Navigator.pop(context,
                  selectedIndex != null ? widget.items[selectedIndex!] : null);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                color: secondaryBlack,
                border: Border(
                  top: BorderSide(color: mainGrey, width: 1.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                '닫기',
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

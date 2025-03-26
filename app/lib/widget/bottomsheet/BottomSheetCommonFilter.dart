import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../item/ItemCommonFilter.dart';

class BottomSheetCommonFilter extends StatefulWidget {
  const BottomSheetCommonFilter({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  _BottomSheetCommonFilterState createState() => _BottomSheetCommonFilterState();
}

class _BottomSheetCommonFilterState extends State<BottomSheetCommonFilter> {
  int? selectedIndex; // 선택된 항목의 인덱스

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          color: secondaryBlack,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'BottomSheet',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'PretendardBold',
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
                  checkIconPath: 'assets/image/icon_filter_check.svg',
                  isSelected: selectedIndex == index, // 선택 상태 전달
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // 선택된 항목의 인덱스를 업데이트
                    });
                  },
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: const BoxDecoration(
                color: secondaryBlack,
                border: Border(
                  top: BorderSide(
                    color: mainGrey,
                    width: 1.0
                  )
                )
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                '닫기',
                style: TextStyle(
                  fontSize: 16,
                  color: mainWhite,
                  fontFamily: 'PretendardBold'
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
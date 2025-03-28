import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/feature/user/widget/item/ItemUserGenrePercentInfo.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../widget/appbar/DefaultCommonAppBar.dart';
import '../../../widget/item/ItemCommonGameRank.dart';

class MyPagePlayTime extends StatefulWidget {
  final String title;
  final List<Map<String, String>> gameData;

  const MyPagePlayTime({
    super.key,
    required this.title,
    required this.gameData,
  });

  @override
  State<MyPagePlayTime> createState() => _MyPagePlayTimeState();
}

class _MyPagePlayTimeState extends State<MyPagePlayTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ItemCommonGameRank(gameData: widget.gameData),
        ),
      ),
    );
  }
}

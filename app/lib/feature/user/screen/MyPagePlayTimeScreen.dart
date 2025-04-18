import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppData.dart';
import 'package:jamesboard/datasource/model/response/MyPage/TopPlayedGame.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../widget/appbar/DefaultCommonAppBar.dart';
import '../../../widget/item/ItemCommonGameRank.dart';
import '../../../widget/physics/CustomScrollPhysics.dart';

class MyPagePlayTimeScreen extends StatefulWidget {
  final String title;
  final List<TopPlayedGame> gameData;

  const MyPagePlayTimeScreen({
    super.key,
    required this.title,
    required this.gameData,
  });

  @override
  State<MyPagePlayTimeScreen> createState() => _MyPagePlayTimeScreenState();
}

class _MyPagePlayTimeScreenState extends State<MyPagePlayTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: SingleChildScrollView(
        physics: CustomScrollPhysics(scrollSpeedFactor: AppData.scrollSpeed),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/mission/widget/ImageItemMissionList.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';

class MissionListScreen extends StatelessWidget {
  final String title;

  MissionListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemCount: AppDummyData.imageAssets.length,
        itemBuilder: (context, index) {
          return ImageItemMissionList(
              imageUrl: AppDummyData.imageAssets[index]);
        },
      ),
    );
  }
}

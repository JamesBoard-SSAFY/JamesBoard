import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/mission/screen/MissionDetailScreen.dart';
import 'package:provider/provider.dart';

import '../viewmodel/MissionViewModel.dart';
import '../widget/ImageItemMissionList.dart';

class MissionListScreen extends StatefulWidget {
  final String title;

  const MissionListScreen({super.key, required this.title});

  @override
  State<MissionListScreen> createState() => _MissionListScreenState();
}

class _MissionListScreenState extends State<MissionListScreen> {
  @override
  Widget build(BuildContext context) {
    final archives =
        context.watch<MissionViewModel>().archives.reversed.toList();

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemCount: archives.length,
        itemBuilder: (context, index) {
          return ImageItemMissionList(
            imageUrl: archives[index].archiveImage,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MissionDetailScreen(
                    title: '임무 상세',
                    archiveId: archives[index].archiveId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

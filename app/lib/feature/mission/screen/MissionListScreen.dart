import 'package:flutter/cupertino.dart';
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
    final archives = context.watch<MissionViewModel>().archives;

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
          return ImageItemMissionList(imageUrl: archives[index].archiveImage);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class MissionRecordScreen extends StatefulWidget {
  final int id;

  const MissionRecordScreen({
    super.key,
    required this.id,
  });

  @override
  State<MissionRecordScreen> createState() => _MissionRecordScreenState();
}

class _MissionRecordScreenState extends State<MissionRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: Column(
        children: [],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';

import '../../../theme/Colors.dart';
import 'CardHomeTopTen.dart';

class ListTopTenGame extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final Function(int id) onImageTap;
  final Map<String, dynamic> queryParameters;

  const ListTopTenGame({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.onImageTap,
    required this.queryParameters,
  }) : super(key: key);

  @override
  State<ListTopTenGame> createState() => _ListTopTenGameState();
}

class _ListTopTenGameState extends State<ListTopTenGame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: FontString.pretendardMedium,
                  color: mainWhite,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CardHomeTopTen(
            title: widget.title,
            images: AppDummyData.images,
            onImageTap: (int id) => widget.onImageTap(id),
            queryParameters: widget.queryParameters,
          )
        ],
      ),
    );
  }
}

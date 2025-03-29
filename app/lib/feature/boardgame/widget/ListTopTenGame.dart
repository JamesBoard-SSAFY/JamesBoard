import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';

import '../../../theme/Colors.dart';
import 'CardHomeTopTen.dart';

class ListTopTenGame extends StatefulWidget {
  final List<String> imageUrls; // 게임 이미지 URL 리스트
  final String title;
  final Function(String id) onImageTap; // 클릭 시 수행할 작업

  const ListTopTenGame(
      {Key? key,
      required this.imageUrls,
      required this.title,
      required this.onImageTap})
      : super(key: key);

  @override
  State<ListTopTenGame> createState() => _ListHomeHorizontalGameState();
}

class _ListHomeHorizontalGameState extends State<ListTopTenGame> {
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
            images: AppDummyData.images,
            onImageTap: (String id) => widget.onImageTap(id),
          )
        ],
      ),
    );
  }
}

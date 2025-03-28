import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/boardgame/widget/CardHomeReview.dart';

import '../../../theme/Colors.dart';

class ListBGGRankGame extends StatefulWidget {
  final List<String> imageUrls; // 게임 이미지 URL 리스트
  final String title;

  const ListBGGRankGame({
    Key? key,
    required this.imageUrls,
    required this.title,
  }) : super(key: key);

  @override
  State<ListBGGRankGame> createState() => _ListHomeHorizontalGameState();
}

class _ListHomeHorizontalGameState extends State<ListBGGRankGame> {
  // 섹션 제목
  final List<Map<String, String>> images = [
    {
      'id': '1',
      'url':
          'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg'
    },
    {
      'id': '2',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '3',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '4',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '5',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '6',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '7',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '8',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '9',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
  ];

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
          CardHomeReview(images: images, onImageTap: (String id) {})
        ],
      ),
    );
  }
}

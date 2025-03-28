import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../constants/FontString.dart';

class CardHomeTopTen extends StatefulWidget {
  final List<Map<String, String>> images; // {id: imageUrl}
  final Function(String id) onImageTap; // 클릭 시 수행할 작업

  const CardHomeTopTen(
      {super.key, required this.images, required this.onImageTap});

  @override
  State<CardHomeTopTen> createState() => _CardHomeTopTenState();
}

class _CardHomeTopTenState extends State<CardHomeTopTen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = 160;
        double height = width * (4 / 3); // 3:4 비율 적용

        return SizedBox(
          height: height, // 이미지 높이에 맞춤
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final imageUrl = image['url']!;
              final id = image['id']!;

              return GestureDetector(
                onTap: () => widget.onImageTap(id),
                child: Container(
                  width: width * 1.33, // 숫자 공간 추가
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20), // 아이템 간격 추가
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.33, // 숫자 너비 조정
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            // Stroke (외곽선)
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: height * 9 / 10,
                                fontFamily: FontString.pretendardBold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 5 // Stroke 두께 조절
                                  ..color = mainGold, // Stroke 색상
                              ),
                            ),
                            // 내부 색상
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: height * 9 / 10,
                                fontFamily: FontString.pretendardBold,
                                color: mainRed, // 내부 색상
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                        child: Image.network(
                          imageUrl,
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

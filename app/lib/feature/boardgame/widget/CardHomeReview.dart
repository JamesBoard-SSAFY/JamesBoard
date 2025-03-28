import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class CardHomeReview extends StatefulWidget {
  final List<Map<String, String>> images;
  final Function(String) onImageTap;

  const CardHomeReview({
    Key? key,
    required this.images,
    required this.onImageTap,
  }) : super(key: key);

  @override
  State<CardHomeReview> createState() => _CardHomeReviewState();
}

class _CardHomeReviewState extends State<CardHomeReview> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = 180;
        double height = itemWidth * (10 / 17);

        return SizedBox(
          height: height * 3,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true, // 콘텐츠 크기에 맞게 GridView 크기 조정
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3개의 아이템
                childAspectRatio: 8 / 17, // 비율
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Container(
                child: GestureDetector(
                  onTap: () => widget.onImageTap(widget.images[index]['id']!),
                  child: Container(
                    width: itemWidth * 1.2,
                    child: Row(
                      children: [
                        Container(
                          width: itemWidth,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // 이미지를 오른쪽으로 옮기기 위해 Transform 사용
                              Transform.translate(
                                offset: Offset(itemWidth * 0.175, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.images[index]['url']!,
                                    width: itemWidth,
                                    height: height,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -height * 0.15,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: height, // 숫자 크기 조정
                                    fontFamily: FontString.pretendardBold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 5 // 테두리 두께
                                      ..color = mainGold, // 외곽선 색상
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -height * 0.15,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: height,
                                    fontFamily: FontString.pretendardBold,
                                    color: mainRed, // 내부 색상
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

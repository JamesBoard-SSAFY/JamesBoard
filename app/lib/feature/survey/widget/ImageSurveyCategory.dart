import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class ImageSurveyCategory extends StatefulWidget {
  final List<Map<String, String>> images; // {id: imageUrl, name: name}
  final Function(String id) onImageTap; // 클릭 시 수행할 작업

  const ImageSurveyCategory(
      {super.key, required this.images, required this.onImageTap});

  @override
  State<ImageSurveyCategory> createState() => _ImageSurveyCategory();
}

class _ImageSurveyCategory extends State<ImageSurveyCategory> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 3; // 3열

        return GridView.builder(
          shrinkWrap: true, // 콘텐츠 크기에 맞게 GridView 크기 조정
          physics: NeverScrollableScrollPhysics(), // 내부 스크롤을 비활성화
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3개의 열
            childAspectRatio: 0.9, // 정사각형 비율
            crossAxisSpacing: 8, // 열 간 간격
            mainAxisSpacing: 16, // 행 간 간격
          ),
          itemCount: widget.images.length, // 이미지 갯수만큼 아이템 표시
          itemBuilder: (context, index) {
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index; // 선택된 인덱스 업데이트
                });
                widget.onImageTap(widget.images[index]['id']!);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center, // 중앙 정렬
                    children: [
                      ClipOval(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            isSelected
                                ? Colors.black.withOpacity(0.3)
                                : Colors.transparent,
                            BlendMode.darken, // 어두운 효과를 줄 수 있음
                          ),
                          child: Image.asset(
                            widget.images[index]['img']!, // 이미지 URL
                            width: itemWidth * 0.8, // 이미지 크기
                            height: itemWidth * 0.8, // 이미지 크기
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          child: SvgPicture.asset(
                            IconPath.surveyCheck, // SVG 아이콘 경로
                            width: itemWidth * 0.4, // 아이콘 크기
                            height: itemWidth * 0.4,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8), // 이미지와 텍스트 사이의 간격
                  Text(
                    widget.images[index]['name']!, // 이미지 이름
                    style: TextStyle(
                      color: isSelected ? mainGold : mainWhite, // 선택된 경우 색상 변경
                      fontSize: 16,
                      fontFamily: FontString.pretendardBold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

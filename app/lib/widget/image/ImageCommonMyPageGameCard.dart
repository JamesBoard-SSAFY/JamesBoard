import 'package:flutter/material.dart';

class ImageCommonMyPageGameCard extends StatelessWidget {
  final String imageUrl;

  const ImageCommonMyPageGameCard({
    super.key,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth; // 부모의 최대 너비
        double height = width * (3 / 3); // 3:4 비율 적용

        return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

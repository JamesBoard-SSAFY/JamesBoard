import 'package:flutter/material.dart';

class ImageCommonUserCircle extends StatelessWidget {
  final String imageUrl;
  const ImageCommonUserCircle({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval( // ClipOval을 이용해 원형으로 만듦
      child: Image.asset(
        imageUrl,
        width: 36,
        height: 36,
        fit: BoxFit.cover, // 이미지 비율 유지
      ),
    );
  }
}

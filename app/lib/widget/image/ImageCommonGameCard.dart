import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCommonGameCard extends StatelessWidget {
  final String imageUrl;

  const ImageCommonGameCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = 120; // 부모의 최대 너비
        double height = width * (4 / 3); // 3:4 비율 적용

        return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
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

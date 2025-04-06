import 'package:flutter/material.dart';

class ImageCommonGameCard extends StatelessWidget {
  final String imageUrl;

  const ImageCommonGameCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = 120;
        double height = width * (4 / 3);

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

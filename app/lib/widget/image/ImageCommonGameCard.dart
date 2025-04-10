import 'package:flutter/material.dart';
import 'package:jamesboard/constants/IconPath.dart';

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
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                IconPath.error007Image,
                width: width,
                height: height,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class ImageUserProfile extends StatelessWidget {
  final double imageSize;
  final String imageUrl;

  const ImageUserProfile({
    super.key,
    this.imageSize = 120,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: imageSize / 2,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: mainBlack,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: secondaryBlack,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: SvgPicture.asset(
                IconPath.pen,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

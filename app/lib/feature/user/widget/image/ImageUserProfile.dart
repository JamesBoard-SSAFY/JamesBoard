import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/theme/Colors.dart';

class ImageUserProfile extends StatelessWidget {
  final double imageSize;

  const ImageUserProfile({
    super.key,
    this.imageSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: imageSize / 2,
          backgroundImage: AssetImage('assets/image/image_default_profile.png'),
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
                'assets/image/icon_pen.svg',
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

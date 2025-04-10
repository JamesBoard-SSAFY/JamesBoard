import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/Colors.dart';

class ImageItemRegisterMission extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const ImageItemRegisterMission({
    super.key,
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(imageFile), // ✅ FileImage 사용
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainBlack.withOpacity(0.7),
              ),
              child: const Icon(
                Icons.close,
                color: mainGold,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

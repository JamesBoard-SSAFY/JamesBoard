import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class ImageUserProfile extends StatelessWidget {
  final double imageSize;
  final String imageUrl;
  final Function(String) onImagePicked;

  const ImageUserProfile({
    super.key,
    this.imageSize = 120,
    required this.imageUrl,
    required this.onImagePicked,
  });

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onImagePicked(pickedFile.path); // 선택한 이미지 경로 전달
    }
  }

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
          child: GestureDetector(
            onTap: () => _pickImage(context), // 클릭 시 이미지 선택 실행
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
        ),
      ],
    );
  }
}

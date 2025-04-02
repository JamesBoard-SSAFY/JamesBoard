import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../../util/CommonUtils.dart';
import '../../viewmodel/MyPageViewModel.dart';

class ImageUserProfile extends StatelessWidget {
  final double imageSize;
  final String imageUrl;
  final Function(String) onImagePicked;
  final MyPageViewModel viewModel;

  const ImageUserProfile({
    super.key,
    this.imageSize = 120,
    required this.imageUrl,
    required this.onImagePicked,
    required this.viewModel,
  });

  void _onPickImage() async {
    String? uploadedImageUrl = await CommonUtils.pickAndUploadImage(viewModel);

    if (uploadedImageUrl != null) {
      onImagePicked(uploadedImageUrl);
    } else {
      debugPrint("이미지 업로드 실패");
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
            onTap: _onPickImage,
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

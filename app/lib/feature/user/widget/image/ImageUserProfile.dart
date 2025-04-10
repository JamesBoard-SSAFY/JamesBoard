import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../../util/CommonUtils.dart';
import '../../viewmodel/MyPageViewModel.dart';

class ImageUserProfile extends StatefulWidget {
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

  @override
  State<ImageUserProfile> createState() => _ImageUserProfileState();
}

class _ImageUserProfileState extends State<ImageUserProfile> {
  bool _isLoading = false; // 로딩 상태 관리
  String _currentImageUrl = ''; // 현재 프로필 이미지 URL

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl; // 초기 이미지 설정
  }

  Future<void> _onPickImage() async {
    setState(() {
      _isLoading = true; // 이미지 선택 시 로딩 시작
    });

    String? uploadedImageUrl =
    await CommonUtils.pickAndUploadImage(widget.viewModel);

    if (uploadedImageUrl != null) {
      setState(() {
        _currentImageUrl = uploadedImageUrl; // 업로드된 이미지 적용
        _isLoading = false; // 로딩 종료
      });
      widget.onImagePicked(uploadedImageUrl);
    } else {
      setState(() {
        _isLoading = false; // 실패해도 로딩 종료
      });
      debugPrint("이미지 업로드 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: widget.imageSize / 2,
          backgroundColor: mainBlack,
          backgroundImage: _isLoading ? null : NetworkImage(_currentImageUrl),
          child: _isLoading
              ? CircularProgressIndicator(
            color: mainGold, // 로딩 인디케이터 색상
          )
              : null,
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

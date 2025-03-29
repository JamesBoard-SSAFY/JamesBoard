import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/mission/widget/ButtonRegisterArchivePicture.dart';
import 'package:jamesboard/feature/mission/widget/EditBoxRegisterMissionArchiveContent.dart';
import 'package:jamesboard/feature/mission/widget/EditBoxRegisterMissionBoardGameCount.dart';
import 'package:jamesboard/feature/mission/widget/ImageItemRegisterMission.dart';
import 'package:jamesboard/feature/mission/widget/SelectBoxRegisterMissionBoardGame.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonPrimaryBottom.dart';

import '../../../constants/AppString.dart';
import '../../../widget/appbar/DefaultCommonAppBar.dart';

class MissionEditScreen extends StatefulWidget {
  final String title;

  const MissionEditScreen({
    super.key,
    required this.title,
  });

  @override
  State<MissionEditScreen> createState() => _MissionEditScreenState();
}

class _MissionEditScreenState extends State<MissionEditScreen> {
  final TextEditingController _gameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _images = [];

  // 이미지 선택
  Future<void> _pickImage() async {
    if (_images.length >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(AppString.uploadLimit),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // 1:1로 크롭하기.
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppString.imageIncision,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true, // 하단 컨트롤 숨기기
            lockAspectRatio: true, // 비율 고정
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0, // 최소 비율 설정
            aspectRatioLockEnabled: true, // 비율 고정
          )
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _images.add(File(croppedFile.path));
        });
      }
    }
  }

  // 이미지 삭제
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // 카메라 연결
  Future<void> _pickImageFromCamera() async {
    if (_images.length >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(AppString.uploadLimit),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // 1:1로 크롭하기.
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppString.imageIncision,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true, // 하단 컨트롤 숨기기
            lockAspectRatio: true, // 비율 고정
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0, // 최소 비율 설정
            aspectRatioLockEnabled: true, // 비율 고정
          )
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _images.add(File(croppedFile.path));
        });
      }
    }
  }

  // 등록 버튼
  void _onSubmit() {
    if (_gameController.text.isNotEmpty &&
        _countController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      logger.d('보드게임 : ${_gameController.text}');
      logger.d('보드게임 판 수 : ${_countController.text}');
      logger.d('아카이브 문구 : ${_descriptionController.text}');
      logger.d('이미지 수 : ${_images.length}');
    } else {
      logger.d('모든 항목을 입력해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 임무 선택 영역
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.missionChoice,
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 20,
                      fontFamily: FontString.pretendardSemiBold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SelectBoxRegisterMissionBoardGame(),
                ],
              ),
            ),

            // 임무 수 영역
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.missionCompletedCount,
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 20,
                      fontFamily: FontString.pretendardSemiBold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  EditBoxRegisterMissionBoardGameCount(),
                ],
              ),
            ),

            // 임무 사진 영역
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    AppString.missionPhotoTitle,
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 20,
                      fontFamily: FontString.pretendardSemiBold,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // 버튼들
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 갤러리
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ButtonRegisterArchivePicture(
                            icon: IconPath.addPicture,
                            onTap: _pickImage,
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // 카메라
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ButtonRegisterArchivePicture(
                            icon: IconPath.camera,
                            onTap: _pickImageFromCamera,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // 이미지 리스트
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ImageItemRegisterMission(
                                imageUrl: _images[index].path,
                                onRemove: () => _removeImage(index)),
                          );
                        },
                      ),
                    ),

                  // 업로드 상태
                  if (_images.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 구분선
                          Expanded(
                            child: Container(
                              height: 1,
                              color: mainGrey,
                              margin: const EdgeInsets.only(right: 8),
                            ),
                          ),

                          // 업로드 상태
                          Text(
                            '(${_images.length} / 9)',
                            style: TextStyle(
                              color: mainGrey,
                              fontSize: 16,
                              fontFamily: FontString.pretendardSemiBold,
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),

            // 임무 문구 영역
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        AppString.missionResultTitle,
                        style: TextStyle(
                          color: mainWhite,
                          fontSize: 20,
                          fontFamily: FontString.pretendardSemiBold,
                        ),
                      ),
                      Text(
                        AppString.missionResultLimit,
                        style: TextStyle(
                          color: mainGrey,
                          fontSize: 14,
                          fontFamily: FontString.pretendardSemiBold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  EditBoxRegisterMissionArchiveContent(),
                ],
              ),
            ),

            // 등록 버튼
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 24.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ButtonCommonPrimaryBottom(
                    text: AppString.register,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

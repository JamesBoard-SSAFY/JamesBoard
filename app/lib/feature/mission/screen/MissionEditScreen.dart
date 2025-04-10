import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameSearchScreen.dart';
import 'package:jamesboard/feature/mission/screen/MissionDetailScreen.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/feature/mission/widget/ButtonRegisterArchivePicture.dart';
import 'package:jamesboard/feature/mission/widget/EditBoxRegisterMissionArchiveContent.dart';
import 'package:jamesboard/feature/mission/widget/EditBoxRegisterMissionBoardGameCount.dart';
import 'package:jamesboard/feature/mission/widget/ImageItemRegisterMission.dart';
import 'package:jamesboard/feature/mission/widget/SelectBoxRegisterMissionBoardGame.dart';
import 'package:jamesboard/feature/user/viewmodel/MyPageViewModel.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/BoardGameSearchPurpose.dart';
import 'package:jamesboard/util/CommonUtils.dart';
import 'package:jamesboard/widget/button/ButtonCommonPrimaryBottom.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../../constants/AppString.dart';
import '../../../datasource/model/request/ArchiveEditRequest.dart';
import '../../../widget/appbar/DefaultCommonAppBar.dart';

class MissionEditScreen extends StatefulWidget {
  final int? archiveId;

  const MissionEditScreen({
    super.key,
    this.archiveId,
  });

  @override
  State<MissionEditScreen> createState() => _MissionEditScreenState();
}

class _MissionEditScreenState extends State<MissionEditScreen> {
  final TextEditingController _gameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _imageFiles = [];
  DateTime? _lastSnackBarTime;
  bool _isSubmitting = false;
  bool _isPickingImage = false;

  final Map<String, DateTime> _snackBarLastShownTime = {};
  final Set<String> _shownSnackBarMessages = {};

  Future<void> _pickImage(ImageSource source, MyPageViewModel viewModel) async {
    if (_isPickingImage || _imageFiles.length >= 9) {
      return;
    }

    _isPickingImage = true;

    final result = await _cropCompressAndUploadImage(source, viewModel);

    if (result != null) {
      final (imageUrl, file) = result;

      if (_imageFiles.length >= 9) {
        _showSnackBarOnce(AppString.maxImageUploadLimit);
        _isPickingImage = false;
        return;
      }

      bool isDuplicate =
          _imageFiles.any((existingFile) => existingFile.path == file.path);
      if (isDuplicate) {
        _showSnackBarOnce('이미 추가된 이미지입니다.');
      } else {
        setState(() {
          _imageFiles.add(file);
        });
        context.read<MissionViewModel>().addImageUrl(imageUrl);
      }
    }

    _isPickingImage = false;
  }

  static Future<(String, File)?> _cropCompressAndUploadImage(
      ImageSource source, MyPageViewModel viewModel) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppString.imageIncision,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        String originalFileName = pickedFile.name;
        int timeStamp = DateTime.now().microsecondsSinceEpoch;
        String newFileName =
            '${path.basenameWithoutExtension(originalFileName)}_$timeStamp.webp';
        File? compressedImage = await CommonUtils.compressAndConvertToWebP(
            File(croppedFile.path), newFileName);

        if (compressedImage != null) {
          String? presignedUrl = await viewModel.issuePresignedUrl(newFileName);
          if (presignedUrl != null) {
            String? uploadedUrl = await CommonUtils.uploadImageToS3(
                compressedImage, presignedUrl);
            if (uploadedUrl != null) {
              return (uploadedUrl, compressedImage);
            }
          }
        }
      }
    }
    return null;
  }

  void _onSubmit(MissionViewModel viewModel) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // final count = int.tryParse(_countController.text);
    // viewModel.setArchivePlayCount(count);
    // viewModel.setArchivePlayTime();
    //
    // viewModel.setArchivePlayContent(_descriptionController.text);

    final validationResult = viewModel.validationInputs();
    logger.d('validationResult : $validationResult');
    logger.d(
        'selectedGameAveragePlayTime: ${viewModel.selectedGameAveragePlayTime}');
    logger.d('archivePlayCount: ${viewModel.archivePlayCount}');

    if (validationResult != null) {
      _showSnackBarOnce(validationResult);
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final request = ArchiveEditRequest(
      gameId: viewModel.selectedGameId!,
      archiveGamePlayCount: viewModel.archivePlayCount!,
      archiveImageList: viewModel.imageUrls,
      archiveContent: viewModel.archiveContent!,
      archiveGamePlayTime: 10,
    );

    logger.d('gameId : ${viewModel.selectedGameId}');
    logger.d('gameTitle : ${viewModel.selectedGameTitle}');
    logger.d('archiveGamePlayCount : ${viewModel.archivePlayCount}');
    logger.d('archiveImageList : ${viewModel.imageUrls}');
    logger.d('archiveContent : ${viewModel.archiveContent}');
    logger.d('archiveGamePlayTime : ${viewModel.archivePlayTime}');
    logger.d(
        'archiveContent 길이 : ${viewModel.archiveContent?.length.toString()}');

    int result;

    if (widget.archiveId == null) {
      // 등록 모드
      result = await viewModel.insertArchive(request);
    } else {
      // 수정 모드
      result = await viewModel.updateArchive(widget.archiveId!, request);
    }

    if (result != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.archiveId == null
              ? AppString.archiveRegisterSuccess
              : AppString.archiveUpdateSuccess),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MissionDetailScreen(
              title: AppString.missionDetailTitle, archiveId: result),
        ),
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppString.errorOccurred)),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  void _showSnackBarOnce(String message) {
    final now = DateTime.now();
    final lastShownTime = _snackBarLastShownTime[message];

    if (lastShownTime != null && now.difference(lastShownTime).inSeconds < 2) {
      return;
    }

    _snackBarLastShownTime[message] = now;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _shownSnackBarMessages.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final missionViewModel = context.read<MissionViewModel>();

    missionViewModel.clearAll();
    _imageFiles.clear();

    _descriptionController.addListener(() {
      missionViewModel.setArchivePlayContent(_descriptionController.text);
      missionViewModel.validationInputs();
    });

    _countController.addListener(() {
      final count = int.tryParse(_countController.text);
      missionViewModel.setArchivePlayCount(count);
      // missionViewModel.setArchivePlayTime();
      missionViewModel.validationInputs();
    });

    if (widget.archiveId != null) {
      // 수정 모드
      missionViewModel.getArchiveById(widget.archiveId!).then((_) {
        final detail = missionViewModel.archiveDetailResponse;
        if (detail != null) {
          _countController.text = detail.archiveGamePlayCount.toString();
          _descriptionController.text = detail.archiveContent;
          missionViewModel.setSelectedBoardGame(
            gameId: detail.gameId,
            gameTitle: detail.gameTitle,
            gamePlayTime: detail.archiveGamePlayCount > 0
                ? (detail.archiveGamePlayTime ~/ detail.archiveGamePlayCount)
                : 0,
          );

          final count = int.tryParse(_countController.text);
          missionViewModel.setArchivePlayCount(count);
          // missionViewModel.setArchivePlayTime();

          missionViewModel.validationInputs();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MissionViewModel>();
    final myPageViewModel = context.watch<MyPageViewModel>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: mainBlack,
        appBar: DefaultCommonAppBar(
            title: widget.archiveId == null
                ? AppString.register
                : AppString.archiveUpdate),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 보드게임 선택 영역
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoardGameSearchScreen(
                      purpose: BoardGameSearchPurpose.fromMission,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.missionChoice,
                          style: TextStyle(
                              color: mainWhite,
                              fontSize: 20,
                              fontFamily: FontString.pretendardSemiBold)),
                      const SizedBox(height: 12),
                      SelectBoxRegisterMissionBoardGame(
                        selectedGameTitle: viewModel.selectedGameTitle,
                      ),
                    ],
                  ),
                ),
              ),
              // 진행한 임무 수 영역
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.missionCompletedCount,
                        style: TextStyle(
                            color: mainWhite,
                            fontSize: 20,
                            fontFamily: FontString.pretendardSemiBold)),
                    const SizedBox(height: 12),
                    EditBoxRegisterMissionBoardGameCount(
                      controller: _countController,
                    ),
                  ],
                ),
              ),
              // 임무 사진 영역
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.missionPhotoTitle,
                        style: TextStyle(
                            color: mainWhite,
                            fontSize: 20,
                            fontFamily: FontString.pretendardSemiBold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ButtonRegisterArchivePicture(
                              icon: IconPath.addPicture,
                              // onTap: () async {
                              //   if (_imageFiles.length >= 9) {
                              //     _showSnackBarOnce(
                              //         AppString.maxImageUploadLimit);
                              //     return;
                              //   }
                              //
                              //   final result =
                              //       await _cropCompressAndUploadImage(
                              //           ImageSource.gallery, myPageViewModel);
                              //   if (result != null) {
                              //     final (imageUrl, file) = result;
                              //
                              //     bool isDuplicate = _imageFiles.any(
                              //         (existingFile) =>
                              //             existingFile.path == file.path);
                              //
                              //     if (isDuplicate) {
                              //       _showSnackBarOnce('이미 추가된 이미지입니다.');
                              //       return;
                              //     }
                              //
                              //     setState(() {
                              //       _imageFiles.add(file);
                              //     });
                              //     viewModel.addImageUrl(imageUrl);
                              //   }
                              // },
                              onTap: () => _pickImage(
                                ImageSource.gallery,
                                myPageViewModel,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ButtonRegisterArchivePicture(
                              icon: IconPath.camera,
                              // onTap: () async {
                              //   if (_imageFiles.length >= 9) {
                              //     _showSnackBarOnce(
                              //         AppString.maxImageUploadLimit);
                              //     return;
                              //   }
                              //
                              //   final result =
                              //       await _cropCompressAndUploadImage(
                              //           ImageSource.camera, myPageViewModel);
                              //   if (result != null) {
                              //     final (imageUrl, file) = result;
                              //
                              //     bool isDuplicate = _imageFiles.any(
                              //         (existingFile) =>
                              //             existingFile.path == file.path);
                              //
                              //     if (isDuplicate) {
                              //       _showSnackBarOnce('이미 추가된 이미지입니다.');
                              //       return;
                              //     }
                              //
                              //     setState(() {
                              //       _imageFiles.add(file);
                              //     });
                              //     viewModel.addImageUrl(imageUrl);
                              //   }
                              // },
                              onTap: () => _pickImage(
                                ImageSource.camera,
                                myPageViewModel,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_imageFiles.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageFiles.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ImageItemRegisterMission(
                              imageFile: _imageFiles[index],
                              onRemove: () {
                                setState(() {
                                  _imageFiles.removeAt(index);
                                });
                                viewModel.removeImageUrl(index);
                              },
                            ),
                          ),
                        ),
                      ),
                    if (viewModel.imageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: mainGrey,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                            ),
                            Text(
                              '(${viewModel.imageUrls.length} / 9)',
                              style: TextStyle(
                                color: mainGrey,
                                fontSize: 16,
                                fontFamily: FontString.pretendardSemiBold,
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // 임무 결과 영역
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(AppString.missionResultTitle,
                            style: TextStyle(
                                color: mainWhite,
                                fontSize: 20,
                                fontFamily: FontString.pretendardSemiBold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    EditBoxRegisterMissionArchiveContent(
                      controller: _descriptionController,
                    ),
                  ],
                ),
              ),
              // 등록 버튼 영역
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                child: ButtonCommonPrimaryBottom(
                  text: widget.archiveId == null
                      ? AppString.register
                      : AppString.modify,
                  onPressed: () => _onSubmit(viewModel),
                  disableWithOpacity: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

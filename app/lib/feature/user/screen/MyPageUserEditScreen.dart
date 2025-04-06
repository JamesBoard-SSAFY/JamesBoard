import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/user/widget/image/ImageUserProfile.dart';
import 'package:jamesboard/feature/user/widget/textfield/TextFieldUserNickname.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import '../../../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../../../widget/appbar/DefaultCommonAppBar.dart';
import '../../../widget/button/ButtonCommonPrimaryBottom.dart';
import '../viewmodel/MyPageViewModel.dart';

class MyPageUserEditScreen extends StatefulWidget {
  final String title;
  final String userName;
  final String userImg;

  const MyPageUserEditScreen({
    super.key,
    required this.title,
    required this.userName,
    required this.userImg,
  });

  @override
  State<MyPageUserEditScreen> createState() => _MyPageUserEditScreenState();
}

class _MyPageUserEditScreenState extends State<MyPageUserEditScreen> {
  @override
  String _nickname = ''; // 닉네임 상태 저장
  bool _isNicknameValid = false; // 닉네임 유효성 상태
  late String _userImage; // 프로필 이미지 상태 추가

  @override
  void initState() {
    super.initState();
    _nickname = widget.userName;
    _userImage = widget.userImg; // 초기 프로필 이미지 설정
  }

  void _onProfileImageChanged(String imagePath) {
    setState(() {
      _userImage = imagePath;
      _validateForm(); // 닉네임과 이미지 변경 상태를 함께 확인
    });
  }

  void _onNicknameChanged(String nickname, bool isValid) {
    setState(() {
      _nickname = nickname;
      _isNicknameValid = isValid;
      _validateForm(); // 닉네임이 바뀔 때도 폼 유효성 검사
    });
  }

  void _validateForm() {
    bool isImageChanged = _userImage != widget.userImg;
    bool isFormValid =
        _isNicknameValid || isImageChanged; // 닉네임이 유효하거나 이미지 변경되었을 때만 true

    setState(() {
      _isNicknameValid = isFormValid;
    });
  }

  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyPageViewModel>(context);

    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageUserProfile(
                      imageUrl: _userImage,
                      onImagePicked: _onProfileImageChanged,
                      viewModel: viewModel,
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldUserNickname(
                  userName: widget.userName,
                  onNicknameChanged: _onNicknameChanged,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppString.nicknameLengthConstraint,
                      style: TextStyle(
                          color: mainGrey,
                          fontSize: 12,
                          fontFamily: FontString.pretendardBold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonCommonPrimaryBottom(
                    text: AppString.changeUserName,
                    disableWithOpacity: true,
                    onPressed: (_isNicknameValid ||
                            _userImage != widget.userImg)
                        ? () async {
                            await viewModel.editUserInfo(MyPageUserInfoRequest(
                              userName: _nickname,
                              userProfile: _userImage,
                            ));
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

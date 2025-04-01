import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/user/widget/image/ImageUserProfile.dart';
import 'package:jamesboard/feature/user/widget/textfield/TextFieldUserNickname.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import '../../../constants/AppString.dart';
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
    _userImage = widget.userImg; // 초기 프로필 이미지 설정
  }

  void _onNicknameChanged(String nickname, bool isValid) {
    setState(() {
      _nickname = nickname;
      _isNicknameValid = isValid;
    });
  }

  void _onProfileImageChanged(String imagePath) {
    setState(() {
      _userImage = imagePath; // 선택한 이미지로 상태 업데이트
    });
  }

  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyPageViewModel>(context);

    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: SingleChildScrollView(
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
                    "닉네임 2자 이상부터 16자까지 입력이 가능해요.",
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
                child: ElevatedButton(
                  onPressed: _isNicknameValid
                      ? () {
                          viewModel.editUserInfo(MyPageUserInfoRequest(
                              userName: _nickname,
                              userProfile: _userImage)); // 선택한 이미지 전달
                          print("닉네임 변경 완료: $_nickname");
                          print("프로필 이미지 변경 완료: $_userImage");

                          Navigator.pop(context);
                        }
                      : null, // 유효하지 않으면 버튼 비활성화
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryBlack, // 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // radius 10
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20), // 상하 패딩 12
                  ),
                  child: Text(
                    '변경',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontString.pretendardSemiBold,
                      color: mainWhite, // 텍스트 색상
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

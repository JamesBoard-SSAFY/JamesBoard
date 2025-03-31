import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/user/widget/image/ImageUserProfile.dart';
import 'package:jamesboard/feature/user/widget/textfield/TextFieldUserNickname.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../constants/AppString.dart';
import '../../../widget/appbar/DefaultCommonAppBar.dart';
import '../../../widget/button/ButtonCommonPrimaryBottom.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: Padding(
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
                  imageUrl: widget.userImg,
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            TextFieldUserNickname(
              userName: widget.userName,
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
            ButtonCommonPrimaryBottom(text: AppString.changeUserName),
          ],
        ),
      ),
    );
  }
}

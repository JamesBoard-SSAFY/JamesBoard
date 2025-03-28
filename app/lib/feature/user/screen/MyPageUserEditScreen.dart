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

  const MyPageUserEditScreen({
    super.key,
    required this.title,
    required this.userName,
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
                  imageUrl:
                      "https://cf.geekdo-images.com/wLto-xaabHwKQe_Bc4iD1Q__micro/img/IcevtuHa5wbYSpkiPp4vFOqrDVo=/fit-in/64x64/filters:strip_icc()/pic3458036.png",
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            TextFieldUserNickname(),
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

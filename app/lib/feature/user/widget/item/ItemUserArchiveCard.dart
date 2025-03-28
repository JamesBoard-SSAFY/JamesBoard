import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';

class ItemUserArchiveCard extends StatelessWidget {
  final String imageUrl;
  final String content;
  final String tag;

  const ItemUserArchiveCard(
      {super.key,
      required this.imageUrl,
      required this.content,
      required this.tag});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: mainGrey, width: 1)),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                IconPath.archivePhoto,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 16, bottom: 12),
              child: Column(
                children: [
                  Text(
                    'This is a description for the card. Here you can put some content that explains more about the card.',
                    style: TextStyle(
                        fontSize: 16,
                        color: mainWhite,
                        fontFamily: FontString.pretendardMedium),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [ButtonCommonGameTag(text: "3시간 40분")],
                    ),
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

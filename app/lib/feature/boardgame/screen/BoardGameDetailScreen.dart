import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';
import 'package:jamesboard/widget/button/ButtonCommonPrimaryBottom.dart';

import '../../../constants/AppString.dart';
import '../../../util/BottomSheetUtil.dart';
import '../../../util/dummy/AppDummyData.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class BoardGameDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.network(
                      'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg', // 이미지 URL
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryBlack,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: mainWhite,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(color: shadowBlack),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '클루',
                            style: TextStyle(
                              color: mainWhite,
                              fontSize: 44,
                              fontFamily: FontString.pretendardBold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                IconPath.starSelected,
                                width: 24,
                                height: 24,
                                color: mainGold,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "3.7",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: FontString.pretendardMedium,
                                  color: mainGold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ButtonCommonGameTag(text: '15세'),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ButtonCommonGameTag(text: '1997년'),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ButtonCommonGameTag(text: '중급'),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ButtonCommonGameTag(text: '3~6명'),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ButtonCommonGameTag(text: '40분'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  top: 12,
                ),
                child: Text(
                  "추리 • 전략",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: FontString.pretendardMedium,
                    color: mainGrey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                ),
                child: ButtonCommonPrimaryBottom(text: AppString.evaluation),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 24, right: 20),
                child: Text(
                  "클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. ",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontString.pretendardMedium,
                      color: mainWhite),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 20,
                  top: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BottomSheetUtil.showBoardGameDetailBottomSheet(context);
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontString.pretendardMedium,
                          color: mainGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 24,
                  left: 20,
                  right: 20,
                ),
                child: Divider(
                  color: mainGrey,
                  thickness: 1, // 두께 설정
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 24,
                  left: 20,
                  right: 20,
                ),
                child: Text(
                  AppString.similarMission,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: FontString.pretendardBold,
                    color: mainWhite,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 24,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 3개
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: AppDummyData.imageUrls.length,
                  itemBuilder: (context, index) {
                    return ImageCommonGameCard(
                      imageUrl: AppDummyData.imageUrls[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

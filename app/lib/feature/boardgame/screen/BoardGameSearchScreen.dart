import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/image/ImageCommonGameCard.dart';
import 'package:jamesboard/widget/item/ItemCommonRecentSearch.dart';
import 'package:jamesboard/widget/searchbar/SearchBarCommonTitle.dart';

class BoardGameSearchScreen extends StatefulWidget {
  const BoardGameSearchScreen({super.key});

  @override
  State<BoardGameSearchScreen> createState() => _BoardGameSearchScreenState();
}

class _BoardGameSearchScreenState extends State<BoardGameSearchScreen> {
  // 임시 최근 검색 목록
  List<String> recentSearches = ['뱅', '카탄', '미스터잭'];
  List<String> recentSearches2 = [];

  // 검색 결과 리스트
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();

    // 최근 검색 없으면 2초 후 더미 검색 결과 보여주기. (임시용)
    if (recentSearches2.isEmpty) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          searchResults = [
            'https://i.namu.wiki/i/GzTCiAf9b1WCKkOKjKLZEKc8TNWZAaFBsjasvtUkr6mmI93-8LMfVOdw9Mm2Xu86goLcxsQNybGvycTFQI3kxI0H3eRpYm1F83cxa5Zjp_Si5FB6m9ML2Lu33pfo5AMjAkOt3yslZDf6r2U_IaW_0w.webp',
            'https://i.namu.wiki/i/ZQ93Ywg_kjqxr3IMyV5BLVJNDrCPxN6vjadE2nsTDR2mkE_s86kX3SbA7NOqHE2XSvpINg5rbAvxTP_7nAlup190mev_EwddA1tTcJ5ZiwzEKkNNPkCLPQOXLc1aj8DS_AVcCpL000tSDJwQ1QTSqg.webp',
            'https://i.namu.wiki/i/PU5GUgPg-3uIJdnSijJ-dNw1YQBPV7zpp-1wqk9n1FHRQ1kLIB2mDRxl2G-E06uJd5aneaFnZnDKCR0w54qCIkcGhtd6t9kn8yFj6TtYItuV4KXndyBDzwJhUJVOmOB10b63l10hPQSfYfKnungBlQ.webp',
            'https://i.namu.wiki/i/h_W7YSj1SA_yWFARKh859elU_sTn4JJq4kexNorxug8JJ1yz3ALaRARd87xz7_p_N80lvQD9H8HZH0V295tDfs0qxH4bzGY5-SLfQ46YFDaveEZLNf5qz5xmobEVXjIii0duWZ3xbqz-KqiseBTiVg.webp',
            'https://i.namu.wiki/i/GzTCiAf9b1WCKkOKjKLZEKc8TNWZAaFBsjasvtUkr6mmI93-8LMfVOdw9Mm2Xu86goLcxsQNybGvycTFQI3kxI0H3eRpYm1F83cxa5Zjp_Si5FB6m9ML2Lu33pfo5AMjAkOt3yslZDf6r2U_IaW_0w.webp',
            'https://i.namu.wiki/i/ZQ93Ywg_kjqxr3IMyV5BLVJNDrCPxN6vjadE2nsTDR2mkE_s86kX3SbA7NOqHE2XSvpINg5rbAvxTP_7nAlup190mev_EwddA1tTcJ5ZiwzEKkNNPkCLPQOXLc1aj8DS_AVcCpL000tSDJwQ1QTSqg.webp',
            'https://i.namu.wiki/i/PU5GUgPg-3uIJdnSijJ-dNw1YQBPV7zpp-1wqk9n1FHRQ1kLIB2mDRxl2G-E06uJd5aneaFnZnDKCR0w54qCIkcGhtd6t9kn8yFj6TtYItuV4KXndyBDzwJhUJVOmOB10b63l10hPQSfYfKnungBlQ.webp',
            'https://i.namu.wiki/i/h_W7YSj1SA_yWFARKh859elU_sTn4JJq4kexNorxug8JJ1yz3ALaRARd87xz7_p_N80lvQD9H8HZH0V295tDfs0qxH4bzGY5-SLfQ46YFDaveEZLNf5qz5xmobEVXjIii0duWZ3xbqz-KqiseBTiVg.webp',
            'https://i.namu.wiki/i/GzTCiAf9b1WCKkOKjKLZEKc8TNWZAaFBsjasvtUkr6mmI93-8LMfVOdw9Mm2Xu86goLcxsQNybGvycTFQI3kxI0H3eRpYm1F83cxa5Zjp_Si5FB6m9ML2Lu33pfo5AMjAkOt3yslZDf6r2U_IaW_0w.webp',
            'https://i.namu.wiki/i/ZQ93Ywg_kjqxr3IMyV5BLVJNDrCPxN6vjadE2nsTDR2mkE_s86kX3SbA7NOqHE2XSvpINg5rbAvxTP_7nAlup190mev_EwddA1tTcJ5ZiwzEKkNNPkCLPQOXLc1aj8DS_AVcCpL000tSDJwQ1QTSqg.webp',
            'https://i.namu.wiki/i/PU5GUgPg-3uIJdnSijJ-dNw1YQBPV7zpp-1wqk9n1FHRQ1kLIB2mDRxl2G-E06uJd5aneaFnZnDKCR0w54qCIkcGhtd6t9kn8yFj6TtYItuV4KXndyBDzwJhUJVOmOB10b63l10hPQSfYfKnungBlQ.webp',
            'https://i.namu.wiki/i/h_W7YSj1SA_yWFARKh859elU_sTn4JJq4kexNorxug8JJ1yz3ALaRARd87xz7_p_N80lvQD9H8HZH0V295tDfs0qxH4bzGY5-SLfQ46YFDaveEZLNf5qz5xmobEVXjIii0duWZ3xbqz-KqiseBTiVg.webp',
            'https://i.namu.wiki/i/GzTCiAf9b1WCKkOKjKLZEKc8TNWZAaFBsjasvtUkr6mmI93-8LMfVOdw9Mm2Xu86goLcxsQNybGvycTFQI3kxI0H3eRpYm1F83cxa5Zjp_Si5FB6m9ML2Lu33pfo5AMjAkOt3yslZDf6r2U_IaW_0w.webp',
            'https://i.namu.wiki/i/ZQ93Ywg_kjqxr3IMyV5BLVJNDrCPxN6vjadE2nsTDR2mkE_s86kX3SbA7NOqHE2XSvpINg5rbAvxTP_7nAlup190mev_EwddA1tTcJ5ZiwzEKkNNPkCLPQOXLc1aj8DS_AVcCpL000tSDJwQ1QTSqg.webp',
            'https://i.namu.wiki/i/PU5GUgPg-3uIJdnSijJ-dNw1YQBPV7zpp-1wqk9n1FHRQ1kLIB2mDRxl2G-E06uJd5aneaFnZnDKCR0w54qCIkcGhtd6t9kn8yFj6TtYItuV4KXndyBDzwJhUJVOmOB10b63l10hPQSfYfKnungBlQ.webp',
            'https://i.namu.wiki/i/h_W7YSj1SA_yWFARKh859elU_sTn4JJq4kexNorxug8JJ1yz3ALaRARd87xz7_p_N80lvQD9H8HZH0V295tDfs0qxH4bzGY5-SLfQ46YFDaveEZLNf5qz5xmobEVXjIii0duWZ3xbqz-KqiseBTiVg.webp',
          ];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 검색 바 영역
              SearchBarCommonTitle(),
              const SizedBox(height: 20),

              // 최근 검색 목록 영역
              if (recentSearches2.isNotEmpty) ...[
                Text(
                  '최근 검색',
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 20,
                    fontFamily: 'PretendardSemiBold',
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  itemCount: recentSearches.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = recentSearches[index];

                    return GestureDetector(
                      onTap: () {
                        // TODO: 검색 실행 로직
                        // 바로 검색 로직 실행하기. 리스트 쫙 뿌려주기.
                      },
                      child: ItemCommonRecentSearch(
                          title: item, iconPath: 'assets/image/icon_close.svg'),
                    );
                  },
                )
              ],

              if (recentSearches2.isEmpty) ...[
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ImageCommonGameCard(
                            imageUrl: searchResults[index],
                          );
                        }))
              ]
            ],
          ),
        ),
      ),
    );
  }
}

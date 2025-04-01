import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class ListBoardGameCategoryPage extends StatefulWidget {
  final Function(String, String) updateFilter;
  final String title;
  final String updateCategory;
  final Map<String, String> selectedFilters;

  const ListBoardGameCategoryPage(
      {super.key,
      required this.title,
      required this.updateFilter,
      required this.updateCategory,
      required this.selectedFilters});

  @override
  State<ListBoardGameCategoryPage> createState() =>
      _ListBoardGameCategoryPageState();
}

class _ListBoardGameCategoryPageState extends State<ListBoardGameCategoryPage> {
  void _showFilterBottomSheet(String filterType) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetCommonFilter(
        items: AppDummyData.filterOptions[filterType]!,
        initialValue: widget.selectedFilters[filterType] != filterType
            ? widget.selectedFilters[filterType]
            : null,
      ),
    );

    if (result != null) {
      widget.updateFilter(
          filterType, result == AppString.noCare ? filterType : result);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    widget.selectedFilters[widget.updateCategory] =
        AppDummyData.filterTitleMap[widget.title]!;
  }

  @override
  void dispose() {
    super.dispose();

    widget.selectedFilters.updateAll((key, value) => key);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 스크롤 가능하도록 감싸줌
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...widget.selectedFilters.keys.map((filterType) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      child: ButtonCommonFilter(
                        text: AppDummyData.filterDisplayMap[
                                widget.selectedFilters[filterType]] ??
                            widget.selectedFilters[filterType]!,
                        isSelected:
                            widget.selectedFilters[filterType] != filterType,
                        onTap: () => _showFilterBottomSheet(filterType),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selectedFilters.updateAll((key, value) => key);
                      });
                    },
                    child: Text(
                      AppString.clear,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 16,
                        fontFamily: FontString.pretendardSemiBold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}

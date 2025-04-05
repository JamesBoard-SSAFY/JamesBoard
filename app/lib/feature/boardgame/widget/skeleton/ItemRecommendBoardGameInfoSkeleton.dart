import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jamesboard/theme/Colors.dart';

class ItemRecommendBoardGameInfoSkeleton extends StatelessWidget {
  const ItemRecommendBoardGameInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[800],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: mainGrey, width: 1),
                  right: BorderSide(color: mainGrey, width: 1),
                  bottom: BorderSide(color: mainGrey, width: 1),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, bottom: 12),
                    child: Container(
                      width: 180,
                      height: 32,
                      color: Colors.grey[800],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 80,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, top: 12, right: 12, bottom: 12),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: double.infinity,
                          height: 16,
                          margin: EdgeInsets.only(bottom: 8),
                          color: Colors.grey[800],
                        ),
                      ),
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

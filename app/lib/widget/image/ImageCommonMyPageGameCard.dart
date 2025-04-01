import 'package:flutter/material.dart';
import 'package:jamesboard/feature/user/screen/MissionRecordScreen.dart';

class ImageCommonMyPageGameCard extends StatelessWidget {
  final List<Map<String, String>> images;
  final Function(String id) onTap;

  const ImageCommonMyPageGameCard({
    super.key,
    required this.images,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3x3 그리드
        crossAxisSpacing: 8.0, // 좌우 간격
        mainAxisSpacing: 8.0, // 상하 간격
        childAspectRatio: 1, // 정사각형 비율
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MissionRecordScreen(id: int.parse(item['id']!)),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              item['img']!,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

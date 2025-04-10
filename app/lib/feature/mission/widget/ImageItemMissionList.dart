import 'package:flutter/cupertino.dart';

class ImageItemMissionList extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ImageItemMissionList({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double size = (constraints.maxWidth - 16) / 2;

          return Image.network(
            imageUrl,
            width: size * 0.3,
            height: size * 0.3,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

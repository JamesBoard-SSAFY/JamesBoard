import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class BoardGameImageScreen extends StatelessWidget {
  final String imageUrl;

  const BoardGameImageScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
              },
              child: Image.network(
                imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class ItemUserGenrePercentInfo extends StatelessWidget {
  final List<Map<String, dynamic>> genres;

  const ItemUserGenrePercentInfo({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genres.map((genreInfo) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // 간격 조정
          child: _buildGenreItem(
            genreInfo['genre'],
            genreInfo['percent'],
            genreInfo['color'],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenreItem(String genre, dynamic percent, Color color) {
    // percent를 double로 변환
    double value = percent is double ? percent : percent.toDouble();

    return Row(
      children: [
        ClipOval(
          child: Container(
            width: 30,
            height: 30,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          genre,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'PretendardSemiBold',
            color: mainWhite,
          ),
        ),
        Expanded(
          child: Text(
            // 소수점 이하가 0이면 정수로, 그렇지 않으면 소수점 한 자리까지 표시
            value % 1 == 0
                ? "${value.toInt()}%" // 정수로 처리
                : "${value.toStringAsFixed(1)}%", // 소수점 한 자리까지 표시
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'PretendardSemiBold',
              color: mainWhite,
            ),
          ),
        ),
      ],
    );
  }
}

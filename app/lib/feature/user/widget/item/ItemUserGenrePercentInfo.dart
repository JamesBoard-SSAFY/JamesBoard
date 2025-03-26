import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class ItemUserGenrePercentInfo extends StatefulWidget {
  final String genre;
  final int percent;

  const ItemUserGenrePercentInfo({
    super.key,
    required this.genre,
    required this.percent
  });

  @override
  State<ItemUserGenrePercentInfo> createState() => _ItemUserGenrePercentInfoState();
}

class _ItemUserGenrePercentInfoState extends State<ItemUserGenrePercentInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: ClipOval(
          child: Container(
            width: 30,
            height: 30,
            color: mainParty
          ),
        ),
        title: Text(
          widget.genre,
          style: TextStyle(
              fontSize: 20 ,
              fontFamily: 'PretendardSemiBold',
              color: mainWhite
          ),
        ),
        trailing: Text(
          "${widget.percent}%",
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'PretendardSemiBold',
              color: mainWhite
          ),
        ),
      ),
    );
  }
}

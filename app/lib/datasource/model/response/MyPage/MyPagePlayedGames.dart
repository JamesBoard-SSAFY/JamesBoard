import 'package:json_annotation/json_annotation.dart';

part 'MyPagePlayedGames.g.dart';

@JsonSerializable()
class MyPagePlayedGames {
  final int gameId;
  final String gameImage;

  MyPagePlayedGames({
    required this.gameId,
    required this.gameImage,
  });

  factory MyPagePlayedGames.fromJson(Map<String, dynamic> json) => _$MyPagePlayedGamesFromJson(json);
  Map<String, dynamic> toJson() => _$MyPagePlayedGamesToJson(this);
}
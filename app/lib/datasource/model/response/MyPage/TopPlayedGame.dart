import 'package:json_annotation/json_annotation.dart';

part 'TopPlayedGame.g.dart';

@JsonSerializable()
class TopPlayedGame {
  final int gameId;
  final String gameTitle;
  final String gameImage;
  final int totalPlayCount;

  TopPlayedGame({
    required this.gameId,
    required this.gameTitle,
    required this.gameImage,
    required this.totalPlayCount,
  });

  factory TopPlayedGame.fromJson(Map<String, dynamic> json) => _$TopPlayedGameFromJson(json);
  Map<String, dynamic> toJson() => _$TopPlayedGameToJson(this);
}
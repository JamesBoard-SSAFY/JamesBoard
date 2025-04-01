import 'package:json_annotation/json_annotation.dart';

part 'BoardGameResponse.g.dart';

@JsonSerializable()
class BoardGameResponse {
  final int gameId;
  final String gameTitle;
  final String gameImage;
  final String gameCategory;
  final int minPlayer;
  final int maxPlayer;
  final int difficulty;
  final int playTime;
  final String gameDescription;

  BoardGameResponse({
    required this.gameId,
    required this.gameTitle,
    required this.gameImage,
    required this.gameCategory,
    required this.minPlayer,
    required this.maxPlayer,
    required this.difficulty,
    required this.playTime,
    required this.gameDescription,
  });

  factory BoardGameResponse.fromJson(Map<String, dynamic> json) =>
      _$BoardGameResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BoardGameResponseToJson(this);
}

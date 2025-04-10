import 'package:json_annotation/json_annotation.dart';

part 'BoardGameRecommendResponse.g.dart';

@JsonSerializable()
class BoardGameRecommendResponse {
  final int gameId;
  final String gameTitle;
  final String gameImage;
  final String gameCategory;
  final int minPlayer;
  final int maxPlayer;
  final int difficulty;
  final int playTime;
  final String gameDescription;

  BoardGameRecommendResponse({
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

  factory BoardGameRecommendResponse.fromJson(Map<String, dynamic> json) =>
      _$BoardGameRecommendResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BoardGameRecommendResponseToJson(this);
}

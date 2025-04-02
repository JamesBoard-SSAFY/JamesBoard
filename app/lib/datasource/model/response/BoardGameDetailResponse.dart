import 'package:json_annotation/json_annotation.dart';

part 'BoardGameDetailResponse.g.dart';

@JsonSerializable()
class BoardGameDetailResponse {
  final int gameId;
  final String gameTitle;
  final String gameImage;
  final List<String> gameCategories;
  final List<String> gameThemes;
  final List<String> gameDesigners;
  final String gamePublisher;
  final int gameYear;
  final int gameMinAge;
  final int minPlayers;
  final int maxPlayers;
  final int difficulty;
  final int playTime;
  final String description;
  final double gameRating;

  BoardGameDetailResponse({
    required this.gameId,
    required this.gameTitle,
    required this.gameImage,
    required this.gameCategories,
    required this.gameThemes,
    required this.gameDesigners,
    required this.gamePublisher,
    required this.gameYear,
    required this.gameMinAge,
    required this.minPlayers,
    required this.maxPlayers,
    required this.difficulty,
    required this.playTime,
    required this.description,
    required this.gameRating,
  });

  factory BoardGameDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$BoardGameDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BoardGameDetailResponseToJson(this);
}

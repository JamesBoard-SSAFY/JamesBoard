import 'package:json_annotation/json_annotation.dart';
import 'GenreStats.dart';
import 'TopPlayedGame.dart';

part 'MyPageGameStatsResponse.g.dart';

@JsonSerializable()
class MyPageGameStatsResponse {
  final int totalPlayed;
  final List<GenreStats> genreStats;
  final List<TopPlayedGame> topPlayedGames;

  MyPageGameStatsResponse({
    required this.totalPlayed,
    required this.genreStats,
    required this.topPlayedGames,
  });

  factory MyPageGameStatsResponse.fromJson(Map<String, dynamic> json) => _$MyPageGameStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyPageGameStatsResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'GenreStats.g.dart';

@JsonSerializable()
class GenreStats {
  final String gameCategoryName;
  final int count;
  final double percentage;

  GenreStats({
    required this.gameCategoryName,
    required this.count,
    required this.percentage,
  });

  factory GenreStats.fromJson(Map<String, dynamic> json) => _$GenreStatsFromJson(json);
  Map<String, dynamic> toJson() => _$GenreStatsToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'SurveyBoardGameResponse.g.dart';

@JsonSerializable()
class SurveyBoardGameResponse {
  final int gameId;
  final String gameTitle;

  SurveyBoardGameResponse({
    required this.gameId,
    required this.gameTitle,
  });

  factory SurveyBoardGameResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyBoardGameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyBoardGameResponseToJson(this);
}

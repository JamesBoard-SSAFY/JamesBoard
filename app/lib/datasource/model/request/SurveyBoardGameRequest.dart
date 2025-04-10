import 'package:json_annotation/json_annotation.dart';

part 'SurveyBoardGameRequest.g.dart';

@JsonSerializable()
class SurveyBoardGameRequest {
  final int gameId;

  SurveyBoardGameRequest({
    required this.gameId,
  });

  factory SurveyBoardGameRequest.fromJson(Map<String, dynamic> json) =>
      _$SurveyBoardGameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyBoardGameRequestToJson(this);
}

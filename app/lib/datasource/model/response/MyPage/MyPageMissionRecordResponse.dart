import 'package:json_annotation/json_annotation.dart';
import 'MyPageArchiveResponse.dart';

part 'MyPageMissionRecordResponse.g.dart';

@JsonSerializable()
class MyPageMissionRecordResponse {
  final String gameTitle;
  final String gameImage;
  final List<String> gameCategoryList;
  final int minAge;
  final int gameYear;
  final int minPlayer;
  final int maxPlayer;
  final int difficulty;
  final int playTime;
  final List<MyPageArchiveResponse> archiveList;

  MyPageMissionRecordResponse({
    required this.gameTitle,
    required this.gameImage,
    required this.gameCategoryList,
    required this.minAge,
    required this.gameYear,
    required this.minPlayer,
    required this.maxPlayer,
    required this.difficulty,
    required this.playTime,
    required this.archiveList,
  });

  factory MyPageMissionRecordResponse.fromJson(Map<String, dynamic> json) =>
      _$MyPageMissionRecordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyPageMissionRecordResponseToJson(this);
}

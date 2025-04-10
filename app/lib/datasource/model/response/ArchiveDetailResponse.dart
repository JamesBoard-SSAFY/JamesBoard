import 'package:json_annotation/json_annotation.dart';

part 'ArchiveDetailResponse.g.dart';

@JsonSerializable()
class ArchiveDetailResponse {
  final int archiveId;
  final int userId;
  final String userNickName;
  final String userProfile;
  final String archiveContent;
  final int gameId;
  final String gameTitle;
  final int archiveGamePlayTime;
  final int archiveGamePlayCount;
  final List<String> archiveImageList;

  ArchiveDetailResponse({
    required this.archiveId,
    required this.userId,
    required this.userNickName,
    required this.userProfile,
    required this.archiveContent,
    required this.gameId,
    required this.gameTitle,
    required this.archiveGamePlayTime,
    required this.archiveGamePlayCount,
    required this.archiveImageList,
  });

  factory ArchiveDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ArchiveDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveDetailResponseToJson(this);
}

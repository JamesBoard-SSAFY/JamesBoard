import 'package:json_annotation/json_annotation.dart';

part 'ArchiveEditRequest.g.dart';

@JsonSerializable()
class ArchiveEditRequest {
  final int gameId;
  final String archiveContent;
  final List<String> archiveImageList;
  final int archiveGamePlayTime;
  final int archiveGamePlayCount;

  ArchiveEditRequest({
    required this.gameId,
    required this.archiveGamePlayCount,
    required this.archiveImageList,
    required this.archiveContent,
    required this.archiveGamePlayTime,
  });

  factory ArchiveEditRequest.fromJson(Map<String, dynamic> json) =>
      _$ArchiveEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveEditRequestToJson(this);
}

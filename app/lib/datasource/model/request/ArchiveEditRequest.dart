import 'package:json_annotation/json_annotation.dart';

part 'ArchiveEditRequest.g.dart';

@JsonSerializable()
class ArchiveEditRequest {
  final int gameId;
  final String archiveContent;
  final List<ArchiveImageList> archiveImageList;
  final String archiveGamePlayTime;
  final String archiveGamePlayCount;

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

@JsonSerializable()
class ArchiveImageList {
  final String archiveImageUrl;

  ArchiveImageList({
    required this.archiveImageUrl,
  });

  factory ArchiveImageList.fromJson(Map<String, dynamic> json) =>
      _$ArchiveImageListFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveImageListToJson(this);
}

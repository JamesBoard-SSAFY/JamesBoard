import 'package:json_annotation/json_annotation.dart';

part 'ArchiveListResponse.g.dart';

@JsonSerializable()
class ArchiveListResponse {
  final int archiveId;
  final String archiveImage;

  ArchiveListResponse({
    required this.archiveId,
    required this.archiveImage,
  });

  factory ArchiveListResponse.fromJson(Map<String, dynamic> json) =>
      _$ArchiveListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveListResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'MyPageArchiveResponse.g.dart';

@JsonSerializable()
class MyPageArchiveResponse {
  final int archiveId;
  final String createdAt;
  final String archiveContent;
  final int archiveGamePlayCount;
  final String archiveImage;

  MyPageArchiveResponse({
    required this.archiveId,
    required this.createdAt,
    required this.archiveContent,
    required this.archiveGamePlayCount,
    required this.archiveImage,
  });

  factory MyPageArchiveResponse.fromJson(Map<String, dynamic> json) => _$MyPageArchiveResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyPageArchiveResponseToJson(this);
}
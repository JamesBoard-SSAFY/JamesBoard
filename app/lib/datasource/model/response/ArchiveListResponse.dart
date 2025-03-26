/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

ArchiveListResponse archiveListResponseFromJson(String str) =>
    ArchiveListResponse.fromJson(json.decode(str));

String archiveListResponseToJson(ArchiveListResponse data) =>
    json.encode(data.toJson());

class ArchiveListResponse {
  ArchiveListResponse({
    required this.archiveId,
    required this.archiveImage,
  });

  int archiveId;
  String archiveImage;

  factory ArchiveListResponse.fromJson(Map<dynamic, dynamic> json) =>
      ArchiveListResponse(
        archiveId: json["archiveId"],
        archiveImage: json["archiveImage"],
      );

  Map<dynamic, dynamic> toJson() => {
        "archiveId": archiveId,
        "archiveImage": archiveImage,
      };
}

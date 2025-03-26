/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

ArchiveRegisterRequest archiveRegisterRequestFromJson(String str) =>
    ArchiveRegisterRequest.fromJson(json.decode(str));

String archiveRegisterRequestToJson(ArchiveRegisterRequest data) =>
    json.encode(data.toJson());

class ArchiveRegisterRequest {
  ArchiveRegisterRequest({
    required this.gameId,
    required this.archiveGamePlayCount,
    required this.archiveImageList,
    required this.archiveContent,
    required this.archiveGamePlayTime,
  });

  int gameId;
  int archiveGamePlayCount;
  List<ArchiveImageList> archiveImageList;
  String archiveContent;
  int archiveGamePlayTime;

  factory ArchiveRegisterRequest.fromJson(Map<dynamic, dynamic> json) =>
      ArchiveRegisterRequest(
        gameId: json["gameId"],
        archiveGamePlayCount: json["archiveGamePlayCount"],
        archiveImageList: List<ArchiveImageList>.from(
            json["archiveImageList"].map((x) => ArchiveImageList.fromJson(x))),
        archiveContent: json["archiveContent"],
        archiveGamePlayTime: json["archiveGamePlayTime"],
      );

  Map<dynamic, dynamic> toJson() => {
        "gameId": gameId,
        "archiveGamePlayCount": archiveGamePlayCount,
        "archiveImageList":
            List<dynamic>.from(archiveImageList.map((x) => x.toJson())),
        "archiveContent": archiveContent,
        "archiveGamePlayTime": archiveGamePlayTime,
      };
}

class ArchiveImageList {
  ArchiveImageList({
    required this.archiveImageUrl,
  });

  String archiveImageUrl;

  factory ArchiveImageList.fromJson(Map<dynamic, dynamic> json) =>
      ArchiveImageList(
        archiveImageUrl: json["archiveImageUrl"],
      );

  Map<dynamic, dynamic> toJson() => {
        "archiveImageUrl": archiveImageUrl,
      };
}

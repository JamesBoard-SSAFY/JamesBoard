/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

ArchiveDetailResponse archiveDetailResponseFromJson(String str) =>
    ArchiveDetailResponse.fromJson(json.decode(str));

String archiveDetailResponseToJson(ArchiveDetailResponse data) =>
    json.encode(data.toJson());

class ArchiveDetailResponse {
  ArchiveDetailResponse({
    required this.archiveImageList,
    required this.archiveContent,
    required this.gameTitle,
    required this.userNickName,
    required this.archiveId,
    required this.userProfile,
    required this.archiveGamePlayTime,
  });

  List<ArchiveImageList> archiveImageList;
  String archiveContent;
  String gameTitle;
  String userNickName;
  int archiveId;
  String userProfile;
  int archiveGamePlayTime;

  factory ArchiveDetailResponse.fromJson(Map<dynamic, dynamic> json) =>
      ArchiveDetailResponse(
        archiveImageList: List<ArchiveImageList>.from(
            json["archiveImageList"].map((x) => ArchiveImageList.fromJson(x))),
        archiveContent: json["archiveContent"],
        gameTitle: json["gameTitle"],
        userNickName: json["userNickName"],
        archiveId: json["archiveId"],
        userProfile: json["userProfile"],
        archiveGamePlayTime: json["archiveGamePlayTime"],
      );

  Map<dynamic, dynamic> toJson() => {
        "archiveImageList":
            List<dynamic>.from(archiveImageList.map((x) => x.toJson())),
        "archiveContent": archiveContent,
        "gameTitle": gameTitle,
        "userNickName": userNickName,
        "archiveId": archiveId,
        "userProfile": userProfile,
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

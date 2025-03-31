import 'package:json_annotation/json_annotation.dart';

part 'BoardGameTopResponse.g.dart';

@JsonSerializable()
class BoardGameTopResponse {
  final int gameId;
  final String gameImage;

  BoardGameTopResponse({
    required this.gameId,
    required this.gameImage,
  });

  factory BoardGameTopResponse.fromJson(Map<String, dynamic> json) =>
      _$BoardGameTopResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BoardGameTopResponseToJson(this);
}

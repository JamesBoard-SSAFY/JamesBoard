// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GenreStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreStats _$GenreStatsFromJson(Map<String, dynamic> json) => GenreStats(
      gameCategoryName: json['gameCategoryName'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$GenreStatsToJson(GenreStats instance) =>
    <String, dynamic>{
      'gameCategoryName': instance.gameCategoryName,
      'count': instance.count,
      'percentage': instance.percentage,
    };

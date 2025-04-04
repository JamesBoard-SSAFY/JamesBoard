import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'RecentSearches.dart';

part 'AppDatabase.g.dart';

@DriftDatabase(tables: [RecentSearches])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // 저장 (중복 제거 후 삽입)
  Future<void> saveRecentSearch(String keyword) async {
    await (delete(recentSearches)..where((t) => t.keyword.equals(keyword)))
        .go();

    await into(recentSearches).insert(RecentSearchesCompanion.insert(
      keyword: keyword,
    ));
  }

  // 조회 (최신순)
  Future<List<RecentSearche>> getRecentSearches() {
    return (select(recentSearches)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(10))
        .get();
  }

  // 개별 삭제
  Future<void> deleteSearch(int id) async {
    await (delete(recentSearches)..where((t) => t.id.equals(id))).go();
  }

  // 전체 삭제
  Future<void> clearSearches() async {
    await delete(recentSearches).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

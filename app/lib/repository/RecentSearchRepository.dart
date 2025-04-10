import 'package:jamesboard/datasource/model/local/AppDatabase.dart';

class RecentSearchRepository {
  final AppDatabase _db;

  RecentSearchRepository(this._db);

  // 최근 검색어 저장
  Future<void> saveRecentSearch(String keyword) {
    return _db.saveRecentSearch(keyword);
  }

  // 최근 검색어 최대 10개 최신순으로 가져오기
  Future<List<RecentSearche>> getRecentSearches() {
    return _db.getRecentSearches();
  }

  // 특정 검색어 삭제
  Future<void> deleteRecentSearch(int id) {
    return _db.deleteSearch(id);
  }

  // 전체 검색어 삭제
  Future<void> clearRecentSearches() {
    return _db.clearSearches();
  }
}

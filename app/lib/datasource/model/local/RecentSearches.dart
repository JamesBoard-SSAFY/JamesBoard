import 'package:drift/drift.dart';

class RecentSearches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get keyword => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

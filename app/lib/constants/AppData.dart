import 'AppString.dart';

class AppData {
  static const Map<String, List<String>> filterOptions = {
    AppString.keyCategory: [
      AppString.categoryParty,
      AppString.categoryStrategy,
      AppString.categoryEconomy,
      AppString.categoryAdventure,
      AppString.categoryRolePlaying,
      AppString.categoryFamily,
      AppString.categoryDeduction,
      AppString.categoryWar,
      AppString.categoryAbstractStrategy,
      AppString.categoryAny,
    ],
    AppString.keyMinPlayers: [
      AppString.playersSolo,
      AppString.playersDuo,
      AppString.playersTeam,
      AppString.playersAssemble,
      AppString.playersAny,
    ],
    AppString.keyDifficulty: [
      AppString.difficultyBeginner,
      AppString.difficultyIntermediate,
      AppString.difficultyAdvanced,
      AppString.difficultyAny,
    ],
    AppString.keyPlayTime: [
      AppString.playtimeUltraShort,
      AppString.playtimeShort,
      AppString.playtimeMedium,
      AppString.playtimeLong,
      AppString.playtimeAny,
    ],
  };

  static const List<String> filters = [
    AppString.keyCategory,
    AppString.keyMinPlayers,
    AppString.keyDifficulty,
    AppString.keyPlayTime
  ];

  static const Map<String, String> filterButtonMap = {
    AppString.keyCategory: AppString.filterGenre,
    AppString.keyMinPlayers: AppString.filterNumOfPersons,
    AppString.keyDifficulty: AppString.filterDifficulty,
    AppString.keyPlayTime: AppString.filterAvgGameTime
  };

  static const Map<String, String> filterQueryKeyMap = {
    AppString.filterGenre: AppString.keyCategory,
    AppString.filterNumOfPersons: AppString.keyMinPlayers,
    AppString.filterDifficulty: AppString.keyDifficulty,
    AppString.filterAvgGameTime: AppString.keyPlayTime
  };

  // 필터 매핑
  static const Map<String, String> filterDisplayMap = {
    AppString.playersSolo: AppString.playersSoloValue,
    AppString.playersDuo: AppString.playersDuoValue,
    AppString.playersTeam: AppString.playersTeamValue,
    AppString.playersAssemble: AppString.playersAssembleValue,
    AppString.playtimeUltraShort: AppString.playtimeUltraShortValue,
    AppString.playtimeShort: AppString.playtimeShortValue,
    AppString.playtimeMedium: AppString.playtimeMediumValue,
    AppString.playtimeLong: AppString.playtimeLongValue,
    AppString.difficultyBeginner: AppString.difficultyBeginnerValue,
    AppString.difficultyIntermediate: AppString.difficultyIntermediateValue,
    AppString.difficultyAdvanced: AppString.difficultyAdvancedValue,
    AppString.difficultyAny: AppString.difficultyAnyValue,
    AppString.categoryParty: AppString.categoryPartyValue,
    AppString.categoryStrategy: AppString.categoryStrategyValue,
    AppString.categoryEconomy: AppString.categoryEconomyValue,
    AppString.categoryAdventure: AppString.categoryAdventureValue,
    AppString.categoryRolePlaying: AppString.categoryRolePlayingValue,
    AppString.categoryFamily: AppString.categoryFamilyValue,
    AppString.categoryDeduction: AppString.categoryDeductionValue,
    AppString.categoryWar: AppString.categoryWarValue,
    AppString.categoryAbstractStrategy: AppString.categoryAbstractStrategyValue,
    AppString.categoryAny: AppString.categoryAnyValue,
  };

  static const Map<String, String> categoryMap = {
    AppString.categoryParty: AppString.categoryParty,
    AppString.categoryStrategy: AppString.categoryStrategy,
    AppString.categoryEconomy: AppString.categoryEconomy,
    AppString.categoryAdventure: AppString.categoryAdventure,
    AppString.categoryRolePlayingValue: AppString.categoryRolePlayingValue,
    AppString.categoryFamily: AppString.categoryFamily,
    AppString.categoryDeduction: AppString.categoryDeductionValue,
    AppString.categoryWar: AppString.categoryWar,
    AppString.categoryAbstractStrategy: AppString.categoryAbstractStrategyValue,
    AppString.categoryAny: AppString.categoryAny,
  };

  static const Map<String, int> difficultyMap = {
    AppString.difficultyBeginner: 0,
    AppString.difficultyIntermediate: 1,
    AppString.difficultyAdvanced: 2,
  };

  static const Map<int, String> difficultyStrMap = {
    0: AppString.difficultyBeginner,
    1: AppString.difficultyIntermediate,
    2: AppString.difficultyAdvanced,
  };

  static const Map<String, int> minPlayersMap = {
    AppString.playersSolo: 1,
    AppString.playersDuo: 2,
    AppString.playersTeam: 3,
    AppString.playersAssemble: 5,
  };

  static const Map<int, String> minPlayerStrMap = {
    1: AppString.playersSolo,
    2: AppString.playersDuo,
    3: AppString.playersTeam,
    5: AppString.playersAssemble,
  };

  static const Map<String, List<int>> playTimeMap = {
    AppString.playtimeUltraShort: [0, 30],
    AppString.playtimeShort: [60, 120],
    AppString.playtimeMedium: [120, 240],
    AppString.playtimeLong: [240, 9999],
  };

  static const Map<String, String> selectedFilters = {
    AppString.filterGenre: AppString.filterGenre,
    AppString.filterNumOfPersons: AppString.filterNumOfPersons,
    AppString.filterDifficulty: AppString.filterDifficulty,
    AppString.filterAvgGameTime: AppString.filterAvgGameTime
  };
}

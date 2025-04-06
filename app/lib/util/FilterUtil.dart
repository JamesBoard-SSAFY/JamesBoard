import '../constants/AppData.dart';

class FilterUtil {
  static Map<String, dynamic> buildRequestQueryParameters(
      Map<String, dynamic> queryParameters) {
    Map<String, dynamic> params = {};

    if (queryParameters.containsKey('difficulty')) {
      params['difficulty'] =
          AppData.difficultyMap[queryParameters['difficulty']];
    }

    if (queryParameters.containsKey('minPlayers')) {
      params['minPlayers'] =
          AppData.minPlayersMap[queryParameters['minPlayers']];
    }

    if (queryParameters.containsKey('category')) {
      params['category'] = queryParameters['category'];
    }

    if (queryParameters.containsKey('playTime')) {
      final List<int>? timeRange =
          AppData.playTimeMap[queryParameters['playTime']];
      if (timeRange != null) {
        params['minPlayTime'] = timeRange[0];
        params['maxPlayTime'] = timeRange[1];
      }
    }

    return params;
  }

  static Map<String, dynamic> buildFilterQueryParameters(
      Map<String, dynamic> queryParameters) {
    Map<String, dynamic> params = {};

    if (queryParameters.containsKey('difficulty')) {
      params['difficulty'] =
          AppData.difficultyStrMap[queryParameters['difficulty']];
    }

    if (queryParameters.containsKey('minPlayers')) {
      params['minPlayers'] =
          AppData.minPlayerStrMap[queryParameters['minPlayers']];
    }

    if (queryParameters.containsKey('category')) {
      params['category'] = queryParameters['category'];
    }

    if (queryParameters.containsKey("minPlayTime")) {
      params["playTime"] = queryParameters["minPlayTime"];
    }

    return params;
  }
}

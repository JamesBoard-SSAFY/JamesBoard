part of 'BoardGameService.dart';

class _BoardGameService implements BoardGameService {
  _BoardGameService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://j12d205.p.ssafy.io/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<BoardGameResponse>> getRecommendedGames({int limit = 10}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'limit': limit};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;

    final _options = Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    ).compose(
      _dio.options,
      'api/games/recommendations',
      queryParameters: queryParameters,
      data: _data,
    );

    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<BoardGameResponse> _value;

    logger.d("result: $_result");

    try {
      _value = _result.data!
          .map((dynamic i) =>
              BoardGameResponse.fromJson(i as Map<String, dynamic>))
          .toList();

      logger.d("getRecommendedGames: $_value");
    } on Object catch (e, s) {
      print('Error fetching recommended games: $e');
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<BoardGameResponse>> getBoardGames({
    int? difficulty,
    int? minPlayers,
    String? boardgameName,
    String? category,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    if (difficulty != null) queryParameters['difficulty'] = difficulty;
    if (minPlayers != null) queryParameters['minPlayers'] = minPlayers;
    if (boardgameName != null && boardgameName.isNotEmpty) {
      queryParameters['boardgameName'] = boardgameName;
    }
    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }

    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;

    final _options = Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    ).compose(
      _dio.options,
      'api/games',
      queryParameters: queryParameters,
      data: _data,
    );

    try {
      final _result = await _dio.fetch<List<dynamic>>(_options);
      logger.d("getBoardGames result: $_result");

      return _result.data!
          .map((dynamic i) =>
              BoardGameResponse.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      rethrow;
    }
  }
}

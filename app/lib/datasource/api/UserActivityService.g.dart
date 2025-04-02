part of 'UserActivityService.dart';

class _UserActivityService implements UserActivityService {
  _UserActivityService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://j12d205.p.ssafy.io/';
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<int> addUserActivity(UserActivityRequest request) async {
    final _headers = <String, dynamic>{};
    final _data = request.toJson();
    final _options = Options(
      method: 'POST',
      headers: _headers,
    )
        .compose(
          _dio.options,
          'api/user-activity',
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl);

    final _result = await _dio.fetch<int>(_options);
    return _result.data!;
  }

  @override
  Future<List<UserActivityResponse>> getUserActivity(
      int userId, int gameId) async {
    final _queryParameters = <String, dynamic>{
      'userId': userId,
      'gameId': gameId,
    };
    final _options = Options(
      method: 'GET',
    )
        .compose(
          _dio.options,
          'api/user-activity',
          queryParameters: _queryParameters,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl);

    final _result = await _dio.fetch<List<dynamic>>(_options);
    return _result.data!
        .map((e) => UserActivityResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> updateUserActivityRating(
    int userActivityId,
    UserActivityPatchRequest request,
  ) async {
    final _headers = <String, dynamic>{};
    final _data = request.toJson();
    final _options = Options(
      method: 'PATCH',
      headers: _headers,
    )
        .compose(
          _dio.options,
          'api/user-activity/$userActivityId',
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl);

    logger.d("updateUserActivityRating: ${_options.headers}");
    logger.d("updateUserActivityRating: ${_options.baseUrl}");

    final _result = await _dio.fetch<int>(_options);

    return _result.data!;
  }
}

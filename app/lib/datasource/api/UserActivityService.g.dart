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
}

import 'package:dio/dio.dart';

import '../datasource/api/LoginService.dart';
import '../datasource/model/request/RenewalAccessTokenRequest.dart';
import '../main.dart';

class DioProviderUtil {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://j12d205.p.ssafy.io/',
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await storage.read(key: 'accessToken');

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          // 401이면 accessToken이 만료.
          if (e.response?.statusCode == 401) {
            final refreshed = await refreshAccessToken();

            if (refreshed) {
              final newAccessToken = await storage.read(key: 'accessToken');
              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                // 재시도할 요청 정보 복제
                final clonedRequest = e.requestOptions;
                clonedRequest.headers['Authorization'] =
                    'Bearer $newAccessToken';

                try {
                  final retryResponse = await dio.fetch(clonedRequest);
                  return handler.resolve(retryResponse);
                } catch (err) {
                  return handler.next(err as DioError);
                }
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

  static final Dio chatDio = Dio(
    BaseOptions(
      baseUrl: 'https://j12d205.p.ssafy.io:9098/',
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await storage.read(key: 'accessToken');

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          // 401이면 accessToken이 만료.
          if (e.response?.statusCode == 401) {
            final refreshed = await refreshAccessToken();

            if (refreshed) {
              final newAccessToken = await storage.read(key: 'accessToken');
              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                // 재시도할 요청 정보 복제
                final clonedRequest = e.requestOptions;
                clonedRequest.headers['Authorization'] =
                    'Bearer $newAccessToken';

                try {
                  final retryResponse = await dio.fetch(clonedRequest);
                  return handler.resolve(retryResponse);
                } catch (err) {
                  return handler.next(err as DioError);
                }
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final dioForRefresh = Dio();
      final service = LoginService(dioForRefresh);

      final response = await service.renewalAccessToken(
        RenewalAccessTokenRequest(refreshToken: refreshToken),
      );

      await storage.write(key: 'accessToken', value: response.accessToken);
      await storage.write(key: 'refreshToken', value: response.refreshToken);
      await storage.write(key: 'userId', value: response.userId.toString());

      logger.d('accessToken 갱신 성공: ${response.accessToken}');
      return true;
    } catch (e) {
      logger.e('accessToken 갱신 실패: $e');
      return false;
    }
  }
}

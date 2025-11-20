import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class ApiClient {
  final Dio dio;
  final SegmentsApi segments;
  final ReviewsApi reviews;
  final UsersApi users;
  final WeatherApi weather;
  final SnowTypesApi snowTypes;
  final AuthenticationApi auth;

  String? _token;
  final void Function(RequestOptions, Response)? _on401;

  ApiClient._(
    this.dio,
    this.segments,
    this.reviews,
    this.users,
    this.weather,
    this.snowTypes,
    this.auth,
    this._token,
    this._on401,
  );

  factory ApiClient({
    required String baseUrl,
    String? token,
    void Function(RequestOptions, Response)? on401,
  }) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    final client = ApiClient._(
      dio,
      SegmentsApi(dio),
      ReviewsApi(dio),
      UsersApi(dio),
      WeatherApi(dio),
      SnowTypesApi(dio),
      AuthenticationApi(dio),
      token,
      on401,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          final t = client._token;
          if (t != null && t.isNotEmpty) {
            o.headers['Authorization'] = 'Bearer $t';
          }
          h.next(o);
        },
        onError: (e, h) {
          if (e.response?.statusCode == 401 && client._on401 != null) {
            client._on401!(e.requestOptions, e.response!);
          }
          h.next(e);
        },
      ),
    );

    return client;
  }

  void setToken(String? token) {
    _token = token;
  }
}

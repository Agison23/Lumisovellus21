import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class ApiClient {
  final Dio dio;
  final SegmentsApi segments;
  final UpdatesApi updates;
  final ReviewsApi reviews;
  final UsersApi users;
  final HelpRequestsApi helpRequests;
  final WeatherApi weather;

  ApiClient._(this.dio, this.segments, this.updates, this.reviews, this.users, this.helpRequests, this.weather);

  factory ApiClient({required String baseUrl, String? token, void Function(RequestOptions, Response)? on401}) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (o, h) {
        if (token != null && token.isNotEmpty) o.headers['Authorization'] = 'Bearer $token';
        h.next(o);
      },
      onError: (e, h) {
        if (e.response?.statusCode == 401 && on401 != null) on401(e.requestOptions, e.response!);
        h.next(e);
      },
    ));

    return ApiClient._(
      dio,
      SegmentsApi(dio),
      UpdatesApi(dio),
      ReviewsApi(dio),
      UsersApi(dio),
      HelpRequestsApi(dio),
      WeatherApi(dio),
    );
  }
}

import 'package:dio/dio.dart';
import '../components/constants.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response<dynamic>?> getData({
    required String url,
    required Map<String, dynamic> queryParameters,
  }) async {
    return await dio?.get(url, queryParameters: queryParameters);
  }
}

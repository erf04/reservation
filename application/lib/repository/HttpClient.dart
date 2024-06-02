import 'package:dio/dio.dart';

class HttpClient {
  static Dio instance = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000/"));
}

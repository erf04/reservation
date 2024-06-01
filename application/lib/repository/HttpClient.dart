import 'package:dio/dio.dart';

class HttpClient {
  String baseUrl;

  HttpClient({
    required this.baseUrl,
  });
  
  Dio getInstance() {
    return Dio(BaseOptions(baseUrl: baseUrl));
  }
}

import 'package:dio/dio.dart';

final String baseUrl = 'https://astories.info/public/';
final int connectTimeout = 10000;

class ApiClient {
  Dio dio = new Dio();

  ApiClient() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) async {
      return response;
    }, onError: (DioError e) async {
      // TODO show error popup
      print(e.response);
      return e;
    }));
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.headers['Accept'] = 'application/json';
  }

  // TODO

  Future<Response> getChapters() async {
    Response response = await dio.get('/info.json');
    return response;
  }

  // TODO
  Future<Response> loadChapter(String path) async {
    Response response = await dio.get(path);
    return response;
  }

  // TODO
  Future<Response> loadNotes(String path) async {
    Response response = await dio.get(path);
    return response;
  }
}

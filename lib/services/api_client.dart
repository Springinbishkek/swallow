import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lastochki/models/entities/Chapter.dart';
import 'package:path_provider/path_provider.dart';

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
    // response;
  }

  Future<Response> loadSource(String path, Function onReceiveProgress) async {
    Response response = await dio.get(
      path,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  Future<Response> downloadFiles(
      String path, Function onReceiveProgress) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Response response = await dio.download(
      path,
      '$tempPath/images.zip',
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // TODO
  Future<Response> loadNotes(String path) async {
    Response response = await dio.get(path);
    return response;
  }
}

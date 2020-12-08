import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final String baseUrl = 'https://lastochki.online/public/test/';
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
      var options = e.request;

      var result = await RM.navigate.toDialog(
        LInfoPopup(
          isCloseEnable: true,
          image: alertImg,
          title: noInternet.toString(),
          content: noInternetText.toString(),
          actions: LButton(
              icon: refreshIcon,
              buttonColor: whiteColor,
              text: tryMsg.toString(),
              fontSize: 10,
              height: 30,
              func: () async {
                var response =
                    await dio.request(options.path, options: options);
                RM.navigate.back(response);
              }),
        ),
      );
      return result ?? e;
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
      String path, String savingPath, Function onReceiveProgress) async {
    Response response = await dio.download(
      path,
      savingPath,
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

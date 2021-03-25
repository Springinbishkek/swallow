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
      print(e.response);
      RequestOptions options = e.request;
      var result = await RM.navigate.toDialog(
        getErrorDialog(options: options, error: e),
      );
      return result ?? e;
    }));
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.headers['Accept'] = 'application/json';
  }

  Widget getErrorDialog({RequestOptions options, DioError error}) {
    return LInfoPopup(
      isCloseEnable: true,
      image: alertImg,
      title: noInternet.toString(),
      content: noInternetText.toString(),
      actions: LButton(
          icon: refreshIcon,
          buttonColor: whiteColor,
          text: tryMsg.toString(),
          func: () async {
            Response response =
                await dio.request(options.path, options: options);
            RM.navigate.back(response);
          }),
    );
  }

  Future<Response> getChapters() async {
    Response response = await dio.get('/info.json');
    return response;
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

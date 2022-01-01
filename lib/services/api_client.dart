import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/translation.dart';
import 'package:lastochki/views/ui/l_button.dart';
import 'package:lastochki/views/ui/l_info_popup.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final String baseUrl = 'http://176.126.164.108/lake_test/';
final int connectTimeout = 10000;

class ApiClient {
  Dio dio = new Dio();

  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) async {
      print(e.response);
      RequestOptions options = e.requestOptions;
      Response /*?*/ response = await showErrorDialog(options: options);
      if (response != null) {
        handler.resolve(response);
      } else {
        handler.next(e);
      }
    }));
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.headers['Accept'] = 'application/json';
  }

  Future<Response /*?*/ > showErrorDialog({@required RequestOptions options}) {
    return RM.navigate.toDialog<Response>(
      getErrorDialog(options: options),
    );
  }

  Widget getErrorDialog({@required RequestOptions options}) {
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
            Response response = await dio.requestFrom(options);
            RM.navigate.back(response);
          }),
    );
  }

  Future<Response> getChapters() async {
    Response response = await dio.get('/info.json');
    return response;
  }

  Future<Response> loadSource(
    String path,
    ProgressCallback onReceiveProgress,
  ) async {
    Response response = await dio.get(
      path,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  Future<Response> downloadFiles(
    String path,
    String savingPath,
    ProgressCallback onReceiveProgress,
  ) async {
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

extension on Dio {
  Future<Response<T>> requestFrom<T>(RequestOptions options) {
    return request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      cancelToken: options.cancelToken,
      options: options.toOptions(),
      onSendProgress: options.onSendProgress,
      onReceiveProgress: options.onReceiveProgress,
    );
  }
}

// https://github.com/aloisdeniel/dio_retry/pull/12/files
extension on RequestOptions {
  Options toOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fx_crm/constant/app_constant.dart';

import '../../../controller/session_controller.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;

  late Dio dio;
  // late String token;
  String? _userToken;

  DioClient(this.baseUrl, Dio? dioC, {required this.loggingInterceptor}) {
    // token = AppConstants.authorizationToken;
    // log("DioClient x-api-key Token $token");
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: 30000)
      ..options.receiveTimeout = const Duration(milliseconds: 30000)
      ..httpClientAdapter
      ..options.headers = {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: '*/*',
        'X-API-KEY': AppConst.apiKey,
      }
      ..options.responseType = ResponseType.json;
    dio.interceptors.add(loggingInterceptor);
    // logger.f('DioClient ${dio.options.baseUrl}',
    //     tag: 'DioClient', error: dio.options.headers);
  }

  void updateHeader(String? token, {String? contentType}) {
    dio.options.headers = {
      Headers.acceptHeader: '*/*',
      Headers.contentTypeHeader:
          contentType ?? 'application/json; charset=UTF-8',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      'X-API-KEY': AppConst.apiKey,
    };
    log('🔵 updateHeader : ${dio.options.headers}');
  }

  void updateUserToken(String? userToken) {
    _userToken = userToken ?? _userToken;
    dio.options.headers.update(
      HttpHeaders.authorizationHeader,
      (val) => 'Bearer $_userToken',
      ifAbsent: () => 'Bearer $_userToken',
    );
    log('updateUserToken : ${dio.options.headers}');
  }

  void _checkSessionExpired(Response response) {
    if (response.data is Map<String, dynamic> &&
        response.data['is_login'] == 0) {
      SessionController.to.clearSession();
    }
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool token = true,
  }) async {
    try {
      CancelToken cancelToken = CancelToken();
      // pl('get : ${dio.options.headers} ${appStore.token}', 'DIO CLIENT');
      if (token) {
        updateUserToken(SessionController.to.token.value);
      }
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      _checkSessionExpired(response);
      return response;
    } on SocketException catch (err) {
      throw SocketException(err.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool token = true,
  }) async {
    try {
      CancelToken cancelToken = CancelToken();
      FormData formData = FormData();
      if (data is Map<String, dynamic>) {
        formData.fields.addAll(
          data.entries.toList().map((e) => MapEntry(e.key, e.value)),
        );
      } else {
        if (data == null) {
          formData = FormData();
        } else {
          formData = data as FormData;
        }
      }
      if (token) {
        formData.fields.add(
          MapEntry('login_token', SessionController.to.token.value),
        );
        updateUserToken(SessionController.to.token.value);
      }

      print('🟢token : ${SessionController.to.token.value}');
      log(
        '🟢 FormData fields: ${formData.fields} Headers: ${dio.options.headers}',
      );
      var response = await dio.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _checkSessionExpired(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      updateUserToken(SessionController.to.token.value);
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _checkSessionExpired(response);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      updateUserToken(SessionController.to.token.value);

      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _checkSessionExpired(response);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}

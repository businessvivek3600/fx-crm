import 'dart:async';

import 'package:nb_utils/nb_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../constant/enums.dart';
import '../dio_base_index.dart';

class ApiHandler {
  static String tag = 'ApiErrorHandler';
  static dynamic getMessage(error, {String? endpoint, bool showToast = true}) {
    dynamic errorDescription = "";
    if (error is DioException) {
      try {
        if (error.response?.data != null &&
            error.response?.data is Map<String, dynamic>) {
          debugPrint('ApiHandler error.response -: ${error.response?.data}');
          errorDescription =
              findErrorMessageInData(error.response?.data?['data']) ??
                  findErrorMessageInData(error.response?.data?['message']) ??
                  'Unexpected error occurred';
        } else if (DioExceptionType.values.contains(error.type)) {
          debugPrint('error.type -: ${error.type}');
          // logger.e(error.type, tag: tag, error: error);
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription =
                  "Connection timeout, please check your internet connection";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Connection failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection";
              break;
            case DioExceptionType.badCertificate:
              errorDescription =
                  "Error caused by an incorrect certificate as configured by ValidateCertificate";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout in connection";
              break;
            case DioExceptionType.connectionError:
              errorDescription =
                  "Connection error or socket exception error in connection";
              break;
            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 404:
                  errorDescription = 'Request not found';
                  break;
                case 500:
                  errorDescription = 'Internal server error';
                  break;
                case 503:
                  errorDescription = error.response?.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response?.data);
                  if (errorResponse.errors.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription =
                        "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
       // logger.e(e.source.toString(), tag: '$tag format exception', error: e);
        errorDescription = e.message;
      } catch (e) {
       // logger.e(e.toString(), tag: '$tag catch error', error: e);
        errorDescription = "Unexpected error occurred";
      }
    } else {
      errorDescription = "Unexpected error occurred";
    }

    return errorDescription;
  }

  static String? findErrorMessageInData(dynamic data) {
    String? errorDescription;
    if (data == null) return null;
    debugPrint('findErrorMessageInData => $data');
    if (data is String) errorDescription = data;
    if (data is Map<String, dynamic> && data.entries.isNotEmpty) {
      errorDescription = findErrorMessageInData(data.entries.first.value);
    }
    if (data is List && data.isNotEmpty) {
      errorDescription = findErrorMessageInData(data.first);
    }
    return errorDescription;
  }

  static Future<(bool, Map<String, dynamic>, String?)> fetchData(
      DioClient dioClient,
      String endPoint, {
    dynamic data,
    ApiMethod method = ApiMethod.POST,
    Options? options,
    bool token = true,
  }) async {
    try {
      Response res = await (method == ApiMethod.POST
          ? dioClient.post(endPoint, data: data, options: options, token: token)
          : dioClient.get(endPoint, options: options, token: token));
      ApiResponse? apiResponse;
      try {
        apiResponse = ApiResponse.withSuccess(res);
        if (res.data?['status'] == false) {
          // pl('[$endPoint] res.data: ${res.data}');
        }
      } catch (e) {
        apiResponse = ApiResponse.withError(findErrorMessageInData(res.data));
      }
      if (apiResponse.response != null) {
        return (
          (apiResponse.response?.data?['status'] as bool?) ?? false,
          (apiResponse.response?.data as Map<String, dynamic>?) ?? {},
          (apiResponse.response?.data?['message'] ??
              findErrorMessageInData(apiResponse.response?.data?['error']) ??
              '') as String,
        );
      } else {
        return (false, <String, dynamic>{}, apiResponse.error.toString());
      }
    } catch (e) {
      return (false, <String, dynamic>{}, findErrorMessageInData(e));
    }
  }

  /// return response
  static Future<(bool, Map<String, dynamic>, String?)> returnResponse({
    required Future<(bool, Map<String, dynamic>, String?)> Function() call,
    Future Function(bool, Map<String, dynamic>, String?)? onError,
    Future Function(bool, Map<String, dynamic>, String?)? onFalse,
    bool showToast = true,
    String? tag,
  }) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await call();
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        message = message?.split('.').first;
        if (showToast) {
          toast(message ?? 'Something went wrong',
              gravity: ToastGravity.TOP, bgColor: Colors.red);
        }
        await onFalse?.call(status, data, message);
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      // logger.e(tag ?? call.toString(),
      //     error: e, stackTrace: StackTrace.current);
    }
    return (false, <String, dynamic>{}, 'Something went wrong');
  }
}

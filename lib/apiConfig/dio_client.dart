import 'package:cuplex/apiConfig/dio_interceptor.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    headers: {
      'Authorization': 'Bearer $bearerToken',
    },
  ),
)..interceptors.add(DioInterceptor());



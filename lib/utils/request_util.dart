import 'package:dio/dio.dart';

class RequestUtil {
  RequestUtil._privateConstructor();

  static final RequestUtil _instance = RequestUtil._privateConstructor();

  factory RequestUtil() {
    return _instance;
  }

  Dio? _dio;

  /// 获取dio
  Dio getDio() {
    _dio ??= Dio(BaseOptions(baseUrl: "http://192.168.123.150:8080"));
    return _dio!;
  }

  /// get请求
  /// [url] 请求地址
  /// [params] 请求参数
  /// [data] 请求体
  /// 返回值为Response对象
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Object? data,
  }) async {
    try {
      Response response = await getDio().get(
        url,
        queryParameters: params,
        data: data,
      );
      return response;
    } catch (e) {
      throw Exception("请求失败: $e");
    }
  }

  /// post请求
  /// [url] 请求地址
  /// [params] 请求参数
  /// [data] 请求体
  /// 返回值为Response对象
  Future<Response> post(
    String url, {
    Map<String, dynamic>? params,
    Object? data,
  }) async {
    try {
      Response response = await getDio().post(
        url,
        queryParameters: params,
        data: data,
      );
      return response;
    } catch (e) {
      throw Exception("请求失败: $e");
    }
  }

  /// put请求
  /// [url] 请求地址
  /// [params] 请求参数
  /// [data] 请求体
  /// 返回值为Response对象
  Future<Response> put(
    String url, {
    Map<String, dynamic>? params,
    Object? data,
  }) async {
    try {
      Response response = await getDio().put(
        url,
        queryParameters: params,
        data: data,
      );
      return response;
    } catch (e) {
      throw Exception("请求失败: $e");
    }
  }

  /// delete请求
  /// [url] 请求地址
  /// [params] 请求参数
  /// [data] 请求体
  /// 返回值为Response对象
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? params,
    Object? data,
  }) async {
    try {
      Response response = await getDio().delete(
        url,
        queryParameters: params,
        data: data,
      );
      return response;
    } catch (e) {
      throw Exception("请求失败: $e");
    }
  }
}

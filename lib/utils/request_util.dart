import 'package:dio/dio.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/logger_util.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';

class RequestUtil {
  RequestUtil._privateConstructor();

  static final RequestUtil _instance = RequestUtil._privateConstructor();

  factory RequestUtil() {
    return _instance;
  }

  Dio? _dio;

  /// 获取dio
  Dio getDio() {
    _dio ??= Dio(BaseOptions(baseUrl: "http://134.175.119.27:8015"));
    _addTokenInterceptor(_dio!);
    _addLoginInvalidInterceptor(_dio!);
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
      LoggerUtil.e("请求失败: $e");
      return Response(
        data: {"code": 500, "msg": "请求失败: $e"},
        statusCode: 200,
        requestOptions: RequestOptions(path: url),
      );
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

  /// 添加token拦截器
  /// [dio] dio对象
  /// 返回值为void
  void _addTokenInterceptor(Dio dio) {
    final logic = Get.find<GlobalLogic>();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在这里添加token
          options.headers['Authorization'] = logic.getToken();
          return handler.next(options);
        },
      ),
    );
  }

  /// 添加登录失效拦截器
  /// [dio] dio对象
  /// 返回值为void
  void _addLoginInvalidInterceptor(Dio dio) {
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onResponse: (response, handler) {
          // 在这里处理登录失效的情况
          if (response.data['code'] == 401) {
            final logic = Get.find<GlobalLogic>();
            String? refreshToken = logic.getRefreshToken();
            if (refreshToken == null) {
              // 跳转到登录页面
              Get.offAllNamed(RouteConfig.login);
              return handler.next(response);
            }

            // 刷新token
            Map<String, dynamic> params = {"token": refreshToken};
            get("/user/refresh", params: params).then((value) async {
              if (value.data['code'] == 200) {
                String token = value.data['data']['token'];
                logic.setToken(token); // 更新token
                response.requestOptions.headers['Authorization'] = token;

                // 刷新成功，重新发送请求
                Response retryResponse = await getDio().request(
                  response.requestOptions.path,
                  data: response.requestOptions.data,
                  queryParameters: response.requestOptions.queryParameters,
                  options: Options(
                    method: response.requestOptions.method,
                    headers: response.requestOptions.headers,
                    extra: response.requestOptions.extra,
                    contentType: response.requestOptions.contentType,
                    responseType: response.requestOptions.responseType,
                    sendTimeout: response.requestOptions.sendTimeout,
                    receiveTimeout: response.requestOptions.receiveTimeout,
                    preserveHeaderCase:
                        response.requestOptions.preserveHeaderCase,
                    validateStatus: response.requestOptions.validateStatus,
                    followRedirects: response.requestOptions.followRedirects,
                    maxRedirects: response.requestOptions.maxRedirects,
                    receiveDataWhenStatusError:
                        response.requestOptions.receiveDataWhenStatusError,
                    requestEncoder: response.requestOptions.requestEncoder,
                    responseDecoder: response.requestOptions.responseDecoder,
                    listFormat: response.requestOptions.listFormat,
                    persistentConnection:
                        response.requestOptions.persistentConnection,
                  ),
                );

                handler.resolve(retryResponse);
              } else {
                // 跳转到登录页面
                Get.offAllNamed(RouteConfig.login);
              }
            });
          }
          return handler.next(response);
        },
      ),
    );
  }
}

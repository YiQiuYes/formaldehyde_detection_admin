import 'package:formaldehyde_detection/entity/ch2o_today_statistic_entity.dart';
import 'package:formaldehyde_detection/entity/client_entity.dart';
import 'package:formaldehyde_detection/utils/logger_util.dart';
import 'package:formaldehyde_detection/utils/request_util.dart';

class ClientApi {
  ClientApi._privateConstructor();

  static final ClientApi _instance = ClientApi._privateConstructor();

  factory ClientApi() {
    return _instance;
  }

  final _request = RequestUtil();

  /// 获取客户端列表
  /// [return] 客户端列表
  Future<List<ClientEntity>> clientALLList() async {
    return await _request.get("/client/allList").then((value) {
      final data = value.data;
      List<ClientEntity> list = [];
      if (data["code"] == 200) {
        for (var item in data["data"]) {
          list.add(ClientEntity.fromJson(item));
        }
      } else {
        LoggerUtil.e("获取客户端列表失败");
      }
      return list;
    });
  }

  /// 获取今日统计数据
  /// [clientId] 客户端ID
  /// [return] 今日统计数据
  Future<Ch2oTodayStatisticEntity?> clientTodayStatistic({
    required int clientId,
  }) async {
    Map<String, dynamic> params = {"clientId": clientId};

    return await _request.get("/ch2o/todayStatistic", params: params).then((
      value,
    ) {
      final data = value.data;
      if (data["code"] == 200) {
        return Ch2oTodayStatisticEntity.fromJson(data["data"]);
      } else {
        LoggerUtil.e("获取今日统计数据失败");
      }
      return null;
    });
  }

  /// 删除客户端
  /// [userId] 用户ID
  /// [return] 是否删除成功
  Future<bool> deleteUserToAuthenticator({
    required String userId,
    required String authenticator,
  }) async {
    Map<String, dynamic> params = {
      "userId": userId,
      "authenticator": authenticator,
    };

    return await _request
        .delete("/auth/deleteUserToAuthenticator", params: params)
        .then((value) {
          final data = value.data;
          if (data["code"] == 200) {
            return true;
          } else {
            LoggerUtil.e("删除客户端失败");
            return false;
          }
        });
  }

  /// 客户端注册
  /// [userId] 用户ID
  /// [password] 密码
  /// [authenticator] 认证器
  /// [isSuperuser] 是否为超级用户
  /// [address] 地址
  /// [return] 是否注册成功
  Future<bool> registerClient({
    required String userId,
    required String password,
    required String authenticator,
    required bool isSuperuser,
    required String address,
    required double safe,
    required double warn,
    required double danger,
  }) async {
    Map<String, dynamic> data = {
      "username": userId,
      "password": password,
      "authenticator": authenticator,
      "isSuperuser": isSuperuser,
      "address": address,
      "safe": safe,
      "warn": warn,
      "danger": danger,
    };

    return await _request
        .post("/auth/createUserToAuthenticator", data: data)
        .then((value) {
          final data = value.data;
          if (data["code"] == 200) {
            return true;
          } else {
            LoggerUtil.e("客户端注册失败");
            return false;
          }
        });
  }

  Future<List<String>> getAuthenticators() {
    return _request.get("/auth/authenticators").then((value) {
      final data = value.data;
      List<String> list = [];
      if (data["code"] == 200) {
        for (var item in data["data"]) {
          list.add(item["id"]);
        }
      } else {
        LoggerUtil.e("获取认证器列表失败");
      }
      return list;
    });
  }

  /// 更新设备
  /// [clientId] 客户端ID
  /// [newAddress] 新地址
  /// [newIsSuperuser] 新是否为超级用户
  /// [return] 是否更新成功
  Future<bool> updateDevice({
    required String authenticator,
    required String username,
    required String newAddress,
    required bool newIsSuperuser,
    required String newPassword,
    required double safe,
    required double warn,
    required double danger,
  }) async {
    Map<String, dynamic> data = {
      "authenticator": authenticator,
      "username": username,
      "password": newPassword,
      "isSuperuser": newIsSuperuser,
      "address": newAddress,
      "safe": safe,
      "warn": warn,
      "danger": danger,
    };
    return await _request
        .post("/auth/updateUserToAuthenticator", data: data)
        .then((value) {
          final data = value.data;
          return data["code"] == 200;
        });
  }
}

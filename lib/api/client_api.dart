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
}

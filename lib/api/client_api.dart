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

  Future<List<ClientEntity>> clientList({int? page, int? limit}) async {
    Map<String, dynamic> params = {"page": page ?? 1, "limit": limit ?? 100};

    return await _request.get("/client/list", params: params).then((value) {
      final data = value.data;
      List<ClientEntity> list = [];
      if (data["code"] == 200) {
        for (var item in data["data"]["list"]) {
          list.add(ClientEntity.fromJson(item));
        }
      } else {
        LoggerUtil.e("获取客户端列表失败");
      }
      return list;
    });
  }
}

import 'package:formaldehyde_detection/utils/request_util.dart';

class MockApi {
  MockApi._privateConstructor();

  static final MockApi _instance = MockApi._privateConstructor();

  factory MockApi() {
    return _instance;
  }

  final _request = RequestUtil();

  /// 模拟安全数据
  /// [userId] 用户id
  Future<void> mockSafe(String userId) async {
    await _request.get("/mock/safe", params: {"userId": userId});
  }

  /// 模拟警告数据
  /// [userId] 用户id
  Future<void> mockWarn(String userId) async {
    await _request.get("/mock/warn", params: {"userId": userId});
  }

  /// 模拟危险数据
  /// [userId] 用户id
  Future<void> mockDanger(String userId) async {
    await _request.get("/mock/danger", params: {"userId": userId});
  }

  /// 关闭模拟
  /// [userId] 用户id
  Future<void> close(String userId) async {
    await _request.get("/mock/close", params: {"userId": userId});
  }
}

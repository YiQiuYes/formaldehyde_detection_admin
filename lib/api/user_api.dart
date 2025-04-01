import 'package:formaldehyde_detection/entity/user_login_entity.dart';
import 'package:formaldehyde_detection/utils/request_util.dart';

class UserApi {
  UserApi._privateConstructor();

  static final UserApi _instance = UserApi._privateConstructor();

  factory UserApi() {
    return _instance;
  }

  final _request = RequestUtil();

  Future<UserLoginEntity?> login({
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> data = {"username": username, "password": password};

    return await _request.post("/user/login", data: data).then((value) {
      final data = value.data;

      if (data["code"] == 200) {
        UserLoginEntity userLoginEntity = UserLoginEntity.fromJson(data["data"]);
        return userLoginEntity;
      }
      return null;
    });
  }
}

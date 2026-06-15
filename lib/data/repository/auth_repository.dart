import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/response/user/auth_login_response.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({super.client});

  /// 1. Send SMS Code
  Future<ResultType<bool>> sendSmsCode(String mobile, int scene) async {
    return await networkClient
        .request('/app-api/member/auth/send-sms-code', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'scene': scene},
            isPublic: true)
        .mapResponse()
        .toValue<bool>();
  }

  /// 2. SMS Login
  Future<ResultType<AuthLoginResponse>> smsLogin(String mobile, String code) async {
    return await networkClient
        .request('/app-api/member/auth/sms-login', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'code': code},
            isPublic: true)
        .mapResponseTo(AuthLoginResponse.fromJson)
        .toObject();
  }

  /// 3. Login with Mobile & Password
  Future<ResultType<AuthLoginResponse>> login(String mobile, String password) async {
    return await networkClient
        .request('/app-api/member/auth/login', 
            type: NetworkType.post, 
            params: {'mobile': mobile, 'password': password},
            isPublic: true)
        .mapResponseTo(AuthLoginResponse.fromJson)
        .toObject();
  }

  /// 4. Logout
  Future<ResultType<bool>> logout() async {
    return await networkClient
        .request('/app-api/member/auth/logout', type: NetworkType.post)
        .mapResponse()
        .toValue<bool>();
  }

  /// 5. Reset Password (Forgot Password)
  Future<ResultType<bool>> resetPassword(String mobile, String code, String password) async {
    return await networkClient
        .request('/app-api/member/user/reset-password', 
            type: NetworkType.put, 
            params: {'mobile': mobile, 'code': code, 'password': password})
        .mapResponse()
        .toValue<bool>();
  }

  /// 6. Update Password (Register Step 3 or Change Password)
  Future<ResultType<bool>> updatePassword(String password, {String? code}) async {
    final Dictionary params = {'password': password};
    if (code != null) params['code'] = code;
    
    return await networkClient
        .request('/app-api/member/user/update-password', 
            type: NetworkType.put, 
            params: params)
        .mapResponse()
        .toValue<bool>();
  }

  /// 7. Refresh Token
  Future<ResultType<AuthLoginResponse>> refreshToken(String refreshToken) async {
    return await networkClient
        .request('/app-api/member/auth/refresh-token', 
            type: NetworkType.post, 
            params: {'refreshToken': refreshToken},
            isPublic: true)
        .mapResponseTo(AuthLoginResponse.fromJson)
        .toObject();
  }
}

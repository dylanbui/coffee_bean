/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 16:50
 * To change this template use File | Settings | File Templates.
 */

import 'dart:convert';

import 'package:coffee_bean/core/utils/base_secure_storage.dart';
import 'package:coffee_bean/data/local/user_session.dart';

class AuthStorageManager {
    final _base = BaseSecureStorage();

    static const _kAccess = 'coffee_access_token';
    static const _kRefresh = 'coffee_refresh_token';
    static const _kUser = 'coffee_user_session';

    /// Lưu toàn bộ session khi login thành công
    Future<void> saveFullSession({
        required String access,
        required String refresh,
        required UserSession user,
    }) async {
        await Future.wait([
            _base.write(_kAccess, access),
            _base.write(_kRefresh, refresh),
            _base.write(_kUser, jsonEncode(user.toJson())),
        ]);
    }

    /// Lấy thông tin User Profile
    Future<UserSession?> getUserProfile() async {
        final rawJson = await _base.read(_kUser);
        if (rawJson == null) return null;
        try {
            return UserSession.fromJson(jsonDecode(rawJson));
        } catch (e) {
            // Đề phòng trường hợp JSON lỗi hoặc thay đổi version model
            return null;
        }
    }

    // Triển khai Interface cho Network Layer
    Future<String?> getAccessToken() => _base.read(_kAccess);

    Future<String?> getRefreshToken() => _base.read(_kRefresh);

    Future<void> saveTokens(String access, String refresh) async {
        await _base.write(_kAccess, access);
        await _base.write(_kRefresh, refresh);
    }

    Future<void> clear() => _base.deleteAll();

    Future<bool> refresh() async {
        // Logic refresh token của bạn ở đây...
        return true;
    }
}

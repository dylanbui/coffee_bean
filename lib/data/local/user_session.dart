/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 10:41
 * To change this template use File | Settings | File Templates.
 */

import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/commons/utils/shared_preferences.dart';

import 'package:coffee_bean/commons/utils/base_secure_storage.dart';

part 'user_session.g.dart';

@JsonSerializable()
class UserSession {

  int id;
  String? userName;
  String? email;
  String? password;
  String? fullName;
  String? accessToken;
  String? refreshToken;

  // Chìa khóa cố định để dùng chung giữa các hàm
  static const String _sessionKey = "SESSION_USER";
  static const String _accessTokenKey = "access_token"; // Key lẻ để truy cập nhanh
  static const String _refreshTokenKey = "refresh_token";

  UserSession({required this.id, this.userName, this.email, this.password, this.fullName, this.accessToken, this.refreshToken});

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);

  /// Khởi tạo từ hệ thống
  static Future<UserSession> fromSystem() async {
    final dataString = await BaseSecureStorage().read(_sessionKey);
    if (dataString != null) {
      try {
        return UserSession.fromJson(jsonDecode(dataString));
      } catch (_) {}
    }
    return UserSession(id: -1);
  }

// ---------------------------------------------------------
  // CÁC HÀM TRUY CẬP NHANH CHO TOKEN INTERCEPTOR
  // ---------------------------------------------------------

  /// Đọc nhanh AccessToken
  static Future<String?> readAccessToken() async {
    return await BaseSecureStorage().read(_accessTokenKey);
  }

  /// Đọc nhanh RefreshToken
  static Future<String?> readRefreshToken() async {
    return await BaseSecureStorage().read(_refreshTokenKey);
  }

  /// Cập nhật nhanh AccessToken (Dùng sau khi refresh thành công)
  static Future<void> updateAccessToken(String newToken) async {
    await BaseSecureStorage().write(_accessTokenKey, newToken);

    // Lưu ý quan trọng: Cập nhật luôn vào Object UserSession tổng để đồng bộ dữ liệu
    final currentSession = await fromSystem();
    if (currentSession.id > 0) {
      currentSession.accessToken = newToken;
      await currentSession.saveToSystem();
    }
  }

  /// Xóa sạch mọi thứ
  static Future<void> clearAll() async {
    await BaseSecureStorage().deleteAll();
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }



}

extension SessionUserStatus on UserSession {

  bool isLogin() {
    return accessToken != null && id > 0;
  }

  bool isLogout() {
    return id <= 0 || accessToken == null;
  }

  /// Lưu user session và các key lẻ để truy cập nhanh
  Future<void> saveToSystem() async {
    final storage = BaseSecureStorage();

    await Future.wait([
      // Lưu "cả cục" JSON
      storage.write(UserSession._sessionKey, jsonEncode(toJson())),

      // Lưu lẻ Token để Interceptor đọc nhanh
      if (accessToken case final accessToken?)
        storage.write(UserSession._accessTokenKey, accessToken),
      if (refreshToken case final refreshToken?)
        storage.write(UserSession._refreshTokenKey, refreshToken),
    ]);
  }

}
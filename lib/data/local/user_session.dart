/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 10:41
 * To change this template use File | Settings | File Templates.
 */

import 'dart:convert';

import 'package:coffee_bean/core/utils/base_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';

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

  // Fixed scripts used across functions
  static const String _sessionKey = "SESSION_USER";
  static const String _accessTokenKey = "access_token"; // Separate key for quick access
  static const String _refreshTokenKey = "refresh_token";

  UserSession({required this.id, this.userName, this.email, this.password, this.fullName, this.accessToken, this.refreshToken});

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);

  /// Initialize from system storage
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
  // FAST ACCESS FUNCTIONS FOR TOKEN INTERCEPTOR
  // ---------------------------------------------------------

  /// Read AccessToken quickly
  static Future<String?> readAccessToken() async {
    return await BaseSecureStorage().read(_accessTokenKey);
  }

  /// Read RefreshToken quickly
  static Future<String?> readRefreshToken() async {
    return await BaseSecureStorage().read(_refreshTokenKey);
  }

  /// Update AccessToken quickly (Used after successful refresh)
  static Future<void> updateAccessToken(String newToken) async {
    await BaseSecureStorage().write(_accessTokenKey, newToken);

    // Important: Always update the main UserSession object to keep data in sync
    final currentSession = await fromSystem();
    if (currentSession.id > 0) {
      currentSession.accessToken = newToken;
      await currentSession.saveToSystem();
    }
  }

  /// Clear everything
  static Future<void> clearAll() async {
    await BaseSecureStorage().deleteAll();
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  // ---------------------------------------------------------
  // USER LOGIN STATUS
  // ---------------------------------------------------------

  /// Check if user is logged in
  /// Requirements: has accessToken AND id > 0
  bool isLogin() {
    return accessToken != null && accessToken!.isNotEmpty && id > 0;
  }

  /// Check if user is logged out
  bool isLogout() {
    return !isLogin();
  }

  /// Save user session and separate scripts for quick access
  Future<void> saveToSystem() async {
    final storage = BaseSecureStorage();

    await Future.wait([
      // Save entire JSON
      storage.write(UserSession._sessionKey, jsonEncode(toJson())),

      // Save separate Token for Interceptor quick read
      if (accessToken case final accessToken?)
        storage.write(UserSession._accessTokenKey, accessToken),
      if (refreshToken case final refreshToken?)
        storage.write(UserSession._refreshTokenKey, refreshToken),
    ]);
  }

  /// Logout: clear all session and token from storage
  /// Returns default UserSession with id = -1
  ///
  /// How to use:
  /// ```
  /// AppConfig().currentUser = await UserSession.doLogout();
  /// ```
  static Future<UserSession> doLogout() async {
    await clearAll();
    return UserSession(id: -1);
  }



}
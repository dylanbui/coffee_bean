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
  final int id;
  String? userName;
  String? email;
  String? avatarUrl;
  String? fullName;
  String? accessToken;
  String? refreshToken;

  UserSession({
    required this.id,
    this.userName,
    this.email,
    this.avatarUrl,
    this.fullName,
    this.accessToken,
    this.refreshToken,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);

  // Trạng thái đăng nhập nhanh dựa trên data hiện tại
  bool get isLogin => accessToken != null && accessToken!.isNotEmpty && id > 0;
  bool get isLogout => !isLogin;

  /// Bản rỗng đại diện cho trạng thái chưa đăng nhập hoặc đã đăng xuất
  factory UserSession.empty() => UserSession(id: -1);

  @override
  String toString() => jsonEncode(toJson());
}
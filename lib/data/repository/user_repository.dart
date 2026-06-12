import 'dart:convert';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/model/response/point_breakdown.dart';
import 'package:flutter/services.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/user.dart';
import 'package:coffee_bean/data/network/network_response.dart';

/// A repository that handles user related API requests.
class UserRepository extends BaseRepository {
  UserRepository({super.client});

  /// Lấy thông tin cá nhân (Profile)
  Future<ResultType<UserInfo>> getUserInfo() async {
    return await networkClient
        .request('/app-api/member/user/get', type: NetworkType.get)
        .mapResponseTo(UserInfo.fromJson)
        .toObject();
  }

  /// Lấy danh sách users (Sử dụng cấu trúc Wrapper Project)
  Future<ResultType<List<User>>> fetchUsers() async {
    return await networkClient
        .request('/users')
        .mapResponseTo(User.fromJson)
        .toList();
  }

  /// Lấy chi tiết user
  Future<ResultType<User>> fetchUserDetail(int userId) async {
    return await networkClient
        .request('/users/$userId')
        .mapResponseTo(User.fromJson)
        .toObject();
  }

  /// Tạo user mới với POST data (Theo yêu cầu của bạn)
  Future<ResultType<User>> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final postData = {
      'name': name,
      'email': email,
      'password': password,
      'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
    };

    return await networkClient
        .request(
          '/users',
          type: NetworkType.post,
          params: postData,
        )
        .mapResponseTo(User.fromJson)
        .toObject();
  }

  /// Ví dụ cũ dùng Local JSON
  Future<(List<PointBreakdownItem>?, NetworkError?)> fetchPointBreakdown({int offset = 0, int limit = 20}) async {
    try {
      final String response = await rootBundle.loadString('assets/json/reward_point_history.json');
      final data = await json.decode(response);
      if (data['history'] != null) {
        final List<dynamic> jsonList = data['history'];
        final allItems = jsonList.map((j) => PointBreakdownItem.fromJson(j)).toList();
        
        final start = offset;
        final end = (offset + limit) > allItems.length ? allItems.length : (offset + limit);
        
        if (start >= allItems.length) return (<PointBreakdownItem>[], null);
        
        // Giả lập delay mạng
        await Future.delayed(const Duration(milliseconds: 500));
        
        return (allItems.sublist(start, end), null);
      }
      return (<PointBreakdownItem>[], null);
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }
}

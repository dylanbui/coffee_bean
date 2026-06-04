import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:coffee_bean/data/model/user.dart';
import 'package:coffee_bean/data/model/response/reward_point_history.dart';

/// A repository that handles user related API requests.
class UserRepository extends BaseRepository {
  UserRepository({super.client});
  // In a real app, you would inject the NetworkClient,
  // but for simplicity, we get it from the global service locator.
  // final _client = serviceLocator.get<NetworkClient>();

  /// Fetches a list of users from the API.
  // Future<List<User>?, NetworkError> fetchUsers() async {
  //   // Using the fluent interface for network calls.
  //   // This assumes the API returns a raw list of JSON objects.
  //   return await networkClient
  //       .request('users') // Endpoint: 'https://api.escuelajs.co/api/v1/users'
  //       .mapTo<User>(User.fromJson)
  //       .toList();
  // }

  Future<(List<User>?, NetworkError?)> fetchUsers() async {
    return await networkClient.request('/users').mapToObjectList(User.fromJson);
  }

  /// Fetches details for a single user by their ID.
  Future<(User?, NetworkError?)> fetchUserDetail(int userId) async {
    return await networkClient.request('/users/$userId').mapToObject<User>(User.fromJson);
  }

  Future<(List<RewardPointHistoryItem>?, NetworkError?)> fetchRewardPointHistory({int offset = 0, int limit = 20}) async {
    try {
      final String response = await rootBundle.loadString('assets/json/reward_point_history.json');
      final data = await json.decode(response);
      if (data['history'] != null) {
        final List<dynamic> jsonList = data['history'];
        final allItems = jsonList.map((j) => RewardPointHistoryItem.fromJson(j)).toList();
        
        final start = offset;
        final end = (offset + limit) > allItems.length ? allItems.length : (offset + limit);
        
        if (start >= allItems.length) return (<RewardPointHistoryItem>[], null);
        
        // Giả lập delay mạng
        await Future.delayed(const Duration(milliseconds: 500));
        
        return (allItems.sublist(start, end), null);
      }
      return (<RewardPointHistoryItem>[], null);
    } catch (e) {
      return (null, NetworkError(500, e.toString()));
    }
  }
}

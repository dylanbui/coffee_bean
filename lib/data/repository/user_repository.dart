import 'package:coffee_bean/commons/network/base_repository.dart';
import 'package:coffee_bean/commons/network/network_common.dart';
import 'package:coffee_bean/data/model/user.dart';

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
}
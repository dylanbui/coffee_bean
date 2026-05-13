import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/data/model/user.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';

/// The Presenter for the UserDetail module.
/// It implements the business logic for fetching and manipulating user data,
/// keeping the BLoC (Interactor) clean and focused on state management.
class UserDetailPresenter implements DbNotePresentable {
  final UserRepository _userRepository;

  UserDetailPresenter(this._userRepository);

  /// Fetches the details for a specific user.
  Future<(User?, BaseError?)> fetchUserDetail(int userId) async {
    final (user, error) = await _userRepository.fetchUserDetail(userId);
    if (error != null) {
      return (null, BaseError(error.code, error.message));
    }
    return (user, null);
  }

  /// Placeholder for an update user function.
  Future<(bool, BaseError?)> updateUser(User user) async {
    // In a real app, you would call something like:
    // final (success, error) = await _userRepository.updateUser(user.id, user.toJson());
    await Future.delayed(const Duration(milliseconds: 500));
    return (true, null);
  }

  @override
  void dispose() {
    // Clean up any resources if needed.
  }
}
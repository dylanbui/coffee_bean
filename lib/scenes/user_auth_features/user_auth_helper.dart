import 'package:coffee_bean/shared/i18n/locale_keys.g.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';


/// Lớp cha cho tất cả các Event về Auth
abstract class UserAuthEvent extends DbBaseEvent {}

/// Event khi người dùng đăng nhập thành công
class UserLoginSuccessEvent extends UserAuthEvent {
  final UserSession userSessionData;
  UserLoginSuccessEvent(this.userSessionData);
}

/// Event khi người dùng đăng xuất
class UserLogoutEvent extends UserAuthEvent {}

/// Event khi người dùng hủy bỏ quá trình đăng nhập (đóng modal)
class UserLoginCancelledEvent extends UserAuthEvent {}

/// Event khi đăng nhập thất bại
class UserLoginFailureEvent extends UserAuthEvent {
  final String message;
  UserLoginFailureEvent(this.message);
}


/// AuthHelperListener: Interface to handle authentication events.
/// Interactors or Routers should implement this to receive results from AuthHelper.
abstract interface class AuthHelperListener {
  /// Called when the user is successfully authenticated.
  /// [userData] contains the session information.
  /// [isNewLogin] is true if the user just completed the login flow, 
  /// false if they were already logged in.
  void onAuthSuccess(UserSession userData, bool isNewLogin);

  /// Called when the user cancels the authentication process.
  void onAuthCancelled(DbError error);
}

/// AuthHelper: A utility class that encapsulates authentication logic and flows.
/// Instead of using static methods, it uses an instance-based approach with a listener.
class AuthHelper implements UserAuthFlowListener {
  final DbNoteRoutable _parentRouter;
  AuthHelperListener? _listener;

  AuthHelper(this._parentRouter);

  /// Returns true if the user is currently logged in.
  bool get isLoggedIn => UserManager().isLogin;

  /// Returns the current user's session data, or null if not logged in.
  UserSession? get currentUser => UserManager().currentUser;

  /// Executes an action that requires authentication.
  /// If already logged in, it triggers [onAuthFlowSuccess] immediately.
  /// If not, it launches the [UserAuthFlow].
  void runWithAuth(AuthHelperListener listener, {AuthStartStep startStep = AuthStartStep.login}) {
    _listener = listener;

    if (isLoggedIn && currentUser != null) {
      _listener?.onAuthSuccess(currentUser!, false);
    } else {
      // Initialize the auth flow with a modal transition
      final authFlow = UserAuthFlow(
        startStep: startStep,
        transitionType: PageTransitionType.bottomToTop,
      );

      // The helper itself acts as a proxy listener for the flow
      authFlow.start(_parentRouter, this);
    }
  }

  /// Convenience method to specifically start the Login flow.
  void login(AuthHelperListener listener) {
    runWithAuth(listener, startStep: AuthStartStep.login);
  }

  /// Convenience method to specifically start the Registration flow.
  void register(AuthHelperListener listener) {
    runWithAuth(listener, startStep: AuthStartStep.register);
  }

  // --- Implementation of UserAuthFlowListener (Internal Proxy) ---

  @override
  void onAuthFlowCompleted(AuthResult result) {
    if (result case LoginSuccess(:final session) || RegisterSuccess(:final session)) {
      // Broadcast global login success event
      locator<DbEventBus>().fire(UserLoginSuccessEvent(session));
      _listener?.onAuthSuccess(session, true);
      _listener = null; // Clear listener reference after completion
    } else if (result is ResetPasswordSuccess) {
      // Đối với ResetPassword, Helper này có thể không cần trả về gì đặc biệt cho Listener ban đầu
      // vì bối cảnh thường là người dùng tự ý đi đổi pass.
      // Tuy nhiên để an toàn, có thể trả về Cancelled với một code đặc thù nếu cần.
      _listener = null;
    }
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    _listener?.onAuthCancelled(error);
    _listener = null; // Clear listener reference after cancellation
  }
}

/// ActionAuthListener: A convenient implementation of AuthHelperListener using callbacks.
class ActionAuthListener implements AuthHelperListener {
  final void Function(UserSession userData, bool isNewLogin)? onSuccess;
  final void Function(DbError error)? onError;

  ActionAuthListener({this.onSuccess, this.onError});

  @override
  void onAuthSuccess(UserSession userData, bool isNewLogin) => onSuccess?.call(userData, isNewLogin);

  @override
  void onAuthCancelled(DbError error) => onError?.call(error);
}

extension AuthHelperExt on AuthHelper {
  /// Requires authentication before performing an action.
  /// If not logged in, it shows a confirmation dialog.
  Future<void> requireAuth({
    required BuildContext context,
    required void Function(UserSession userData, bool isNewLogin) onAuthenticated,
    String? confirmMessage,
    void Function(DbError error)? onCancel,
  }) async {
    if (isLoggedIn && currentUser != null) {
      onAuthenticated(currentUser!, false);
      return;
    }

    // Show login confirmation dialog
    final bool? confirm = await FlashDialogHelper.show<bool>(
      context: context,
      title: LocaleKeys.notifications_auth_login_required.tr(),
      content: confirmMessage ?? LocaleKeys.notifications_auth_login_required_msg.tr(),
      actions: [
        FlashDialogAction(label: LocaleKeys.general_action_cancel.tr(), value: false),
        FlashDialogAction(label: LocaleKeys.general_action_login.tr(), value: true, color: TMLabsColor.primary),
      ],
    );

    if (confirm != true) {
      onCancel?.call(const DbError(100, "User cancelled login dialog"));
      return;
    }

    // Start the login flow
    runWithAuth(ActionAuthListener(
      onSuccess: (userData, isNewLogin) => onAuthenticated(userData, isNewLogin),
      onError: (error) {
        // The caller will handle error display if needed via onCancel
        onCancel?.call(error);
      },
    ));
  }
}


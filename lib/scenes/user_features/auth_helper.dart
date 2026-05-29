import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/commons_constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_features/user_auth_flow.dart';

/// AuthHelperListener: Interface to handle authentication events.
/// Interactors or Routers should implement this to receive results from AuthHelper.
abstract interface class AuthHelperListener {
  /// Called when the user is successfully authenticated.
  /// [userData] contains the session information.
  void onAuthSuccess(UserSession userData);

  /// Called when the user cancels the authentication process.
  void onAuthCancelled(DbError error);
}

/// AuthHelper: A utility class that encapsulates authentication logic and flows.
/// Instead of using static methods, it uses an instance-based approach with a listener.
class AuthHelper implements UserAuthFlowListener {
  final DbNoteRouter _parentRouter;
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
      _listener?.onAuthSuccess(currentUser!);
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
  void onAuthFlowSuccess(UserSession userData) {
    _listener?.onAuthSuccess(userData);
    _listener = null; // Clear listener reference after completion
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    _listener?.onAuthCancelled(error);
    _listener = null; // Clear listener reference after cancellation
  }
}

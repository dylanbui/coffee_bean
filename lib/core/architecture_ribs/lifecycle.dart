/// DbLifecycle: Interface for managing the activation and resignation of business logic components.
///
/// This interface is typically implemented by Interactors or Bloc components to synchronize
/// their operational lifecycle with the UI's lifecycle.
///
/// ### Usage:
/// ```dart
/// class MyInteractor implements DbLifecycle {
///   @override
///   void didBecomeActive() {
///     // Initialize data, start listeners
///   }
///
///   @override
///   void willResignActive() {
///     // Clean up resources, cancel subscriptions
///   }
/// }
/// ```
abstract class DbLifecycle {
  /// Called when the component becomes active (e.g., when the corresponding View is mounted).
  void didBecomeActive();

  /// Called when the component is about to become inactive (e.g., when the View is disposed).
  void willResignActive();
}

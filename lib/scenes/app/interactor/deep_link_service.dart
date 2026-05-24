import 'dart:async';

import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app/app_router.dart';

// For a real implementation, you would use a package like uni_links:
// import 'package:uni_links/uni_links.dart';

/// A specialized service to handle incoming deep links.
/// It parses the URI and emits a structured `DbNoteRoute` for the AppInteractor to handle.
/// NOTE: This should be registered as a singleton in your service locator (e.g., locator.dart).
class DeepLinkService {
  // Singleton pattern
  DeepLinkService._privateConstructor();
  static final DeepLinkService _instance = DeepLinkService._privateConstructor();
  factory DeepLinkService() {
    return _instance;
  }

  final _routeController = StreamController<DbNoteRoute>.broadcast();
  Stream<DbNoteRoute> get routeStream => _routeController.stream;

  bool _isInitialized = false;

  /// Initializes the service to listen for deep links.
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // --- This is example code using the uni_links package ---
    // try {
    //   // Get the initial link that opened the app
    //   final initialUri = await getInitialUri();
    //   if (initialUri != null) {
    //     _handleUri(initialUri);
    //   }
    //
    //   // Listen for subsequent links while the app is running
    //   uriLinkStream.listen((Uri? uri) {
    //     if (uri != null) {
    //       _handleUri(uri);
    //     }
    //   }, onError: (err) {
    //     // Handle errors from the stream
    //   });
    // } catch (e) {
    //   // Handle initialization errors
    // }
  }

  void _handleUri(Uri uri) {
    // Example URI: coffee_bean://users/123
    if (uri.host == 'users' && uri.pathSegments.isNotEmpty) {
      final userId = int.tryParse(uri.pathSegments.first);
      if (userId != null) {
        // _routeController.add(UserDetailRoute(userId: userId));
      }
    }
    // Add more parsing logic for other routes (e.g., products, orders)
  }

  void dispose() {
    _routeController.close();
  }
}

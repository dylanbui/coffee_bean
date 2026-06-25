// /**
//  * TRACKING SERVICE USAGE GUIDE
//  *
//  * 1. Simple Screen Tracking:
//  *    appTracking.uiScreen(screenName: 'HomeScreen', action: EventAction.open);
//  *
//  * 2. Event with Custom Parameters:
//  *    appTracking.uiScreen(
//  *      screenName: 'ProductDetail',
//  *      action: EventAction.view,
//  *      parameters: {'product_id': 'P123', 'category': 'Coffee'}
//  *    );
//  *
//  * 3. Product Activity Tracking:
//  *    appTracking.productAction(productId: 'P123', action: EventAction.click);
//  *
//  * 4. Authentication Tracking:
//  *    appTracking.authAction(action: EventAction.login, method: 'google');
//  *
//  * 5. Generic Event Logging:
//  *    appTracking.logEvent('promotion_click', parameters: {'promo_id': 'SUMMER_2024'});
//  *
//  * 6. Error & Crash Reporting:
//  *    appTracking.recordError(exception, stackTrace, reason: 'Network failure');
//  */

import 'package:db_core/db_core.dart';

/// Global Alias for easy access: appTracking.uiScreen(...)
TrackingService get appTracking => locator<TrackingService>();

/// Standardized actions for event tracking
enum EventAction { open, view, click, search, like, share, login, logout, checkout }

/// Data object for tracking events
class AnalyticsEvent {
  final String name;
  final Map<String, Object> parameters;
  AnalyticsEvent(this.name, this.parameters);
}

/// Interface for the Tracking Service
abstract class TrackingService {
  Future<void> log(AnalyticsEvent event);
  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false});
  Future<void> logMessage(String message);
}

/// Extension to provide concise methods for common tracking tasks
extension TrackingServiceExtension on TrackingService {
  void uiScreen({
    required String screenName,
    required EventAction action,
    Map<String, Object>? parameters,
  }) {
    log(AnalyticsEvent('ui_screen', {
      'screen_name': screenName,
      'action': action.name,
      if (parameters != null) ...parameters,
    }));
  }

  void productAction({
    required String productId,
    required EventAction action,
    Map<String, Object>? parameters,
  }) {
    log(AnalyticsEvent('product', {
      'product_id': productId,
      'action': action.name,
      if (parameters != null) ...parameters,
    }));
  }

  void authAction({
    required EventAction action,
    String? method,
    Map<String, Object>? parameters,
  }) {
    log(AnalyticsEvent('auth', {
      'action': action.name,
      if (method != null) 'method': method,
      if (parameters != null) ...parameters,
    }));
  }

  void logEvent(String name, {Map<String, Object>? parameters}) {
    log(AnalyticsEvent(name, parameters ?? {}));
  }
}

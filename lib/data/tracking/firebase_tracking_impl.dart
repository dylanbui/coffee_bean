import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'tracking_service.dart';
import 'tracking_context.dart';

class FirebaseTrackingImpl implements TrackingService {
  final FirebaseAnalytics _fbAnalytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _fbCrashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> log(AnalyticsEvent event) async {
    // Automatically inject global context and real-time user info
    final Map<String, Object> finalParams = {
      ...event.parameters,
      'session_id': TrackingContext.sessionId,
      'device_type': TrackingContext.deviceType ?? 'unknown',
      'app_version': TrackingContext.appVersion ?? 'unknown',
      'region': TrackingContext.region ?? 'VN',
      'user_id': UserManager().userInfo?.id.toString() ?? 'guest',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    await _fbAnalytics.logEvent(
      name: event.name,
      parameters: finalParams,
    );
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false}) async {
    await _fbCrashlytics.recordError(exception, stack, reason: reason, fatal: fatal);
  }

  @override
  Future<void> logMessage(String message) async {
    await _fbCrashlytics.log(message);
  }
}

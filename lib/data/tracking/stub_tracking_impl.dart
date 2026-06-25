import 'package:flutter/foundation.dart';
import 'package:coffee_bean/data/tracking/tracking_service.dart';
import 'package:coffee_bean/data/tracking/tracking_context.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';

class StubTrackingImpl implements TrackingService {
  @override
  Future<void> log(AnalyticsEvent event) async {
    final Map<String, Object> finalParams = {
      ...event.parameters,
      'session_id': TrackingContext.sessionId,
      'user_id': UserManager().userInfo?.id.toString() ?? 'guest',
    };
    debugPrint('Tracking(Stub): [${event.name}] $finalParams');
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false}) async {
    debugPrint('Tracking(Stub) Error: $exception');
  }

  @override
  Future<void> logMessage(String message) async {
    debugPrint('Tracking(Stub) Msg: $message');
  }
}

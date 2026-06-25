class TrackingContext {
  static String _sessionId = _generateNewId();
  static DateTime _lastActiveTime = DateTime.now();
  
  // Static Metadata
  static String? deviceType;
  static String? appVersion;
  static String? region;

  // Session timeout: 60 minutes
  static const int _sessionTimeoutInMinutes = 60;

  /// Returns the current session ID, automatically renewing it if the 30-minute inactivity limit is reached.
  static String get sessionId {
    final now = DateTime.now();
    if (now.difference(_lastActiveTime).inMinutes > _sessionTimeoutInMinutes) {
      _sessionId = _generateNewId();
    }
    _lastActiveTime = now;
    return _sessionId;
  }

  static String _generateNewId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Initialize tracking metadata during app startup
  static void init({String? version, String? type, String? reg}) {
    appVersion = version;
    deviceType = type;
    region = reg;
  }
}

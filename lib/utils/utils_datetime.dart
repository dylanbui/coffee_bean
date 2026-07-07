import 'package:intl/intl.dart';

/*
USAGE EXAMPLES:

1. Display UTC time from server to UI (local time):
   String displayDate = UtcUtils.toStrDateTime("2023-10-27T10:00:00Z", format: AppDateTimeFormat.full);
   // Output: "27/10/2023 17:00:00" (if GMT+7)

2. Convert local input to UTC for API:
   String apiPayload = UtcUtils.toUtcIsoString("27/10/2023", format: AppDateTimeFormat.dateOnly);
   // Output: "2023-10-26T17:00:00.000Z" (if GMT+7)

3. Check token expiration:
   bool needsRefresh = UtcUtils.isExpired(token.expiry, buffer: Duration(minutes: 5));

4. Add/Subtract time:
   DateTime tomorrow = DateTime.now().add(Duration(days: 1));

5. Extension usage on DateTime:
   String localStr = DateTime.now().toStrDateTime(format: AppDateTimeFormat.shortDateOnly);
   String utcStr = DateTime.now().toUtcIsoString();

6. Extension usage on String:
   DateTime? dt = "27/10/2023".toDateTime();
   DateTime? fromIso = "2023-10-27T10:00:00.000Z".toDateTimeFromIso();
*/

enum AppDateTimeFormat {
  /// dd/MM/yyyy HH:mm:ss
  fullDatetime("dd/MM/yyyy HH:mm:ss"),
  /// dd/MM/yyyy HH:mm
  full("dd/MM/yyyy HH:mm"),
  /// dd/MM/yyyy
  dateOnly("dd/MM/yyyy"),
  /// dd/MM
  shortDateOnly("dd/MM"),
  /// HH:mm:ss
  timeOnly("HH:mm:ss"),
  /// yyyy-MM-dd
  isoDate("yyyy-MM-dd");

  final String pattern;
  const AppDateTimeFormat(this.pattern);
}

class UtcUtils {

  /// Converts UTC milliseconds since epoch to local DateTime
  static DateTime fromUtcMs(int ms) {
    return DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
  }

  /// Converts dynamic input (String ISO or int Timestamp) to local DateTime. Returns null if parsing fails
  static DateTime? toDateTimeSafe(dynamic input) {
    if (input == null) return null;
    if (input is int) return DateTime.fromMillisecondsSinceEpoch(input).toLocal();
    if (input is String) return DateTime.tryParse(input)?.toLocal();
    return null;
  }

  /// Receives UTC string from server (ISO 8601) and converts to local DateTime
  static DateTime toDateTime(String utcString, {DateTime? defaultValue}) {
    final fallback = defaultValue ?? DateTime.now();
    if (utcString.isEmpty) return fallback;
    try {
      return DateTime.parse(utcString).toLocal();
    } catch (_) {
      return fallback;
    }
  }

  /// Converts ISO 8601 string to local DateTime. Returns null if parsing fails
  static DateTime? toDateTimeFromIso(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    return DateTime.tryParse(isoString)?.toLocal();
  }

  /// Receives dynamic input (ISO String or Timestamp int) and displays in local timezone
  static String toDateTimeStr(
    dynamic input, {
    AppDateTimeFormat format = AppDateTimeFormat.dateOnly,
  }) {
    final dateTime = toDateTimeSafe(input);
    if (dateTime == null) return "";
    return formatDateTime(dateTime, format: format);
  }

  /// Receives local string based on [format] and converts to UTC ISO 8601 for server storage
  static String toUtcIsoString(
    String localString, {
    AppDateTimeFormat format = AppDateTimeFormat.dateOnly,
  }) {
    if (localString.isEmpty) return "";
    try {
      // Parse as local time first, then convert to UTC
      final localDateTime = DateFormat(format.pattern).parse(localString);
      return localDateTime.toUtc().toIso8601String();
    } catch (_) {
      return "";
    }
  }

  /// Converts String to DateTime based on format. Returns null if parsing fails
  static DateTime? parseDateTime(
    String dateString, {
    AppDateTimeFormat format = AppDateTimeFormat.dateOnly,
  }) {
    if (dateString.isEmpty) return null;
    try {
      return DateFormat(format.pattern).parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Formats directly from DateTime (UTC or local) to local timezone
  static String formatDateTime(
    DateTime dateTime, {
    AppDateTimeFormat format = AppDateTimeFormat.dateOnly,
  }) {
    return DateFormat(format.pattern).format(dateTime.toLocal());
  }

  /// Formats DateTime to UTC ISO 8601 string for server
  static String formatToUtcIsoString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Calculates the duration between two points in time
  static Duration difference(DateTime dt1, DateTime dt2) {
    return dt1.difference(dt2);
  }

  /// Calculates the duration between current time and a specific time (UTC string)
  static Duration differenceWithNow(String utcString) {
    if (utcString.isEmpty) return Duration.zero;
    try {
      final dateTime = DateTime.parse(utcString).toUtc();
      final now = DateTime.now().toUtc();
      return dateTime.difference(now);
    } catch (_) {
      return Duration.zero;
    }
  }

  // --- Token Refresh & Expiry Utilities ---

  /// Checks if a time (Timestamp ms) has expired compared to device time
  /// [expiration]: Expiration time from server (int milliseconds)
  /// [buffer]: Safety margin before actual expiration (e.g., refresh 5 minutes early)
  static bool isExpired(int expiration, {Duration buffer = Duration.zero}) {
    try {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiration).toUtc();
      final now = DateTime.now().toUtc();
      // If "now + buffer" is after "expiryDate" -> considered expired
      return now.add(buffer).isAfter(expiryDate);
    } catch (_) {
      return true; // Parse error defaults to expired for safety
    }
  }

  /// Calculates remaining seconds until expiration
  static int secondsUntilExpiration(int expiration) {
    try {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiration).toUtc();
      final now = DateTime.now().toUtc();
      final difference = expiryDate.difference(now).inSeconds;
      return difference > 0 ? difference : 0;
    } catch (_) {
      return 0;
    }
  }

  /// Formats a timestamp (ms) to local timezone string
  static String formatTimestamp(int timestamp, {AppDateTimeFormat format = AppDateTimeFormat.full}) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return formatDateTime(dateTime, format: format);
  }
}

extension DateTimeFormatting on DateTime {
  /// Formats DateTime to desired format in local timezone
  String toDateTimeStr({AppDateTimeFormat format = AppDateTimeFormat.dateOnly}) {
    return UtcUtils.formatDateTime(this, format: format);
  }

  /// Formats DateTime to UTC ISO 8601 string for server
  String toUtcIsoString() {
    return UtcUtils.formatToUtcIsoString(this);
  }
}

extension StringDateTimeParsing on String {
  /// Converts string to DateTime with optional format. Returns null if unparseable
  DateTime? toDateTime({AppDateTimeFormat format = AppDateTimeFormat.dateOnly}) {
    return UtcUtils.parseDateTime(this, format: format);
  }

  /// Converts string to DateTime with optional format. Returns null if unparseable
  /// Default value : DateTime.now()
  DateTime toDateTimeFit({AppDateTimeFormat format = AppDateTimeFormat.dateOnly}) {
    return UtcUtils.parseDateTime(this, format: format) ?? DateTime.now();
  }

  /// Converts ISO 8601 string to DateTime (auto-detects ISO format)
  DateTime? toDateTimeFromIso() => UtcUtils.toDateTimeFromIso(this);

  /// Converts ISO 8601 string to DateTime (auto-detects ISO format)
  /// Default value : DateTime.now()
  DateTime toDateTimeFitFromIso({DateTime? defaultValue}) {
    return UtcUtils.toDateTime(this, defaultValue: defaultValue);
  }
}

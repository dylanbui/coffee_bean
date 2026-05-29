/*
 * Created with IntelliJ IDEA
 * Package: utils
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 16:29
 * To change this template use File | Settings | File Templates.
 */

import 'package:logger/logger.dart';

class DbLogger {

  // Yes, it uses Logger
  late Logger logger;

  // region Make Singleton Class
  static final DbLogger _singleton = DbLogger._internal();
  factory DbLogger() {
    return _singleton;
  }

  DbLogger._internal() {
    logger = Logger(
      filter: null, // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(
          methodCount: 0, // No method calls in the header for cleaner logs
          errorMethodCount: 5, // Shorter stacktrace for errors
          lineLength: 100, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          dateTimeFormat: DateTimeFormat.onlyTime // Only time is usually enough
      ),
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  }
  // endregion

}

void dLog(dynamic message) {
  DbLogger().logger.d(message);
}

void iLog(dynamic message) {
  DbLogger().logger.i(message);
}

void eLog(dynamic message, [dynamic error, StackTrace? stackTrace]) {
  DbLogger().logger.e(message, error: error, stackTrace: stackTrace);
}

void wLog(dynamic message) {
  DbLogger().logger.w(message);
}

void wtfLog(dynamic message) {
  // Use f (fatal) if using logger 2.x, or keep wtf for older versions
  // The current package seems to support wtf
  DbLogger().logger.wtf(message);
}

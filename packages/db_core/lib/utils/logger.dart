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
          methodCount: 2, // number of method calls to be displayed
          errorMethodCount: 8, // number of method calls if stacktrace is provided
          lineLength: 200, // width of the output
          colors: true, // Colorful log messages
          printEmojis: false, // Print an emoji for each log message
          dateTimeFormat: DateTimeFormat.dateAndTime // Should each log print contain a timestamp
      ),
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  }
  // endregion

}

void dLog(String message) {
  DbLogger().logger.d(message);
}

void iLog(String message) {
  DbLogger().logger.i(message);
}

void eLog(String message) {
  DbLogger().logger.e(message);
}

void wLog(String message) {
  DbLogger().logger.w(message);
}

void wtfLog(String message) {
  DbLogger().logger.wtf(message);
}
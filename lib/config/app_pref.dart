import 'package:coffee_bean/core/utils/shared_preferences.dart';

class AppPrefs {

  final String _firstRun = 'first_run';
  final String _firstTimeOpenApp = 'first_time_open_app';

  // 1. Private constructor
  AppPrefs._internal();
  // 2. Instance
  static final AppPrefs _instance = AppPrefs._internal();
  // 3. Factory constructor
  factory AppPrefs() {
    return _instance;
  }

  bool firstRun() {
    var firstRun = DbSharedPreferences().get(_firstRun) as bool;
    return firstRun;
  }

  void setFirstRun(bool isFirstRun) {
    DbSharedPreferences().set(_firstRun, isFirstRun);
  }

}

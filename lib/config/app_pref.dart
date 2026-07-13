import 'package:db_core/utils/shared_preferences.dart';

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

  int? getSelectedStoreId() {
    return DbSharedPreferences().get('selected_store_id') as int?;
  }

  void setSelectedStoreId(int id) {
    DbSharedPreferences().set('selected_store_id', id);
  }

  int getLastSyncTime(String key) {
    return DbSharedPreferences().get('last_sync_$key') as int? ?? 0;
  }

  void setLastSyncTime(String key, int timestamp) {
    DbSharedPreferences().set('last_sync_$key', timestamp);
  }
  
  List<String> getTopicInterested() {
    final dynamic data = DbSharedPreferences().get('OFFLINE_SELECTED_TOPICS');
    if (data is List) {
      return data.cast<String>();
    }
    return [];
  }

  void setTopicInterested(List<String> topics) {
    DbSharedPreferences().set('OFFLINE_SELECTED_TOPICS', topics);
  }

}

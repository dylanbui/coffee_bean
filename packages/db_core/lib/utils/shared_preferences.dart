/*
 * Created with IntelliJ IDEA
 * Package: utils
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 21/06/2022 - 10:27
 * To change this template use File | Settings | File Templates.
 */

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/*

class Data {
  final int id;
  final String data;

  Data({this.data, this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["data"] = this.data;
    return data;
  }
}

Data mappedData = Data(id: 1, data: "Lorem ipsum something, something...");
await FlutterSession().set('mappedData', mappedData);

Read values from the session:

dynamic token = await FlutterSession().get("token");


* */

// Base on shared_preferences non async
// https://github.com/jhourlad/flutter_session

class DbSharedPreferences {

  /// Initialize session container
  final Map _session = {};

  // Yes, it uses SharedPreferences
  late SharedPreferences prefs;

  // region Make Singleton Class
  static final DbSharedPreferences _singleton = DbSharedPreferences._internal();
  factory DbSharedPreferences() {
    return _singleton;
  }

  DbSharedPreferences._internal();

  // Start load on main()
  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  // endregion


  /// Item getter
  ///
  /// @param key String
  /// @returns dynamic
  dynamic get(String key) {
    // Ưu tiên lấy từ session cache để có dữ liệu ngay lập tức (cho dù chưa ghi xong xuống disk)
    if (_session.containsKey(key)) {
      return _session[key];
    }

    try {
      final val = prefs.get(key);
      if (val == null) return null;
      return json.decode(val.toString());
    } catch (e) {
      return prefs.get(key);
    }
  }

  /// Item setter
  ///
  /// @param key String
  /// @param value any
  /// @returns Future
  Future set(String key, value) async {
    // Cập nhật session cache ngay lập tức để các hàm get() gọi sau đó lấy được ngay
    _session[key] = value;

    // Detect item type và thực hiện ghi xuống disk
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else if (value is List) {
      await prefs.setString(key, jsonEncode(value));
    } else {
      try {
        await prefs.setString(key, jsonEncode(value.toJson()));
      } catch (e) {
        await prefs.setString(key, jsonEncode(value));
      }
    }
  }

  Future remove(String key) {
    return prefs.remove(key);
  }

}

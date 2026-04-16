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


  /// Item setter
  ///
  /// @param key String
  /// @returns Future
  dynamic get(key) {
    try {
      return json.decode(prefs.get(key).toString());
    } catch (e) {
      return prefs.get(key);
    }
  }

  /// Item setter
  ///
  /// @param key String
  /// @param value any
  /// @returns Future
  Future set(key, value) async {

    // Detect item type
    switch (value.runtimeType) {
    // String
      case String:
        {
          prefs.setString(key, value);
        }
        break;

    // Integer
      case int:
        {
          prefs.setInt(key, value);
        }
        break;

    // Boolean
      case bool:
        {
          prefs.setBool(key, value);
        }
        break;

    // Double
      case double:
        {
          prefs.setDouble(key, value);
        }
        break;

    // List<String>
      case List:
        {
          prefs.setStringList(key, value);
        }
        break;

    // Object
      default:
        {
          prefs.setString(key, jsonEncode(value.toJson()));
        }
    }

    // Add item to session container
    _session.putIfAbsent(key, () => value);
  }

}

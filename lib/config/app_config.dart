import 'dart:core';
import 'package:coffee_bean/data/local/session_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum Environment { dev,test, production }


class AppConfig {

  // Define singleton class
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() {
    return _instance;
  }

  SessionUser? currentUser;
  String path = "";
  String url = "";
  String email = "";
  String username = "";

  void init(Environment env) {
    switch (env) {
      case Environment.dev:
        path = "dev path";
        url = "dev url";
        email = "dev email";
        username = "dev username";
        break;
      case Environment.test:
        path = "test path";
        url = "test url";
        email = "test email";
        username = "test username";
        break;
      case Environment.production:
        path = "production path";
        url = "production url";
        email = "production email";
        username = "production username";
        break;
    }
  }
}



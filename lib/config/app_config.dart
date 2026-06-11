import 'dart:core';

enum Environment { dev,test, production }


class AppConfig {

  // Define singleton class
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() {
    return _instance;
  }

  // UserSession? currentUser;
  String path = "";
  String url = "";
  String email = "";
  String username = "";

  Map<String, String> defaultHeaders = {
    'tenantId': '162',
  };

  void init(Environment env) {
    switch (env) {
      case Environment.dev:
        path = "dev path";
        url = "https://inter.tmlabs.ai";
        email = "dev email";
        username = "dev username";
        defaultHeaders = {
          'tenantId': '162',
        };
        break;
      case Environment.test:
        path = "test path";
        url = "test url";
        email = "test email";
        username = "test username";
        defaultHeaders = {
          'tenantId': '162',
        };
        break;
      case Environment.production:
        path = "production path";
        url = "production url";
        email = "production email";
        username = "production username";
        defaultHeaders = {
          'tenantId': '162',
        };
        break;
    }
  }
}



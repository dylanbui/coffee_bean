


import 'package:coffee_bean/core/services/event_bus.dart';

/// --- AUTH EVENTS ---
abstract class AuthEvent extends DbBaseEvent {}

class UserLoginSuccessEvent extends AuthEvent {
  UserLoginSuccessEvent();
}

class UserLogoutEvent extends AuthEvent {
  UserLogoutEvent();
}

// import 'dart:core';

// import 'package:equatable/equatable.dart';
// import 'package:flutter/widgets.dart';

// Type alias
// typedef Integer = int;

// enum Environment { dev,test, production }
//
// // class NetworkConfig {
// //   static String baseURL = NetworkURL.DEV.url;
// // }
//
// class GlobalVariable {
//
//   // Define singleton class
//   GlobalVariable._internal();
//   static final GlobalVariable _instance = GlobalVariable._internal();
//   factory GlobalVariable() {
//     return _instance;
//   }
//
//   String path = "";
//   String url = "";
//   String email = "";
//   String username = "";
//
//   void init(Environment env) {
//     switch (env) {
//       case Environment.dev:
//         path = "dev path";
//         url = "dev url";
//         email = "dev email";
//         username = "dev username";
//         break;
//       case Environment.test:
//         path = "test path";
//         url = "test url";
//         email = "test email";
//         username = "test username";
//         break;
//       case Environment.production:
//         path = "production path";
//         url = "production url";
//         email = "production email";
//         username = "production username";
//         break;
//     }
//   }
// }


// class NetworkConfig {
//   static String baseURL = getBaseURL(Environment.fromEnv("ENV"));
//
//   static String getBaseURL(Environment env) {
//     switch (env) {
//       case Environment.DEV:
//         return NetworkURL.DEV.url;
//       case Environment.TEST:
//         return NetworkURL.TEST.url;
//       case Environment.PRODUCTION:
//         return NetworkURL.PRODUCTION.url;
//       default:
//         return NetworkURL.DEV.url;
//     }
//   }
// }
//
// enum Environment { DEV, TEST, PRODUCTION }
//
// extension EnvironmentExtension on Environment {
//   String get name {
//     switch (this) {
//       case Environment.DEV:
//         return "DEV";
//       case Environment.TEST:
//         return "TEST";
//       case Environment.PRODUCTION:
//         return "PRODUCTION";
//       default:
//         return "DEV";
//     }
//   }
// }

// enum NetworkURL {
//   DEV(Environment.DEV),
//   TEST(Environment.TEST),
//   PRODUCTION(Environment.PRODUCTION);
//
//   final Environment env;
//
//   const NetworkURL(this.env);
//
//   String get url {
//     return 'https://jsonplaceholder.typicode.com/';
//   }
// }
//
// extension NetworkURLExtention on NetworkURL {
//   String get url {
//     switch (this) {
//       case NetworkURL.DEV:
//         return 'https://jsonplaceholder.typicode.com/';
//       case NetworkURL.TEST:
//         return 'http://45.117.162.60:8081/sam/api/';
//       case NetworkURL.PRODUCTION:
//         return 'http://45.117.162.60:8081/sam/api/';
//       default:
//         return 'http://45.117.162.60:8081/sam/api/';
//     }
//   }
// }




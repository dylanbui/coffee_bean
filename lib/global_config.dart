import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum Environment { dev,test, production }


class GlobalVariable {

  // Define singleton class
  GlobalVariable._internal();
  static final GlobalVariable _instance = GlobalVariable._internal();
  factory GlobalVariable() {
    return _instance;
  }

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


// Type alias
// typedef Integer = int;
// void main() {
//   print(int == Integer); // true
// }


// Khong su dung dc
// class InheritedProvider<T> extends InheritedWidget {
//   final T inheritedData;
//
//   InheritedProvider({required Widget child, required this.inheritedData,}) : super(child: child);
//
//   @override
//   bool updateShouldNotify(InheritedProvider oldWidget) => inheritedData != oldWidget.inheritedData;
//   // static T of<T>(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>().runtimeType>() as InheritedProvider<T>).inheritedData;
//   static InheritedProvider<T>? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>().runtimeType>() as InheritedProvider<T>;
// }

// typedef Dictionary = Map<String, dynamic>;
//
// class NetworkConfig {
//   static String baseURL = NetworkURL.DEV.url;
// }
//
//
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
//
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
//
//
//
// // class BaseError {
// //
// //   final int code;
// //   final String messenger;
// //
// //   // Constructor
// //   const BaseError(this.code, this.messenger);
// // }
//
// abstract class BaseBlocState extends Equatable {
//
//   @override
//   List<Object> get props => [];
// }
//
// abstract class BaseBlocEvent extends Equatable {
//
//   @override
//   List<Object> get props => [];
//
// }
//
// class Data {
//   String text;
//   int counter;
//   String dateTime;
//   Data({required this.text, required this.counter, required this.dateTime});
//
//   // Data(this.text, this.counter, DateTime.now().toString()); // Loi ko chay dc
//
// }
//
// class User {
//   const User(this.userName, this.email, this.password,  this.value);
//
//   final String? userName;
//   final String? email;
//   final String? password;
//
//   final int value;
//
//
//
// // .. operator ==, hashCode
// }
//
// // Khong su dung dc
// class InheritedDataProvider extends InheritedWidget {
//   final Data data;
//   InheritedDataProvider({required Widget child, required this.data,}) : super(child: child);
//
//   @override
//   bool updateShouldNotify(InheritedDataProvider oldWidget) => data != oldWidget.data;
//   static InheritedDataProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
// }
//

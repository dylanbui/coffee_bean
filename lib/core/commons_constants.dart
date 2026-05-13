

import 'dart:core';
import 'package:flutter/material.dart';

typedef Dictionary = Map<String, Object?>;

class BaseError {

  final int code;
  final String message;

  // Constructor
  const BaseError(this.code, this.message);
}

class AppTheme {
  // const AppTheme();

  static const Color colorStart = Color(0xFF0d47a1);
  static const Color colorEnd = Color(0xFF1565c0);

  static const buttonGradient = LinearGradient(
    colors:  [colorStart, colorEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const TextStyle textStyle_1 = TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 30);
  static const TextStyle textStyle_2 = TextStyle(fontSize: 20);
  static const TextStyle textStyle_3 = TextStyle(color: Colors.red, fontSize: 15);

  static InputDecoration defaultInputDecoration(String text) {
    return InputDecoration(border: const OutlineInputBorder(), labelText: text,);
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

// class BaseError {
//
//   final int code;
//   final String messenger;
//
//   // Constructor
//   const BaseError(this.code, this.messenger);
// }

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

/*
 * Created with IntelliJ IDEA
 * Package: commons
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 28/06/2022 - 10:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';


// Class tham khao
class NavigatorUtils {

  static push(BuildContext context, Widget widget) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => widget));
  }

  static pushReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => widget));
  }

  static pushAndRemoveUntil(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => widget), (route) => false);
  }

  static pushResult(BuildContext context, Widget widget,Function function){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),)
        .then((result){
      if(null!=result){
        function(result);
      }
    }).catchError((error){
      print("$error");
    });
  }

  static back(BuildContext context){
    Navigator.maybePop(context);
  }

  static backResult(BuildContext context, result){
    Navigator.pop(context,result);
  }

  static pop(BuildContext context){
    Navigator.pop(context);
  }

}


// https://stackoverflow.com/questions/46259751/how-to-push-multiple-routes-with-flutter-navigator
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({ required WidgetBuilder builder }) : super(builder: builder);

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}

extension PushWithoutAnimation on Navigator {

  // Dung thang nay de push nhieu Page vao router, dung tao 1 line back app
  static Future pushWithoutAnimation(BuildContext context, Widget page) {
    Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
    return Navigator.of(context).push(route);
  }

  // Future pushWithoutAnimation(BuildContext fromContext, Widget page) {
  //   Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
  //   return this.push(context, route);
  // }

}
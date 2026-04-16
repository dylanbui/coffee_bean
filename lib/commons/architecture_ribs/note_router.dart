/*
 * Created with IntelliJ IDEA
 * Package: commons.architecture_ribs
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 11:10
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:flutter/material.dart';


abstract interface class DbNoteRoute {

}

abstract interface class DbNoteRoutable {
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters});
}

abstract class DbNoteRouter with DbNavigator implements DbNoteRoutable {

  DbNoteRouter? parentRouter;

  void displayRouterName() {
    // TODO: implement displayRouterName
  }

}

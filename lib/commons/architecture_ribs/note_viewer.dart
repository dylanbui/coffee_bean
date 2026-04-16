/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 11:02
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

/// Basic interface between a `Router` and the UIKit `UIViewController`.
mixin ViewControllable on Widget {
  Widget get viewController => this;
}

class NoteViewer {

  NoteViewer();

}
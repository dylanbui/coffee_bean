/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 15/08/2022 - 11:02
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

typedef ViewController = Widget;

// Framework Independent
abstract interface class DbNoteViewer {
  // Interface này có thể rỗng hoặc chứa các lệnh mà Router/Interactor
  // có thể gọi trực tiếp lên View (ví dụ: showLoading, hideLoading)
}

// Flutter Specific Adapter (Phần này sẽ thay đổi tùy framework)
/// Basic interface between a `Router` and the UIKit `UIViewController`.
mixin ViewControllable on Widget implements DbNoteViewer {
  // Hàm trung gian giúp chuyển đổi từ Abstract View sang Flutter Widget
  ViewController get viewController => this;
}
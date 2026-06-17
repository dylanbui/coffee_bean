import 'dart:async';
import 'package:flutter/material.dart';
import 'package:db_core/utils/network_checker.dart';
import 'package:db_core/architecture_ribs/navigator.dart';

mixin AppNetworkMixin<T extends StatefulWidget> on State<T> {
  late final DbNetworkChecker _networkChecker;
  bool _isOffline = false;
  late StreamSubscription _subNetworkChecker;

  bool get isOffline => _isOffline;

  void initNetworkLogic() {
    _networkChecker = DbNetworkChecker();
    _networkChecker.start();

    _subNetworkChecker = _networkChecker.stream.listen((status) {
      if (status is DbNetworkStatusOffline) {
        if (!_isOffline) setState(() => _isOffline = true);
      } else {
        if (_isOffline) {
          setState(() => _isOffline = false);
          refreshCurrentPage();
        }
      }
    });
  }

  void disposeNetworkLogic() {
    _subNetworkChecker.cancel();
    _networkChecker.dispose();
  }

  void refreshCurrentPage() {
    _networkChecker.recheck();
    final context = DbNavigator.globalNavigatorState.currentContext;
    if (context != null) {
      // Ví dụ: gọi Bloc hoặc interactor để refresh
      // BlocProvider.of<ReservationListInteractor>(context).onRefresh();
    }
  }
}

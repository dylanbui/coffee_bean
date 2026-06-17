import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_service.dart';

mixin AppUpgradeMixin<T extends StatefulWidget> on State<T> {
  String? _newVersion;
  late StreamSubscription<RemoteConfigUpdate> _remoteConfigSub;

  String? get newVersion => _newVersion;

  void initUpgradeLogic() {
    // 1. Lắng nghe sự kiện yêu cầu check update từ UI (ví dụ từ trang Profile)
    locator<DbEventBus>().on<CheckAppUpgradeRequestEvent>().listen((event) {
      checkUpgrade(force: true);
    });

    // 2. CHUẨN GOOGLE: Thực hiện fetchAndActivate lần đầu trước khi lắng nghe updates
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkUpgrade(force: true);

      // 3. Sau khi đã có dữ liệu ban đầu, mới bắt đầu lắng nghe Real-time
      final remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfigSub = remoteConfig.onConfigUpdated.listen((event) async {
        debugPrint("App: [REAL-TIME] Remote Config signal received! Updated keys: ${event.updatedKeys}");
        try {
          // Tín hiệu real-time đã tự động fetch dữ liệu, chỉ cần activate
          await remoteConfig.activate();
          if (event.updatedKeys.isEmpty || event.updatedKeys.contains('latest_app_version')) {
            checkUpgrade(force: false);
          }
        } catch (error) {
          debugPrint('App: [REAL-TIME] Config update failed: $error');
        }
      }, onError: (error) {
        debugPrint('App: [REAL-TIME] Stream error: $error');
      });
    });
  }

  void disposeUpgradeLogic() {
    _remoteConfigSub.cancel();
  }

  Future<void> checkUpgrade({bool force = false}) async {
    final version = await AppUpgradeService.checkUpdate(force: force);
    if (mounted) {
      setState(() {
        _newVersion = version;
      });
    }
  }
}

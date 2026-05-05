/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 09:33
 * To change this template use File | Settings | File Templates.
 */

/*
Document: https://apparencekit.dev/flutter-tips/continuous-network-monitoring-flutter/
Usage:
final networkChecker = DbNetworkChecker();
networkChecker.start();

networkChecker.stream.listen((status) {
  switch (status) {
    case DbNetworkStatusOnline():
      print("Online via ${status.type}");
      if (status.isWifi) print("Connected to Wifi");
    case DbNetworkStatusOffline():
      print("Network disconnected or no internet access");
  }
});

// In dispose method of your widget/provider
networkChecker.dispose();
*/

import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

sealed class DbNetworkStatus {}

class DbNetworkStatusOffline extends DbNetworkStatus {}

class DbNetworkStatusOnline extends DbNetworkStatus {
    final ConnectivityResult type;

    DbNetworkStatusOnline(this.type);

    bool get isWifi => type == ConnectivityResult.wifi;
    bool get isMobile => type == ConnectivityResult.mobile;
}

class DbNetworkChecker {
    final HttpClient _client = HttpClient();
    final Connectivity _connectivity = Connectivity();

    final _controller = StreamController<DbNetworkStatus>.broadcast();

    DbNetworkStatus? _lastStatus;
    StreamSubscription? _sub;

    Stream<DbNetworkStatus> get stream => _controller.stream;

    void start() {
        // listen connectivity changes
        _sub = _connectivity.onConnectivityChanged.listen((results) async {
            await _handleConnectivity(results);
        });

        // trigger initial check
        _initCheck();
    }

    Future<void> _initCheck() async {
        final results = await _connectivity.checkConnectivity();
        await _handleConnectivity(results);
    }

    Future<void> _handleConnectivity(List<ConnectivityResult> results) async {
        // không có mạng vật lý
        if (results.isEmpty || results.contains(ConnectivityResult.none)) {
            _emit(DbNetworkStatusOffline());
            return;
        }

        // có wifi/4g → check internet thật
        final hasInternet = await _hasInternet();
        if (!hasInternet) {
            _emit(DbNetworkStatusOffline());
            return;
        }

        // online + có loại mạng
        final result = results.firstWhere((element) => element != ConnectivityResult.none, orElse: () => results.first);
        _emit(DbNetworkStatusOnline(result));
    }

    Future<bool> _hasInternet() async {
        try {
            final request = await _client.getUrl(
                Uri.parse('https://clients3.google.com/generate_204'),
            );

            final response = await request
                .close()
                .timeout(const Duration(seconds: 5));

            return response.statusCode == HttpStatus.noContent;
        } catch (_) {
            return false;
        }
    }

    // void _emit(DbNetworkStatus status) {
    //     // deduplicate
    //     if (_lastStatus.runtimeType == status.runtimeType) return;
    //
    //     _lastStatus = status;
    //     _controller.add(status);
    // }

    // Emit ca khi network type thay doi tu Wifi -> 4G hoac nguoc lai
    void _emit(DbNetworkStatus status) {
        if (_lastStatus is DbNetworkStatusOnline && status is DbNetworkStatusOnline) {
            if (_lastStatus is DbNetworkStatusOnline && (_lastStatus as DbNetworkStatusOnline).type == status.type) {
                return;
            }
        } else if (_lastStatus.runtimeType == status.runtimeType) {
            return;
        }

        _lastStatus = status;
        _controller.add(status);
    }


    void dispose() {
        _sub?.cancel();
        _controller.close();
        _client.close(force: true);
    }
}
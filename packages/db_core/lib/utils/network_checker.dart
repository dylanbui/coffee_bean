import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Trạng thái mạng
sealed class DbNetworkStatus {}

class DbNetworkStatusOffline extends DbNetworkStatus {}

class DbNetworkStatusOnline extends DbNetworkStatus {
    final ConnectivityResult type;

    DbNetworkStatusOnline(this.type);

    bool get isWifi => type == ConnectivityResult.wifi;
    bool get isMobile => type == ConnectivityResult.mobile;
}

/// Network checker với debounce + config URL
class DbNetworkChecker {
    final HttpClient _client = HttpClient();
    final Connectivity _connectivity = Connectivity();

    final _controller = StreamController<DbNetworkStatus>.broadcast();
    Stream<DbNetworkStatus> get stream => _controller.stream;

    DbNetworkStatus? _lastStatus;
    StreamSubscription? _sub;
    Timer? _debounceTimer;

    /// URL để kiểm tra internet, mặc định là Google 204
    final Uri testUri;

    /// Thời gian debounce để tránh flicker khi mạng chập chờn
    final Duration debounceDuration;

    DbNetworkChecker({
        Uri? uri,
        this.debounceDuration = const Duration(milliseconds: 500),
    }) : testUri = uri ?? Uri.parse('https://clients3.google.com/generate_204');

    void start() {
        _sub = _connectivity.onConnectivityChanged.listen((results) async {
            await _handleConnectivity(results);
        });
        _initCheck();
    }

    Future<void> _initCheck() async {
        final results = await _connectivity.checkConnectivity();
        await _handleConnectivity(results);
    }

    Future<void> _handleConnectivity(List<ConnectivityResult> results) async {
        if (results.isEmpty || results.contains(ConnectivityResult.none)) {
            _emit(DbNetworkStatusOffline());
            return;
        }

        final hasInternet = await _hasInternet();
        if (!hasInternet) {
            _emit(DbNetworkStatusOffline());
            return;
        }

        final result = results.firstWhere(
                (element) => element != ConnectivityResult.none,
            orElse: () => results.first,
        );
        _emit(DbNetworkStatusOnline(result));
    }

    Future<bool> _hasInternet() async {
        try {
            final request = await _client.getUrl(testUri);
            final response = await request.close().timeout(const Duration(seconds: 5));
            return response.statusCode == HttpStatus.noContent;
        } catch (e) {
            debugPrint("Network check failed: $e");
            return false;
        }
    }

    void _emit(DbNetworkStatus status) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(debounceDuration, () {
            if (_controller.isClosed) return;

            // Tránh phát lại cùng một trạng thái (Sửa lỗi crash khi _lastStatus null)
            if (_lastStatus != null) {
                if (_lastStatus is DbNetworkStatusOnline && status is DbNetworkStatusOnline) {
                    if ((_lastStatus as DbNetworkStatusOnline).type == status.type) return;
                } else if (_lastStatus.runtimeType == status.runtimeType) {
                    return;
                }
            }

            _lastStatus = status;
            _controller.add(status);
        });
    }

    void dispose() {
        _sub?.cancel();
        _debounceTimer?.cancel();
        _controller.close();
        _client.close(force: true);
    }
}

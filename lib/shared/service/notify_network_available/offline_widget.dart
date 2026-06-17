import 'package:flutter/material.dart';

class OfflineWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black.withValues(alpha: 0.7),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                const Text("Không có kết nối mạng",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 8),
                const Text("Vui lòng kiểm tra lại kết nối Internet",
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text("Thử lại"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

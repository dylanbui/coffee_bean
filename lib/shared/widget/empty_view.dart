import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;

  const EmptyView({super.key, this.message = "Không có dữ liệu", this.title, this.onRetry, this.retryText = "Tải lại", this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title ?? "Trống", style: DefaultStyle.textLarge.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message, style: DefaultStyle.textNormal, textAlign: TextAlign.center),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryText),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// Trang Webview tích hợp sẵn logic bắt Callback URL cho Payment Gateway
class PaymentWebviewPage extends StatefulWidget {
  final String initialUrl;
  final String returnUrl;

  const PaymentWebviewPage({
    super.key,
    required this.initialUrl,
    required this.returnUrl,
  });

  @override
  State<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán an toàn"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true, // Để bắt redirect URL
              allowsBackForwardNavigationGestures: true,
              useOnLoadResource: true,
            ),
            onLoadStop: (controller, url) {
              setState(() => _isLoading = false);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri == null) return NavigationActionPolicy.ALLOW;

              final urlString = uri.toString();

              // 1. Kiểm tra nếu là returnUrl của App (Callback)
              if (urlString.startsWith(widget.returnUrl)) {
                Navigator.pop(context, urlString);
                return NavigationActionPolicy.CANCEL;
              }

              // 2. Kiểm tra nếu không phải là web (momo://, vnpay://, zalopay://, vnpayapp://...)
              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                if (await canLaunchUrl(uri)) {
                  // Mở ứng dụng ngoài (Ví điện tử, Ngân hàng)
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

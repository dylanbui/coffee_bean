/*
Usage Examples:

1. Modal Bottom Sheet (Recommended for quick scans):
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => FractionallySizedBox(
    heightFactor: 0.9,
    child: QRScannerWidget(
      title: "Quét mã QR",
      onDetect: (code) {
        print("QR Code: $code");
        Navigator.pop(context); 
      },
    ),
  ),
);

2. Full Screen Navigation:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => QRScannerWidget(
      title: "Quét mã nhận thưởng",
      onDetect: (code) {
        print("QR Code: $code");
        Navigator.pop(context);
      },
    ),
  ),
);
*/

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  final String title;
  final Function(String code) onDetect;
  final bool showDimBackground;

  const QRScannerWidget({
    super.key,
    this.title = "QR Scanner",
    required this.onDetect,
    this.showDimBackground = false, // Mặc định tắt lớp làm mờ theo yêu cầu
  });

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  bool isDetected = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final scanWindowSize = screenWidth * 0.7;
    
    final scanWindow = Rect.fromCenter(
      center: Offset(screenWidth / 2, screenHeight / 2),
      width: scanWindowSize,
      height: scanWindowSize,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Scanner layer
          MobileScanner(
            controller: controller,
            scanWindow: scanWindow,
            onDetect: (capture) {
              if (isDetected) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() => isDetected = true);
                  widget.onDetect(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // 2. Custom Overlay Layer (4 góc vuông)
          _buildOverlay(context, scanWindowSize),

          // 3. Header Layer (Title & Close button)
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, double scanWindowSize) {
    return Stack(
      children: [
        // Dark background with transparent hole (Chỉ hiện nếu showDimBackground = true)
        if (widget.showDimBackground)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: scanWindowSize,
                    height: scanWindowSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // White corners (Luôn hiển thị để định vị vùng quét)
        Center(
          child: CustomPaint(
            size: Size(scanWindowSize, scanWindowSize),
            painter: ScannerCornersPainter(),
          ),
        ),
      ],
    );
  }
}

class ScannerCornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerSize = 30.0;
    final path = Path();

    // Top Left
    path.moveTo(0, cornerSize);
    path.lineTo(0, 0);
    path.lineTo(cornerSize, 0);

    // Top Right
    path.moveTo(size.width - cornerSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerSize);

    // Bottom Right
    path.moveTo(size.width, size.height - cornerSize);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerSize, size.height);

    // Bottom Left
    path.moveTo(cornerSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/json/loading.json',
      width: width,
      height: height,
      repeat: true,
      frameRate: FrameRate.max,
    );
  }
}

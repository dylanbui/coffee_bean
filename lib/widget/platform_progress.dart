import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './platform_widget.dart';


class PlatformProgress extends PlatformWidget<CupertinoActivityIndicator, CircularProgressIndicator> {
  const PlatformProgress({super.key});

  @override
  CircularProgressIndicator buildAndroidWidget(BuildContext context) {
    return const CircularProgressIndicator();
  }

  @override
  CupertinoActivityIndicator buildIosWidget(BuildContext context) {
    return const CupertinoActivityIndicator();
  }

  @override
  Widget buildDefaultWidget(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

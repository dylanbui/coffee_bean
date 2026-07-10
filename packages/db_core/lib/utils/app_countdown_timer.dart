import 'dart:async';
import 'package:flutter/material.dart';

class AppCountdownTimer extends StatefulWidget {
  final DateTime? expiryDate;
  final VoidCallback? onFinished;
  final TextStyle? textStyle;

  const AppCountdownTimer({
    super.key,
    this.expiryDate,
    this.onFinished,
    this.textStyle,
  });

  @override
  State<AppCountdownTimer> createState() => _AppCountdownTimerState();
}

class _AppCountdownTimerState extends State<AppCountdownTimer> {
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant AppCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiryDate != widget.expiryDate) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.expiryDate == null) return;

    final now = DateTime.now();
    if (widget.expiryDate!.isBefore(now)) {
      setState(() {
        _duration = Duration.zero;
      });
      return;
    }

    _duration = widget.expiryDate!.difference(now);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newNow = DateTime.now();
      if (widget.expiryDate!.isBefore(newNow)) {
        timer.cancel();
        setState(() {
          _duration = Duration.zero;
        });
        widget.onFinished?.call();
      } else {
        setState(() {
          _duration = widget.expiryDate!.difference(newNow);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expiryDate == null) return const SizedBox.shrink();

    final minutes = _duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Text(
      "$minutes:$seconds",
      style: widget.textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

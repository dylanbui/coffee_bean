import 'dart:async';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';

class ActivityCountdownWidget extends StatefulWidget {
  final DateTime deadline;
  final TextStyle? style;
  final VoidCallback? onExpired;

  const ActivityCountdownWidget({
    super.key,
    required this.deadline,
    this.style,
    this.onExpired,
  });

  @override
  State<ActivityCountdownWidget> createState() => _ActivityCountdownWidgetState();
}

class _ActivityCountdownWidgetState extends State<ActivityCountdownWidget> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    _remaining = widget.deadline.difference(DateTime.now());
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateRemaining();
          if (_remaining.inSeconds <= 0) {
            _timer?.cancel();
            widget.onExpired?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) return "Đã hết hạn";

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    String result = "";
    if (days > 0) result += "${days}d ";
    
    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    
    result += "$h:$m:$s";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hạn đăng ký: ${_formatDuration(_remaining)}",
      style: widget.style ?? TMLabsTextStyle.caption.copyWith(color: Colors.grey),
    );
  }
}

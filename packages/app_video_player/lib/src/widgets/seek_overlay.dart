import 'package:flutter/material.dart';

class SeekOverlay extends StatelessWidget {
  final bool visible;
  final VoidCallback onForward;
  final VoidCallback onRewind;

  const SeekOverlay({
    super.key,
    required this.visible,
    required this.onForward,
    required this.onRewind,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: visible ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !visible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSeekButton(
              icon: Icons.replay_10_rounded,
              label: "-10s",
              onTap: onRewind,
            ),
            const SizedBox(width: 80), // Chừa chỗ cho nút Play/Pause của Chewie
            _buildSeekButton(
              icon: Icons.forward_10_rounded,
              label: "+10s",
              onTap: onForward,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

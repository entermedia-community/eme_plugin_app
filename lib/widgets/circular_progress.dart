import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double value;
  final double max;
  final Color color;

  const CircularProgress({
    super.key,
    required this.value,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double expirationProgress = (value / max).clamp(0.0, 1.0);

    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        value: expirationProgress,
        strokeWidth: 3,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

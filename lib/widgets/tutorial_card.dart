import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import '../screens/rehearse_screen.dart';

class TutorialCard extends StatefulWidget {
  final Tutorial tutorial;
  final bool isListMode;

  const TutorialCard({super.key, required this.tutorial, this.isListMode = false});

  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color getStatusColor() {
    switch (widget.tutorial.status) {
      case 'Critical':
        return const Color(0xFFE94057);
      case 'Warning':
        return const Color(0xFFF27121);
      case 'On Track':
      default:
        return const Color(0xFF38EF7D);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();

    if (widget.isListMode) {
      return _buildListCard(statusColor);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Background Gradient & Text
            _buildCardBanner(),

            // Card Body details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge + Exclamation Alert
                    Row(
                      children: [
                        _buildStatusBadge(statusColor),
                        const SizedBox(width: 8),
                        if (widget.tutorial.status == 'Critical' ||
                            widget.tutorial.status == 'Warning')
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: 0.3 + (_pulseController.value * 0.7),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.priority_high_rounded,
                                    size: 14,
                                    color: statusColor,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.tutorial.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Unlocked question numbers
                    Text(
                      'Unlocked: ${widget.tutorial.unlockedQuestions} / ${widget.tutorial.totalQuestions} questions',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar Section
                    _buildProgressBarSection(),
                    const SizedBox(height: 16),

                    // Two Stat boxes (Days to Forget, Effectiveness)
                    Row(
                      children: [
                        Expanded(child: _buildDaysToForgetGauge()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildEffectivenessGauge()),
                      ],
                    ),
                    const Spacer(),

                    // Action Buttons (Improvement, Pass it on, Rehearse)
                    _buildCardButtons(statusColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(Color statusColor) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            // Left tiny vertical gradient block
            Container(
              width: 12,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.tutorial.gradientColors,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Middle Tutorial Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        _buildStatusBadge(statusColor),
                        const SizedBox(width: 8),
                        Text(
                          widget.tutorial.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.3),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.tutorial.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlocked: ${widget.tutorial.unlockedQuestions} / ${widget.tutorial.totalQuestions} questions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Inline Progress bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: widget.tutorial.progress,
                              minHeight: 6,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.04,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.tutorial.progress > 0.5
                                    ? const Color(0xFF38EF7D)
                                    : const Color(0xFF38B6FF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(widget.tutorial.progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Right side buttons
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor.withValues(alpha: 0.15),
                      foregroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Improve',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RehearseScreen(tutorial: widget.tutorial),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Rehearse',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBanner() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.tutorial.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Geometric abstract circles
          Positioned(
            right: -20,
            bottom: -30,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: -20,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Clean icon container
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Icon(widget.tutorial.icon, color: Colors.white, size: 24),
            ),
          ),
          // Category subtitle
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PROCESO ADMISIÓN 2026',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  widget.tutorial.category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Brand badge in the top right
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Text(
                'PAES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        widget.tutorial.status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProgressBarSection() {
    final percentVal = (widget.tutorial.progress * 100).toInt();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Topic Progress',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$percentVal%',
              style: const TextStyle(
                color: Color(0xFF38B6FF),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widget.tutorial.progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38B6FF), Color(0xFF0072FF)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38B6FF).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysToForgetGauge() {
    final value = widget.tutorial.daysToForget;
    final bool hasData = value != 'No data';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          // Tiny Circular Arc Painter for data status
          CustomPaint(
            size: const Size(28, 28),
            painter: _CircularMeterPainter(
              percentage: hasData ? 0.6 : 0.0,
              color: hasData ? const Color(0xFFF27121) : Colors.white24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: hasData ? Colors.white : Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Days to forget',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectivenessGauge() {
    final value = widget.tutorial.effectiveness;
    int barsCount = 1;
    Color effectivenessColor = const Color(0xFFE94057);

    if (value == 'Moderate') {
      barsCount = 3;
      effectivenessColor = const Color(0xFFF27121);
    } else if (value == 'Good') {
      barsCount = 4;
      effectivenessColor = const Color(0xFF38B6FF);
    } else if (value == 'Excellent') {
      barsCount = 5;
      effectivenessColor = const Color(0xFF38EF7D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          // Signal bars
          _buildSignalBars(barsCount, effectivenessColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: effectivenessColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Effectiveness',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalBars(int count, Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (index) {
          final isLit = index < count;
          final barHeight = 4.0 + (index * 4.0);
          return Container(
            width: 3,
            height: barHeight,
            decoration: BoxDecoration(
              color: isLit ? color : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardButtons(Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Improvement main button
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [statusColor, statusColor.withValues(alpha: 0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Improvement Area',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white60,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Pass it on',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RehearseScreen(tutorial: widget.tutorial),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2631),
                    foregroundColor: const Color(0xFF38B6FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: const Color(0xFF38B6FF).withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Rehearse',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircularMeterPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _CircularMeterPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw background track circle
    canvas.drawCircle(center, radius - 2, trackPaint);

    if (percentage > 0.0) {
      // Draw progress arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        -math.pi / 2,
        2 * math.pi * percentage,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularMeterPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}

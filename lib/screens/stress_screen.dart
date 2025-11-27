import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/stress_gauge_painter.dart';
import 'confirmation_screen.dart';

class StressScreen extends StatefulWidget {
  const StressScreen({super.key});

  @override
  State<StressScreen> createState() => _StressScreenState();
}

class _StressScreenState extends State<StressScreen> with TickerProviderStateMixin {
  double stressValue = 0.5;
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _isDragging = false;

  int get selectedLevel => ((stressValue * 4) + 1).round().clamp(1, 5);
  String get levelText {
    switch (selectedLevel) {
      case 1: return 'Low';
      case 2: return 'Mild';
      case 3: return 'Moderate';
      case 4: return 'High';
      case 5: return 'Severe';
      default: return 'Moderate';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _animationController == null) {
        _animationController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _snapToNearestLevel(double newValue) {
    final targetLevel = ((newValue * 4) + 1).round().clamp(1, 5);
    final targetValue = (targetLevel - 1) / 4.0;

    if (mounted) {
      _animationController?.forward().then((_) {
        if (mounted) _animationController?.reset();
      });
      setState(() {
        stressValue = targetValue;
      });
    }

    HapticFeedback.heavyImpact();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
    HapticFeedback.lightImpact();
  }

  void _onPanUpdate(DragUpdateDetails details, double centerX, double radius) {
    final dx = details.localPosition.dx - centerX;
    final normalized = (dx + radius) / (2 * radius);
    final newValue = normalized.clamp(0.0, 1.0);

    if ((newValue * 4).round() != (stressValue * 4).round() && mounted) {
      HapticFeedback.selectionClick();
      setState(() => stressValue = newValue);
    } else if (mounted) {
      setState(() => stressValue = newValue);
    }
  }

  void _onPanEnd(DragEndDetails details, double centerX, double radius) {
    if (mounted) setState(() => _isDragging = false);
    _snapToNearestLevel(stressValue);
  }

  void _onSkip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          stressLevel: selectedLevel,
          onGotIt: () => Navigator.pushNamed(context, '/camera'),
        ),
      ),
    );
  }

  void _onRecord() {
    Navigator.pushNamed(context, '/camera');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      // ------------------------------
      // 🟠 FIX OVERFLOW → INI BAGIAN YANG DITAMBAHKAN
      // ------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
      // ------------------------------

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: const Text(
                      "What's your stress level today?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8D6E63),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 280,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double centerX = constraints.maxWidth / 2;
                                final double radius = 110.0;
                                final double centerY = 140.0;
                                final double startAngle = math.pi;
                                final double sweepAngle = math.pi / 3;
                                final double currentAngle =
                                    startAngle + (stressValue * sweepAngle);

                                return GestureDetector(
                                  onPanStart: _onPanStart,
                                  onPanUpdate: (details) =>
                                      _onPanUpdate(details, centerX, radius),
                                  onPanEnd: (details) =>
                                      _onPanEnd(details, centerX, radius),
                                  child: Stack(
                                    children: [
                                      CustomPaint(
                                        size: Size(constraints.maxWidth, 280),
                                        painter: StressGaugePainter(
                                          radius: radius,
                                          centerX: centerX,
                                          centerY: centerY,
                                          startAngle: startAngle,
                                          sweepAngle: sweepAngle,
                                          currentValue: stressValue,
                                        ),
                                      ),

                                      ...List.generate(5, (index) {
                                        final pos = index / 4.0;
                                        final dotAngle =
                                            startAngle + (pos * sweepAngle);
                                        final dotX =
                                            centerX + radius * math.cos(dotAngle);
                                        final dotY =
                                            centerY + radius * math.sin(dotAngle);
                                        final isSelected =
                                            (pos - stressValue).abs() < 0.05;

                                        return Positioned(
                                          left: dotX - 4,
                                          top: dotY - 4,
                                          child: AnimatedContainer(
                                            duration:
                                                const Duration(milliseconds: 200),
                                            width: isSelected ? 10 : 8,
                                            height: isSelected ? 10 : 8,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.orange
                                                  : const Color(0xFF9E9E9E),
                                              shape: BoxShape.circle,
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                          color: Colors.orange
                                                              .withOpacity(0.4),
                                                          blurRadius: 6)
                                                    ]
                                                  : null,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          Column(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                  child: child,
                                  scale: animation,
                                ),
                                child: Text(
                                  selectedLevel.toString(),
                                  key: ValueKey(selectedLevel),
                                  style: const TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  child: child,
                                  opacity: animation,
                                ),
                                child: Text(
                                  levelText,
                                  key: ValueKey(levelText),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 40.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _onSkip,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              side:
                                  BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Skip Record Expression",
                              style: TextStyle(
                                color: Color(0xFF8D6E63),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _onRecord,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D4037),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "Record Stress Expression →",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

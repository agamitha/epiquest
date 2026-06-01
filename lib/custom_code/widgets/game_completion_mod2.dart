// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

class GameCompletionMod2 extends StatefulWidget {
  const GameCompletionMod2({
    Key? key,
    this.width,
    this.height,
    this.game1Score,
    this.game2Score,
    this.game3Score,
    this.game4Score,
    this.onBackToHome,
    this.onPlayFinalGame,
  }) : super(key: key);

  final double? width;
  final double? height;
  final int? game1Score;
  final int? game2Score;
  final int? game3Score;
  final int? game4Score;
  final Future<dynamic> Function()? onBackToHome;
  final Future<dynamic> Function()? onPlayFinalGame;

  @override
  State<GameCompletionMod2> createState() => _GameCompletionMod2State();
}

const int _gcPassM2 = 80;

class _GameCompletionMod2State extends State<GameCompletionMod2>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl;
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;
  final List<_ParticleM2> _particles = [];
  final Random _rng = Random();

  int get _avgScore {
    final s1 = widget.game1Score ?? 0;
    final s2 = widget.game2Score ?? 0;
    final s3 = widget.game3Score ?? 0;
    final s4 = widget.game4Score ?? 0;
    return ((s1 + s2 + s3 + s4) / 4).round();
  }

  bool get _passed => _avgScore >= _gcPassM2;

  @override
  void initState() {
    super.initState();
    _confettiCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() => setState(() {}));
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _scaleCtrl.forward();
    if (_passed) {
      _buildParticles();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _confettiCtrl.forward();
      });
    }
  }

  void _buildParticles() {
    final cols = [
      const Color(0xFF4A90D9),
      const Color(0xFF2A9940),
      Colors.amber,
      const Color(0xFFD94040),
      Colors.cyan,
      Colors.pink,
    ];
    for (int i = 0; i < 150; i++) {
      _particles.add(_ParticleM2(
        x: _rng.nextDouble(),
        color: cols[_rng.nextInt(cols.length)],
        size: 5 + _rng.nextDouble() * 9,
        speed: 0.25 + _rng.nextDouble() * 0.75,
        spin: _rng.nextDouble() * 6,
        drift: (_rng.nextDouble() - 0.5) * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Stack(children: [
        Container(color: const Color(0xFFF0F4FF)),
        SingleChildScrollView(
          child: Column(children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              color:
                  _passed ? const Color(0xFF4A90D9) : const Color(0xFFE65100),
              child: Text(
                _passed ? 'Module 2 Completed!' : 'Module 2 Results',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(children: [
                // Tooth with bounce
                AnimatedBuilder(
                  animation: _scaleAnim,
                  builder: (_, child) =>
                      Transform.scale(scale: _scaleAnim.value, child: child),
                  child: Image.network(
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.health_and_safety_rounded,
                        size: 100,
                        color: Color(0xFF4A90D9)),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  _passed ? 'Congratulations!' : 'Keep Practicing!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: _passed
                          ? const Color(0xFF4A90D9)
                          : const Color(0xFFE65100)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Module 2 - Cohort Studies',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569)),
                ),
                const SizedBox(height: 24),

                // Overall score card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _passed
                        ? const Color(0xFFE8FAEA)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _passed
                            ? const Color(0xFF2A9940)
                            : const Color(0xFFE65100),
                        width: 1.5),
                  ),
                  child: Column(children: [
                    Text(
                      _passed ? 'Module Passed!  ' : 'Not Passed Yet',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _passed
                              ? const Color(0xFF2A9940)
                              : const Color(0xFFE65100)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_avgScore%',
                      style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: _passed
                              ? const Color(0xFF2A9940)
                              : const Color(0xFFE65100)),
                    ),
                    Text(
                      'Average score across all 4 games',
                      style: TextStyle(
                          fontSize: 12,
                          color: _passed
                              ? const Color(0xFF2A9940)
                              : const Color(0xFFE65100)),
                    ),
                    const SizedBox(height: 6),
                    if (_passed)
                      const Text(
                        'Final Integrative Game Unlocked!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2A9940)),
                      )
                    else
                      Text(
                        'You need $_gcPassM2% or above to unlock the Final Game.\nRetry the games to improve your score.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE65100),
                            height: 1.5),
                      ),
                  ]),
                ),
                const SizedBox(height: 20),

                // Individual game scores
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x1A4A90D9),
                          blurRadius: 16,
                          offset: Offset(0, 6))
                    ],
                    border:
                        Border.all(color: const Color(0xFFBDD5EE), width: 1.5),
                  ),
                  child: Column(children: [
                    const Text('Games Completed:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    _gameScoreRow('Save the Princess', widget.game1Score ?? 0),
                    _gameScoreRow('Witch Hunter', widget.game2Score ?? 0),
                    _gameScoreRow('Crossword Puzzle', widget.game3Score ?? 0),
                    _gameScoreRow('Save the Goldfish', widget.game4Score ?? 0,
                        isLast: true),
                  ]),
                ),
                const SizedBox(height: 28),

                // Play Final Game (only if passed)
                if (_passed) ...[
                  GestureDetector(
                    onTap: () => widget.onPlayFinalGame?.call(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A9940),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x4D2A9940),
                              blurRadius: 16,
                              offset: Offset(0, 6))
                        ],
                      ),
                      child: const Text('Play Final Game: Fire & Water Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Back to Home
                GestureDetector(
                  onTap: () async => await widget.onBackToHome?.call(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _passed
                          ? const Color(0xFF4A90D9)
                          : const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                            color: _passed
                                ? const Color(0x4D4A90D9)
                                : const Color(0x4DE65100),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: const Text('Back to Home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 17)),
                  ),
                ),
              ]),
            ),
          ]),
        ),

        // Confetti
        if (_passed && (_confettiCtrl.isAnimating || _confettiCtrl.value > 0))
          IgnorePointer(
            child: SizedBox.expand(
              child: CustomPaint(
                  painter: _ConfettiPainterM2(_particles, _confettiCtrl.value)),
            ),
          ),
      ]),
    );
  }

  Widget _gameScoreRow(String name, int score, {bool isLast = false}) {
    final passed = score >= _gcPassM2;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: passed ? const Color(0xFFE8FAEA) : const Color(0xFFFFF3E0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            passed ? Icons.check_rounded : Icons.refresh_rounded,
            size: 18,
            color: passed ? const Color(0xFF2A9940) : const Color(0xFFE65100),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: passed ? const Color(0xFFE8FAEA) : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color:
                    passed ? const Color(0xFF2A9940) : const Color(0xFFE65100)),
          ),
          child: Text('$score%',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: passed
                      ? const Color(0xFF2A9940)
                      : const Color(0xFFE65100))),
        ),
      ]),
    );
  }
}

class _ParticleM2 {
  final double x, size, speed, spin, drift;
  final Color color;
  _ParticleM2(
      {required this.x,
      required this.color,
      required this.size,
      required this.speed,
      required this.spin,
      required this.drift});
}

class _ConfettiPainterM2 extends CustomPainter {
  final List<_ParticleM2> particles;
  final double t;
  _ConfettiPainterM2(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = t * size.height * p.speed;
      final x = p.x * size.width + sin(t * pi * 4 * p.spin) * 30 * p.drift;
      if (y > size.height) continue;
      final alpha = ((1.0 - t * 0.5).clamp(0.0, 1.0) * 255).round();
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * p.spin * 2 * pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: p.size, height: p.size * 0.55),
            const Radius.circular(2)),
        Paint()
          ..color =
              Color.fromARGB(alpha, p.color.red, p.color.green, p.color.blue),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainterM2 old) => old.t != t;
}

// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class GameIntroMod1 extends StatefulWidget {
  const GameIntroMod1({
    Key? key,
    this.width,
    this.height,
    this.game1Score,
    this.game2Score,
    this.game3Score,
    this.game4Score,
    this.onPlayGame1,
    this.onPlayGame2,
    this.onPlayGame3,
    this.onPlayGame4,
    this.onViewResults,
    this.onGoHome,
  }) : super(key: key);

  final double? width;
  final double? height;
  final int? game1Score;
  final int? game2Score;
  final int? game3Score;
  final int? game4Score;
  final Future<dynamic> Function()? onPlayGame1;
  final Future<dynamic> Function()? onPlayGame2;
  final Future<dynamic> Function()? onPlayGame3;
  final Future<dynamic> Function()? onPlayGame4;
  final Future<dynamic> Function()? onViewResults;
  final Future<dynamic> Function()? onGoHome;

  @override
  State<GameIntroMod1> createState() => _GameIntroMod1State();
}

const int _kPass = 80;

class _GameIntroMod1State extends State<GameIntroMod1> {
  bool _isPlayed(int? score) => (score ?? 0) > 0;
  bool _isPassed(int? score) => (score ?? 0) >= _kPass;

  bool get _game1Unlocked => true;
  bool get _game2Unlocked => _isPassed(widget.game1Score);
  bool get _game3Unlocked => _isPassed(widget.game2Score);
  bool get _game4Unlocked => _isPassed(widget.game3Score);

  bool get _allPlayed =>
      _isPlayed(widget.game1Score) &&
      _isPlayed(widget.game2Score) &&
      _isPlayed(widget.game3Score) &&
      _isPlayed(widget.game4Score);

  int get _avgScore {
    final scores = [
      widget.game1Score ?? 0,
      widget.game2Score ?? 0,
      widget.game3Score ?? 0,
      widget.game4Score ?? 0,
    ];
    final played = scores.where((s) => s > 0).length;
    if (played == 0) return 0;
    return (scores.reduce((a, b) => a + b) / 4).round();
  }

  String get _statusText {
    if (!_isPlayed(widget.game1Score)) {
      return "You've completed the learning material!\nNow test your knowledge with 4 fun games.";
    }
    if (_allPlayed) return 'All games completed!';
    return 'Welcome back!\nContinue where you left off.';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: const Color(0xFFF0F4FF),
        child: Column(children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            color: const Color(0xFF4A90D9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Module 1 Games',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                GestureDetector(
                  onTap: () => widget.onGoHome?.call(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 1)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_rounded, size: 15, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Home',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(children: [
                // Tooth image
                Image.network(
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.health_and_safety_rounded,
                      size: 90,
                      color: Color(0xFF4A90D9)),
                ),
                const SizedBox(height: 20),

                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF475569), height: 1.6),
                ),
                const SizedBox(height: 24),

                // Games list card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x1A4A90D9),
                          blurRadius: 16,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Games you\'ll play:',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B))),
                      const SizedBox(height: 16),
                      // ── Game 1: Save the Princess (replaces Snake & Ladder)
                      _gameRow(
                          icon: Icons.castle_rounded,
                          label: 'Game 1',
                          title: 'Save the Princess',
                          score: widget.game1Score,
                          unlocked: _game1Unlocked,
                          onTap: widget.onPlayGame1),
                      _gameRow(
                          icon: Icons.grid_on_rounded,
                          label: 'Game 2',
                          title: 'Crossword Puzzle',
                          score: widget.game2Score,
                          unlocked: _game2Unlocked,
                          onTap: widget.onPlayGame2),
                      _gameRow(
                          icon: Icons.search_rounded,
                          label: 'Game 3',
                          title: 'Word Finder',
                          score: widget.game3Score,
                          unlocked: _game3Unlocked,
                          onTap: widget.onPlayGame3),
                      _gameRow(
                          icon: Icons.drag_indicator_rounded,
                          label: 'Game 4',
                          title: 'Drag & Drop',
                          score: widget.game4Score,
                          unlocked: _game4Unlocked,
                          onTap: widget.onPlayGame4,
                          isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Average score
                if (_isPlayed(widget.game1Score)) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F0FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Current average score:',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF475569))),
                          Text('$_avgScore%',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4A90D9))),
                        ]),
                  ),
                  const SizedBox(height: 20),
                ],

                // View Results
                if (_allPlayed) ...[
                  GestureDetector(
                    onTap: () => widget.onViewResults?.call(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A9940),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x334A90D9),
                              blurRadius: 16,
                              offset: Offset(0, 6))
                        ],
                      ),
                      child: const Text('View Results',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Go to Home
                GestureDetector(
                  onTap: () => widget.onGoHome?.call(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: const Color(0xFF4A90D9), width: 1.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_rounded,
                            size: 18, color: Color(0xFF4A90D9)),
                        SizedBox(width: 8),
                        Text('Go to Home',
                            style: TextStyle(
                                color: Color(0xFF4A90D9),
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _gameRow({
    required IconData icon,
    required String label,
    required String title,
    required int? score,
    required bool unlocked,
    required Future<dynamic> Function()? onTap,
    bool isLast = false,
  }) {
    final played = _isPlayed(score);
    final passed = _isPassed(score);
    final scoreVal = score ?? 0;

    Color bgColor, borderColor, iconBgColor, iconColor, labelColor, titleColor;

    if (!unlocked) {
      bgColor = const Color(0xFFF1F1F1);
      borderColor = const Color(0xFFD8D8D8);
      iconBgColor = const Color(0xFFEEEEEE);
      iconColor = const Color(0xFF999999);
      labelColor = const Color(0xFF999999);
      titleColor = const Color(0xFF999999);
    } else if (played && passed) {
      bgColor = const Color(0xFFE8FAEA);
      borderColor = const Color(0xFF2A9940);
      iconBgColor = const Color(0xFFD0F0DC);
      iconColor = const Color(0xFF2A9940);
      labelColor = const Color(0xFF2A9940);
      titleColor = const Color(0xFF1E293B);
    } else if (played && !passed) {
      bgColor = const Color(0xFFFFF8F0);
      borderColor = const Color(0xFFE65100);
      iconBgColor = const Color(0xFFFFF0E0);
      iconColor = const Color(0xFFE65100);
      labelColor = const Color(0xFFE65100);
      titleColor = const Color(0xFF1E293B);
    } else {
      bgColor = const Color(0xFFE3F0FB);
      borderColor = const Color(0xFF4A90D9);
      iconBgColor = const Color(0xFFD0E8F8);
      iconColor = const Color(0xFF4A90D9);
      labelColor = const Color(0xFF4A90D9);
      titleColor = const Color(0xFF1E293B);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: GestureDetector(
        onTap: unlocked && onTap != null ? () => onTap.call() : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(children: [
            // ── Game icon — always shown, never replaced by lock ──
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, size: 20, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),

            // ── Label + title ─────────────────────────────────────
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: labelColor,
                            letterSpacing: 1.1)),
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: titleColor)),
                  ]),
            ),

            // ── Right side: score badge OR lock icon ──────────────
            if (played)
              // Score badge when played
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFF2A9940)
                      : const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$scoreVal%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              )
            else if (!unlocked)
              // Lock icon on the right when locked and not yet played
              const Icon(Icons.lock_rounded,
                  size: 18, color: Color(0xFF999999)),
          ]),
        ),
      ),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

// ── Theme ─────────────────────────────────────────────────────────────────
const Color _whBlue = Color(0xFF4A90D9);
const Color _whBlueLight = Color(0xFFE3F0FB);
const Color _whBg = Color(0xFFF0F4FF);
const Color _whGreen = Color(0xFF2A9940);
const Color _whGreenLight = Color(0xFFE8FAEA);
const Color _whRed = Color(0xFFD94040);
const Color _whRedLight = Color(0xFFFFEAEA);
const Color _whBorder = Color(0xFFBDD5EE);
const Color _whTextDark = Color(0xFF1E293B);
const Color _whTextMid = Color(0xFF475569);

class WitchHunter extends StatefulWidget {
  const WitchHunter({
    Key? key,
    this.width,
    this.height,
    required this.onGameComplete,
    this.onNextGame,
    this.onGoHome,
    this.onBackToMenu,
    this.savedScore,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future Function() onGameComplete;
  final Future<dynamic> Function()? onNextGame;
  final Future<dynamic> Function()? onGoHome;
  final Future<dynamic> Function()? onBackToMenu;
  final int? savedScore; // retain highest score — only update if new score beats this

  @override
  State<WitchHunter> createState() => _WitchHunterState();
}

class _WitchHunterState extends State<WitchHunter> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> allStatements = [
    { "text": "In a cohort study, selecting diseased individuals at baseline is acceptable.",
      "isCorrect": false, "explanation": "Wrong! Cohort participants must be DISEASE-FREE at baseline!" },
    { "text": "Loss to follow-up has no effect on validity.",
      "isCorrect": false, "explanation": "Wrong! Loss to follow-up causes selection bias!" },
    { "text": "Cohorts cannot calculate incidence.",
      "isCorrect": false, "explanation": "Wrong! Calculating incidence is a KEY advantage of cohort studies!" },
    { "text": "Retrospective cohort = case-control study.",
      "isCorrect": false, "explanation": "Wrong! They are different — retrospective cohort still starts with exposure!" },
    { "text": "Incidence can be calculated using prevalent cases.",
      "isCorrect": false, "explanation": "Wrong! Incidence uses NEW (incident) cases, not prevalent ones!" },
    { "text": "Cohorts start with exposure measurement.",
      "isCorrect": true, "explanation": "Correct! Cohort studies begin with identifying exposed vs unexposed groups!" },
    { "text": "Retrospective cohorts use past records.",
      "isCorrect": true, "explanation": "Correct! Retrospective cohorts rely on historical data!" },
    { "text": "RR is the key measure of association in cohort studies.",
      "isCorrect": true, "explanation": "Correct! Relative Risk (RR) is directly calculated in cohort studies!" },
    { "text": "Confounding can distort the exposure–disease relationship.",
      "isCorrect": true, "explanation": "Correct! Confounders are linked to both exposure and disease!" },
    { "text": "Follow-up is essential to measure new cases.",
      "isCorrect": true, "explanation": "Correct! Without follow-up, you cannot measure incidence!" },
  ];

  late List<Map<String, dynamic>> statements;
  int currentIndex = 0;
  int witchHP = 10;
  int correctActions = 0;
  bool gameWon = false;
  bool showFeedback = false;
  bool feedbackCorrect = false;
  String feedbackText = "";
  double _dragX = 0;

  late AnimationController _witchController;
  late Animation<double> _witchAnimation;

  @override
  void initState() {
    super.initState();
    statements = List.from(allStatements)..shuffle(Random());
    _witchController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _witchAnimation = Tween<double>(begin: 0, end: 8).animate(
        CurvedAnimation(parent: _witchController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _witchController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (showFeedback || gameWon) return;
    _processAnswer(!statements[currentIndex]["isCorrect"], statements[currentIndex]["explanation"]);
  }

  void _handleSwipe() {
    if (showFeedback || gameWon) return;
    _processAnswer(statements[currentIndex]["isCorrect"], statements[currentIndex]["explanation"]);
  }

  void _processAnswer(bool correct, String explanation) {
    setState(() {
      showFeedback = true;
      feedbackCorrect = correct;
      feedbackText = explanation;
      if (correct) {
        correctActions++;
        witchHP = max(0, witchHP - 1);
        _witchController.forward(from: 0);
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        showFeedback = false;
        _dragX = 0;
        if (currentIndex < statements.length - 1) currentIndex++;
        else { statements.shuffle(Random()); currentIndex = 0; }
        if (correctActions >= 10) {
          gameWon = true;
          // WitchHunter always returns 100 — only update if not already 100
          if (100 > (widget.savedScore ?? 0)) {
            widget.onGameComplete();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _whBg,
        child: Column(children: [
          _buildHeader(),
          _buildScoreBar(),
          Expanded(child: gameWon ? _buildWinScreen() : _buildGame()),
        ]),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
    color: _whBlue,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Witch Hunter',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      GestureDetector(
        onTap: () => widget.onGoHome?.call(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.home_rounded, size: 14, color: Colors.white),
            SizedBox(width: 5),
            Text('Home', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ])),
      ),
    ]));

  Widget _buildScoreBar() => Container(
    color: _whBlueLight,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Correct: $correctActions / 10',
          style: const TextStyle(color: _whBlue, fontWeight: FontWeight.w700, fontSize: 13)),
      Text('Witch HP: $witchHP/10', style: const TextStyle(color: _whTextMid, fontSize: 12)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(color: _whBlue, borderRadius: BorderRadius.circular(20)),
        child: Text('${(correctActions / 10 * 100).round()}%',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))),
    ]));

  Widget _buildGame() {
    final statement = statements[currentIndex];
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _whBorder),
              boxShadow: const [BoxShadow(color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))]),
          child: Row(children: [
            AnimatedBuilder(animation: _witchAnimation,
              builder: (_, __) => Transform.translate(
                offset: Offset(_witchAnimation.value % 2 == 0 ? _witchAnimation.value : -_witchAnimation.value, 0),
                child: const Text("🧙", style: TextStyle(fontSize: 40)))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Witch HP", style: TextStyle(fontWeight: FontWeight.w700, color: _whTextDark, fontSize: 13)),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: witchHP / 10,
                  backgroundColor: const Color(0xFFD8E4F0),
                  valueColor: AlwaysStoppedAnimation(witchHP > 5 ? _whRed : Colors.orange),
                  minHeight: 12)),
              const SizedBox(height: 4),
              Text('$witchHP / 10 HP remaining',
                  style: const TextStyle(fontSize: 11, color: _whTextMid)),
            ])),
          ])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: _whBlueLight, borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded, color: _whBlue, size: 18),
            SizedBox(width: 10),
            Expanded(child: Text('Tap ❌ to destroy wrong statements  •  Swipe 👉 or tap ✅ to keep correct ones',
                style: TextStyle(fontSize: 12, color: _whBlue, fontWeight: FontWeight.w500))),
          ])),
        const SizedBox(height: 8),
        Wrap(alignment: WrapAlignment.center,
          children: List.generate(10, (i) => Padding(padding: const EdgeInsets.all(1),
            child: Text(i < correctActions ? "⭐" : "☆", style: const TextStyle(fontSize: 18))))),
        const SizedBox(height: 8),
        GestureDetector(
          onHorizontalDragUpdate: (d) { if (!showFeedback) setState(() => _dragX += d.delta.dx); },
          onHorizontalDragEnd: (d) {
            if (!showFeedback) { if (_dragX > 80) _handleSwipe(); else setState(() => _dragX = 0); }
          },
          child: Transform.translate(offset: Offset(_dragX, 0),
            child: Transform.rotate(angle: _dragX * 0.002,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _dragX > 30 ? _whGreen : _dragX < -30 ? _whRed : _whBorder, width: 2),
                  boxShadow: const [BoxShadow(color: Color(0x1A4A90D9), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(children: [
                  Text("📜 Statement ${currentIndex + 1} / ${statements.length}",
                      style: const TextStyle(fontSize: 12, color: _whTextMid)),
                  const SizedBox(height: 12),
                  Text('"${statement["text"]}"', textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: _whTextDark, fontStyle: FontStyle.italic, height: 1.5)),
                  const SizedBox(height: 16),
                  if (_dragX > 30)
                    Text("✅ KEEP IT →", style: TextStyle(color: _whGreen, fontSize: 16, fontWeight: FontWeight.bold))
                  else if (_dragX < -30)
                    Text("← WRONG DIRECTION", style: TextStyle(color: _whRed, fontSize: 14))
                  else
                    const Text("Swipe right to keep → or Tap ❌ to destroy",
                        style: TextStyle(color: _whTextMid, fontSize: 11)),
                ])))),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(onTap: showFeedback ? null : _handleTap,
            child: Container(width: 130, height: 60,
              decoration: BoxDecoration(
                color: showFeedback ? const Color(0xFFD8D8D8) : _whRedLight,
                borderRadius: BorderRadius.circular(14), border: Border.all(color: _whRed, width: 1.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("❌", style: TextStyle(fontSize: 26)),
                const Text("TAP — Wrong!", style: TextStyle(color: _whRed, fontSize: 11, fontWeight: FontWeight.bold)),
              ]))),
          GestureDetector(onTap: showFeedback ? null : _handleSwipe,
            child: Container(width: 130, height: 60,
              decoration: BoxDecoration(
                color: showFeedback ? const Color(0xFFD8D8D8) : _whGreenLight,
                borderRadius: BorderRadius.circular(14), border: Border.all(color: _whGreen, width: 1.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("✅", style: TextStyle(fontSize: 26)),
                const Text("SWIPE — Correct!", style: TextStyle(color: _whGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              ]))),
        ]),
        const SizedBox(height: 10),
        if (showFeedback)
          AnimatedContainer(duration: const Duration(milliseconds: 200),
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: feedbackCorrect ? _whGreenLight : _whRedLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: feedbackCorrect ? _whGreen : _whRed)),
            child: Text(feedbackText, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: feedbackCorrect ? const Color(0xFF1A5E2A) : const Color(0xFF8B0000)))),
        const SizedBox(height: 10),
        GestureDetector(onTap: () => widget.onBackToMenu?.call(),
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _whBlue, width: 1.5)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.grid_view_rounded, size: 15, color: _whBlue),
              SizedBox(width: 7),
              Text('Games Menu', style: TextStyle(color: _whBlue, fontWeight: FontWeight.w700, fontSize: 14)),
            ]))),
      ]),
    );
  }

  Widget _buildWinScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        Image.network('https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
          width: 100, height: 100,
          errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events_rounded, size: 80, color: _whBlue)),
        const SizedBox(height: 20),
        const Text('Witch Defeated! 💨',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _whBlue)),
        const SizedBox(height: 8),
        const Text('She disappeared into smoke! 🎉', style: TextStyle(fontSize: 14, color: _whTextMid)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(color: _whBlueLight, borderRadius: BorderRadius.circular(16)),
          child: const Column(children: [
            Text('10 / 10 correct actions', style: TextStyle(fontSize: 14, color: _whTextMid)),
            SizedBox(height: 4),
            Text('100%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: _whBlue)),
          ])),
        const SizedBox(height: 28),
        GestureDetector(onTap: () => widget.onNextGame?.call(),
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: _whBlue, borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Color(0x4D4A90D9), blurRadius: 16, offset: Offset(0, 6))]),
            child: const Text('Next Game: Crossword Puzzle', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)))),
        const SizedBox(height: 10),
        GestureDetector(onTap: () => widget.onBackToMenu?.call(),
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFD8E4F0), width: 1.5)),
            child: const Text('Games Menu', textAlign: TextAlign.center,
                style: TextStyle(color: _whTextMid, fontWeight: FontWeight.w700, fontSize: 15)))),
      ]),
    ),
    );
  }
}

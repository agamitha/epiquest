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

const Color _fwBlue = Color(0xFF4A90D9);
const Color _fwBlueDark = Color(0xFF1565C0);
const Color _fwBlueLight = Color(0xFFE3F0FB);
const Color _fwBg = Color(0xFFF0F4FF);
const Color _fwGreen = Color(0xFF2A9940);
const Color _fwGreenLight = Color(0xFFE8FAEA);
const Color _fwRed = Color(0xFFD94040);
const Color _fwRedLight = Color(0xFFFFEAEA);
const Color _fwOrange = Color(0xFFE65100);
const Color _fwBorder = Color(0xFFBDD5EE);
const Color _fwTextDark = Color(0xFF1E293B);
const Color _fwTextMid = Color(0xFF475569);

class FireWaterBalance extends StatefulWidget {
  const FireWaterBalance({
    Key? key,
    this.width,
    this.height,
    required this.onGameComplete,
    this.onGoHome,
    this.onBackToHome,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future Function() onGameComplete;
  final Future<dynamic> Function()? onGoHome;
  final Future<dynamic> Function()? onBackToHome;

  @override
  State<FireWaterBalance> createState() => _FireWaterBalanceState();
}

class _FireWaterBalanceState extends State<FireWaterBalance>
    with TickerProviderStateMixin {
  // 0 = intro, 1 = game, 2 = won, 3 = lost
  int _screen = 0;

  final List<Map<String, dynamic>> allCards = [
    {"text": "Starts with exposure", "side": "cohort"},
    {"text": "Participants disease-free at start", "side": "cohort"},
    {"text": "Moves forward in time", "side": "cohort"},
    {"text": "Can calculate incidence", "side": "cohort"},
    {"text": "Measures Relative Risk (RR)", "side": "cohort"},
    {"text": "Follow-up required", "side": "cohort"},
    {"text": "Can study multiple outcomes", "side": "cohort"},
    {"text": "Starts with disease", "side": "casecontrol"},
    {"text": "Looks backward in time", "side": "casecontrol"},
    {"text": "Measure = Odds Ratio (OR)", "side": "casecontrol"},
    {"text": "Good for rare diseases", "side": "casecontrol"},
    {"text": "Quick and inexpensive", "side": "casecontrol"},
    {"text": "Studies one disease at a time", "side": "casecontrol"},
    {"text": "Prone to recall bias", "side": "casecontrol"},
  ];

  late List<Map<String, dynamic>> remainingCards;
  Map<String, String> placedCards = {};
  int lives = 3;
  String? selectedCard;
  bool showFeedback = false;
  bool feedbackCorrect = false;
  String feedbackMessage = '';
  bool _flashCorrect = false;
  bool _flashWrong = false;

  // Animations
  late AnimationController _seesawCtrl;
  late Animation<double> _seesawAnim;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    remainingCards = List.from(allCards)..shuffle(Random());

    _seesawCtrl = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _seesawAnim = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: _seesawCtrl, curve: Curves.elasticOut));

    _bounceCtrl = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -4, end: 4)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _shakeCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnim = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticInOut));
  }

  @override
  void dispose() {
    _seesawCtrl.dispose();
    _bounceCtrl.dispose();
    _pulseCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _animateSeesaw(double angle) {
    _seesawAnim = Tween<double>(begin: _seesawAnim.value, end: angle).animate(
        CurvedAnimation(parent: _seesawCtrl, curve: Curves.elasticOut));
    _seesawCtrl.forward(from: 0);
  }

  void _selectCard(String text) =>
      setState(() => selectedCard = selectedCard == text ? null : text);

  void _placeCard(String side) {
    if (selectedCard == null) {
      // No card selected — do nothing, the instruction banner already says what to do
      return;
    }
    final card = allCards.firstWhere((c) => c["text"] == selectedCard);
    final correct = card["side"] == side;

    setState(() {
      placedCards[selectedCard!] = side;
      remainingCards.removeWhere((c) => c["text"] == selectedCard);
      selectedCard = null;
    });

    if (correct) {
      setState(() => _flashCorrect = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _flashCorrect = false);
      });
      _animateSeesaw(0);
      _showFeedback(
          true,
          side == "cohort"
              ? "Correct! Cohort studies start with EXPOSURE and move FORWARD."
              : "Correct! Case-Control studies start with DISEASE and look BACKWARD.");
      if (remainingCards.isEmpty) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() => _screen = 2);
            widget.onGameComplete();
          }
        });
      }
    } else {
      lives--;
      setState(() => _flashWrong = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _flashWrong = false);
      });
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
      _animateSeesaw((side == "cohort" ? -1 : 1) * 18.0);
      _showFeedback(
          false,
          side == "cohort"
              ? "Wrong! This belongs to Case-Control (fire side). The seesaw tilted!"
              : "Wrong! This belongs to Cohort (water side). The seesaw tilted!");

      final cardToReturn = card;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted)
          setState(() {
            placedCards.remove(cardToReturn["text"]);
            remainingCards.add(cardToReturn);
            remainingCards.shuffle(Random());
            _animateSeesaw(0);
          });
      });

      if (lives <= 0) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) setState(() => _screen = 3);
        });
      }
    }
  }

  void _showFeedback(bool correct, String msg) {
    setState(() {
      showFeedback = true;
      feedbackCorrect = correct;
      feedbackMessage = msg;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => showFeedback = false);
    });
  }

  void _resetGame() {
    setState(() {
      remainingCards = List.from(allCards)..shuffle(Random());
      placedCards = {};
      lives = 3;
      selectedCard = null;
      showFeedback = false;
      _screen = 1;
    });
    _animateSeesaw(0);
  }

  int get _cohortPlaced =>
      placedCards.values.where((v) => v == "cohort").length;
  int get _ccPlaced =>
      placedCards.values.where((v) => v == "casecontrol").length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _fwBg,
        child: Column(children: [
          _buildHeader(),
          if (_screen == 1) _buildScoreBar(),
          Expanded(
              child: _screen == 0
                  ? _buildIntro()
                  : _screen == 2
                      ? _buildWinScreen()
                      : _screen == 3
                          ? _buildLoseScreen()
                          : _buildGame()),
        ]),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────
  Widget _buildHeader() => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_fwBlueDark, _fwRed],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Fire & Water Balance',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: () => widget.onGoHome?.call(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.5), width: 1)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.home_rounded, size: 14, color: Colors.white),
                SizedBox(width: 5),
                Text('Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ]),
      );

  Widget _buildScoreBar() => Container(
        color: _fwBlueLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Lives
          Row(children: [
            const Text('Lives: ',
                style: TextStyle(fontSize: 12, color: _fwTextMid)),
            ...List.generate(
                3,
                (i) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        i < lives
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: i < lives ? _fwRed : const Color(0xFFCCCCCC),
                      ),
                    )),
          ]),
          Text('${placedCards.length} / ${allCards.length} placed',
              style: const TextStyle(fontSize: 12, color: _fwTextMid)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: _fwBlue, borderRadius: BorderRadius.circular(20)),
            child: Text(
                '${(placedCards.length / allCards.length * 100).round()}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ]),
      );

  // ── Intro screen ─────────────────────────────────────────
  Widget _buildIntro() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SizedBox(height: 8),

        // Hero banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_fwBlueDark, Color(0xFF8B1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 16,
                  offset: Offset(0, 6))
            ],
          ),
          child: Column(children: [
            // Seesaw preview
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(children: [
                const Text('🔭', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('COHORT\n💧 Water',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
              Column(children: [
                const Text('⚖️', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 4),
                const Text('vs',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ]),
              Column(children: [
                const Text('🔍', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('CASE-CTRL\n🔥 Fire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            const Text('Case-Control vs Cohort',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('The Final Integrative Game!',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 20),

        // How to play
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _fwBorder),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.info_outline_rounded, color: _fwBlue, size: 20),
              SizedBox(width: 8),
              Text('How to Play',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _fwTextDark)),
            ]),
            const SizedBox(height: 14),
            _introStep(
                '1',
                'Statement cards will appear at the bottom of the screen.',
                Icons.style_rounded,
                _fwBlue),
            _introStep('2', 'TAP a card to select it — it turns yellow.',
                Icons.touch_app_rounded, _fwOrange),
            _introStep(
                '3',
                'TAP the correct side to place it:\n💧 COHORT (blue/water side)\n🔥 CASE-CTRL (red/fire side)',
                Icons.compare_arrows_rounded,
                _fwGreen),
            _introStep(
                '4',
                'Wrong placement = seesaw tilts and you lose a life ❤️. You have 3 lives.',
                Icons.favorite_rounded,
                _fwRed),
            _introStep(
                '5',
                'Place all 14 cards correctly to achieve PERFECT BALANCE and win!',
                Icons.emoji_events_rounded,
                _fwGreen,
                isLast: true),
          ]),
        ),
        const SizedBox(height: 16),

        // Quick reference
        Row(children: [
          Expanded(
              child: _sideCard(
            '💧 COHORT',
            'Exposure → Forward → RR',
            _fwBlueLight,
            _fwBlue,
          )),
          const SizedBox(width: 10),
          Expanded(
              child: _sideCard(
            '🔥 CASE-CTRL',
            'Disease → Backward → OR',
            _fwRedLight,
            _fwRed,
          )),
        ]),
        const SizedBox(height: 20),

        // Start button
        GestureDetector(
          onTap: () => setState(() => _screen = 1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [_fwBlueDark, _fwRed],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 12,
                    offset: Offset(0, 6))
              ],
            ),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('⚖️', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Text('Start Balancing!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17)),
                ]),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onGoHome?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _fwBorder, width: 1.5)),
            child: const Text('Back to Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _fwTextMid,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
        ),
      ]),
    );
  }

  Widget _introStep(String num, String text, IconData icon, Color color,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Center(child: Icon(icon, size: 16, color: color)),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: _fwTextMid, height: 1.5))),
      ]),
    );
  }

  Widget _sideCard(String title, String subtitle, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Column(children: [
        Text(title,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, color: border)),
        const SizedBox(height: 4),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11, color: border.withOpacity(0.8), height: 1.4)),
      ]),
    );
  }

  // ── Game screen ──────────────────────────────────────────
  Widget _buildGame() {
    final cohortPlacedList = placedCards.entries
        .where((e) => e.value == "cohort")
        .map((e) => e.key)
        .toList();
    final ccPlacedList = placedCards.entries
        .where((e) => e.value == "casecontrol")
        .map((e) => e.key)
        .toList();

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(
            showFeedback && !feedbackCorrect ? _shakeAnim.value * 0.3 : 0, 0),
        child: child,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          // ── Seesaw ─────────────────────────────────────
          _buildSeesaw(_cohortPlaced, _ccPlaced),
          const SizedBox(height: 10),

          // Flash overlay feedback
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6,
            decoration: BoxDecoration(
              color: _flashCorrect
                  ? _fwGreen
                  : _flashWrong
                      ? _fwRed
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),

          // ── Drop zones ─────────────────────────────────
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: _buildDropZone(
              side: "cohort",
              emoji: "💧",
              title: "COHORT",
              subtitle: "Exposure → Forward → RR",
              bgColor: const Color(0xFFDBEEFD),
              borderColor: _fwBlue,
              placedItems: cohortPlacedList,
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _buildDropZone(
              side: "casecontrol",
              emoji: "🔥",
              title: "CASE-CTRL",
              subtitle: "Disease → Backward → OR",
              bgColor: const Color(0xFFFDE8E8),
              borderColor: _fwRed,
              placedItems: ccPlacedList,
            )),
          ]),
          const SizedBox(height: 12),

          // ── Feedback banner ─────────────────────────────
          if (showFeedback) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: feedbackCorrect ? _fwGreenLight : _fwRedLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: feedbackCorrect ? _fwGreen : _fwRed, width: 1.5),
              ),
              child: Row(children: [
                Text(feedbackCorrect ? '✅' : '❌',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(feedbackMessage,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: feedbackCorrect
                              ? const Color(0xFF1A5E2A)
                              : const Color(0xFF8B0000),
                          height: 1.4)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
          ],

          // ── Instruction reminder ────────────────────────
          if (selectedCard == null && !showFeedback)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: const Row(children: [
                Icon(Icons.touch_app_rounded,
                    size: 16, color: Color(0xFFE65100)),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Tap a card below to select it, then tap the correct side above',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF795548),
                            fontWeight: FontWeight.w500))),
              ]),
            ),

          if (selectedCard != null && !showFeedback)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8C0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
              ),
              child: const Row(children: [
                Icon(Icons.arrow_upward_rounded,
                    size: 16, color: Color(0xFFE65100)),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Card selected! Now tap COHORT (💧) or CASE-CTRL (🔥) above to place it',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF795548),
                            fontWeight: FontWeight.w600))),
              ]),
            ),

          const SizedBox(height: 10),

          // ── Cards to place ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _fwBorder),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A4A90D9),
                    blurRadius: 6,
                    offset: Offset(0, 2))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.style_rounded, size: 16, color: _fwBlue),
                const SizedBox(width: 6),
                Text(
                  remainingCards.isEmpty
                      ? 'All cards placed!'
                      : 'Statement Cards (${remainingCards.length} remaining) — tap to select:',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _fwTextMid),
                ),
              ]),
              const SizedBox(height: 10),
              remainingCards.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: _fwGreenLight,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                          'All 14 cards placed! The seesaw is balanced!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _fwGreen, fontWeight: FontWeight.w700)))
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: remainingCards.map((card) {
                        final isSelected = selectedCard == card["text"];
                        return GestureDetector(
                          onTap: () => _selectCard(card["text"]),
                          child: AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, child) => Transform.scale(
                              scale: isSelected ? _pulseAnim.value : 1.0,
                              child: child,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFFF176)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFFD700)
                                      : _fwBorder,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color: const Color(0xFFFFD700)
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1)
                                      ]
                                    : [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 4)
                                      ],
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      const Icon(Icons.check_circle_rounded,
                                          size: 14, color: Color(0xFFE65100)),
                                      const SizedBox(width: 5),
                                    ],
                                    Text(card["text"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFF5D4037)
                                                : _fwTextDark)),
                                  ]),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ]),
          ),
          const SizedBox(height: 12),

          // Home button
          GestureDetector(
            onTap: () => widget.onGoHome?.call(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _fwBorder, width: 1.5)),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_rounded, size: 15, color: _fwBlue),
                    SizedBox(width: 7),
                    Text('Back to Home',
                        style: TextStyle(
                            color: _fwBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Drop zone ────────────────────────────────────────────
  Widget _buildDropZone({
    required String side,
    required String emoji,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color borderColor,
    required List<String> placedItems,
  }) {
    final isActive = selectedCard != null;
    return GestureDetector(
      onTap: () => _placeCard(side),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 130),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? bgColor : bgColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? borderColor : borderColor.withOpacity(0.4),
            width: isActive ? 2.5 : 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: borderColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1)
                ]
              : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Title row
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: borderColor)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 9,
                          color: borderColor.withOpacity(0.8),
                          height: 1.3)),
                ])),
            // Count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: borderColor, borderRadius: BorderRadius.circular(10)),
              child: Text('${placedItems.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 6),

          // Place here prompt
          if (isActive)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: borderColor.withOpacity(0.5), width: 1)),
              child: Text('Tap to place here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: borderColor)),
            ),

          if (placedItems.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...placedItems.map((text) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: borderColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor.withOpacity(0.3))),
                  child: Row(children: [
                    Icon(Icons.check_circle_rounded,
                        size: 12, color: borderColor),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Text(text,
                            style: TextStyle(
                                fontSize: 10,
                                color: borderColor,
                                fontWeight: FontWeight.w600))),
                  ]),
                )),
          ],
        ]),
      ),
    );
  }

  // ── Seesaw ───────────────────────────────────────────────
  Widget _buildSeesaw(int cohortCount, int ccCount) {
    return AnimatedBuilder(
      animation: _seesawAnim,
      builder: (_, __) {
        final angle = _seesawAnim.value * pi / 180;
        final balanced = _seesawAnim.value.abs() < 2;
        return Container(
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _fwBlueLight.withOpacity(0.7),
                _fwRedLight.withOpacity(0.7),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _fwBorder),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          child: Stack(alignment: Alignment.center, children: [
            // Fulcrum
            Positioned(
              bottom: 4,
              child: Column(children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      color: _fwTextMid,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2), blurRadius: 4)
                      ]),
                ),
                Container(width: 4, height: 20, color: _fwTextMid),
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _fwTextMid,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ]),
            ),

            // Beam
            Positioned(
              bottom: 44,
              left: 8,
              right: 8,
              child: Transform.rotate(
                angle: angle,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_fwBlueDark, Color(0xFF6A1A1A)]),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                ),
              ),
            ),

            // Left character (Cohort)
            Positioned(
              left: 12,
              bottom: 50,
              child: Transform.rotate(
                angle: angle,
                child: AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _bounceAnim.value),
                    child: Column(children: [
                      const Text('🔭', style: TextStyle(fontSize: 30)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: _fwBlue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('$cohortCount',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),

            // Right character (Case-Control)
            Positioned(
              right: 12,
              bottom: 50,
              child: Transform.rotate(
                angle: -angle,
                child: AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, -_bounceAnim.value),
                    child: Column(children: [
                      const Text('🔍', style: TextStyle(fontSize: 30)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: _fwRed,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('$ccCount',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),

            // Balance label
            Positioned(
              top: 6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: balanced ? _fwGreenLight : _fwRedLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: balanced ? _fwGreen : _fwRed),
                ),
                child: Text(
                  balanced
                      ? '⚖️  Balanced!'
                      : _seesawAnim.value < 0
                          ? '💧 Cohort side heavy!'
                          : '🔥 Case-Control side heavy!',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: balanced ? _fwGreen : _fwRed),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  // ── Win screen ───────────────────────────────────────────
  Widget _buildWinScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 20),

        // Hero scene
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [_fwBlueDark, Color(0xFF6A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 16,
                  offset: Offset(0, 6))
            ],
          ),
          child: Column(children: [
            const Text('⚖️', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            const Text('Perfect Balance Achieved!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Fire turns to sparkles ✨  •  Water shimmers 🌊',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(children: [
                const Text('🔭', style: TextStyle(fontSize: 32)),
                const Text('Cohort\nExplorer',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 10)),
              ]),
              const Text('🤝', style: TextStyle(fontSize: 28)),
              Column(children: [
                const Text('🔍', style: TextStyle(fontSize: 32)),
                const Text('Case-Control\nDetective',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 10)),
              ]),
            ]),
          ]),
        ),
        const SizedBox(height: 20),

        // Score card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: _fwBlueLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _fwBorder)),
          child: Column(children: [
            const Text('Master of Analytical Epidemiology!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: _fwBlue)),
            const SizedBox(height: 8),
            const Text('100%',
                style: TextStyle(
                    fontSize: 52, fontWeight: FontWeight.w900, color: _fwBlue)),
            const Text('All 14 cards correctly balanced',
                style: TextStyle(fontSize: 12, color: _fwTextMid)),
          ]),
        ),
        const SizedBox(height: 24),

        Image.network(
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
          width: 90,
          height: 90,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.emoji_events_rounded, size: 80, color: _fwBlue),
        ),
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => widget.onBackToHome?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: _fwBlue,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x4D4A90D9),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Text('Back to Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17)),
          ),
        ),
      ]),
    );
  }

  // ── Lose screen ──────────────────────────────────────────
  Widget _buildLoseScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 40),
        const Text('💔', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        const Text('Seesaw Lost Balance!',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: _fwTextDark)),
        const SizedBox(height: 8),
        const Text(
            "You ran out of lives!\nDon't give up — review the concepts and try again!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _fwTextMid, height: 1.5)),
        const SizedBox(height: 24),

        // Quick reminder
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: _fwBlueLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _fwBorder)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Quick Reminder:',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _fwBlue)),
            const SizedBox(height: 8),
            _reminderRow('💧 COHORT',
                'Starts with EXPOSURE, moves FORWARD, calculates RR', _fwBlue),
            const SizedBox(height: 6),
            _reminderRow('🔥 CASE-CTRL',
                'Starts with DISEASE, looks BACKWARD, calculates OR', _fwRed),
          ]),
        ),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: _resetGame,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: _fwBlue,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x4D4A90D9),
                      blurRadius: 12,
                      offset: Offset(0, 4))
                ]),
            child: const Text('Try Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onGoHome?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _fwBorder, width: 1.5)),
            child: const Text('Back to Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _fwTextMid,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ),
      ]),
    );
  }

  Widget _reminderRow(String title, String desc, Color color) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 8),
      Expanded(
          child: Text(desc,
              style: TextStyle(fontSize: 12, color: color, height: 1.4))),
    ]);
  }
}

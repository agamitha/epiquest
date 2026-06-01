// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ── Theme (matches Module 1) ──────────────────────────────────────────────
const Color _gfBlue = Color(0xFF4A90D9);
const Color _gfBlueLight = Color(0xFFE3F0FB);
const Color _gfBg = Color(0xFFF0F4FF);
const Color _gfGreen = Color(0xFF2A9940);
const Color _gfGreenLight = Color(0xFFE8FAEA);
const Color _gfRed = Color(0xFFD94040);
const Color _gfRedLight = Color(0xFFFFEAEA);
const Color _gfBorder = Color(0xFFBDD5EE);
const Color _gfTextDark = Color(0xFF1E293B);
const Color _gfTextMid = Color(0xFF475569);

class SaveTheGoldfish extends StatefulWidget {
  const SaveTheGoldfish({
    Key? key,
    this.width,
    this.height,
    this.onGameComplete,
    this.onNextGame,
    this.onGoHome,
    this.onBackToMenu,
    this.savedScore, // ← PATCH: added
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function(int scorePercent)? onGameComplete;
  final Future<dynamic> Function()? onNextGame;
  final Future<dynamic> Function()? onGoHome;
  final Future<dynamic> Function()? onBackToMenu;
  final int?
      savedScore; // retain highest score — only update if new score beats this

  @override
  State<SaveTheGoldfish> createState() => _SaveTheGoldfishState();
}

class _SaveTheGoldfishState extends State<SaveTheGoldfish>
    with TickerProviderStateMixin {
  int currentRound = 0;
  double waterLevel = 0.2;
  bool gameWon = false;
  String feedbackMessage = "";
  bool showFeedback = false;
  bool feedbackCorrect = false;
  int _totalCorrect = 0;
  int _totalItems = 0;

  late AnimationController _fishController;
  late Animation<double> _fishAnimation;
  late AnimationController _waterController;
  late Animation<double> _waterAnimation;

  final List<String> sequenceItems = [
    "Select disease-free subjects",
    "Measure exposure",
    "Identify comparison group",
    "Follow-up",
    "Calculate incidence & RR",
  ];
  List<String> userSequence = [];
  List<String> availableSequence = [];

  final Map<String, String> sortItems = {
    "Exposure measured today": "prospective",
    "Outcome occurs in the future": "prospective",
    "Long duration": "prospective",
    "Better quality data collection": "prospective",
    "Uses historical records": "retrospective",
    "Exposure and outcome already occurred": "retrospective",
    "Faster & cheaper": "retrospective",
    "Limited to available data": "retrospective",
  };
  Map<String, String?> userSort = {};

  final Map<String, String> matchItems = {
    "RR": "Risk among exposed ÷ risk among unexposed",
    "AR": "Risk difference between exposed and unexposed",
    "Incidence (Exposed)": "New cases / total exposed",
    "Incidence (Unexposed)": "New cases / total unexposed",
  };
  Map<String, String?> userMatch = {};

  @override
  void initState() {
    super.initState();
    availableSequence = List.from(sequenceItems)..shuffle();
    _fishController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);
    _fishAnimation = Tween<double>(begin: -5, end: 5).animate(
        CurvedAnimation(parent: _fishController, curve: Curves.easeInOut));
    _waterController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _waterAnimation = Tween<double>(begin: waterLevel, end: waterLevel).animate(
        CurvedAnimation(parent: _waterController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _fishController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _animateWater(double newLevel) {
    _waterAnimation = Tween<double>(begin: waterLevel, end: newLevel).animate(
        CurvedAnimation(parent: _waterController, curve: Curves.easeInOut));
    _waterController.forward(from: 0);
    setState(() => waterLevel = newLevel);
  }

  void _showFeedbackMsg(bool correct, String message) {
    setState(() {
      showFeedback = true;
      feedbackCorrect = correct;
      feedbackMessage = message;
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => showFeedback = false);
    });
  }

  void _addToSequence(String item) => setState(() {
        availableSequence.remove(item);
        userSequence.add(item);
      });

  void _removeFromSequence(String item) => setState(() {
        userSequence.remove(item);
        availableSequence.add(item);
      });

  void _checkSequence() {
    bool correct = userSequence.length == sequenceItems.length;
    if (correct)
      for (int i = 0; i < sequenceItems.length; i++)
        if (userSequence[i] != sequenceItems[i]) {
          correct = false;
          break;
        }
    if (correct) {
      setState(() {
        _totalCorrect += sequenceItems.length;
        _totalItems += sequenceItems.length;
      });
      _animateWater(0.5);
      _showFeedbackMsg(
          true, "🎉 Correct sequence! Fish jumps happily! Water rising!");
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) setState(() => currentRound = 1);
      });
    } else {
      setState(() {
        _totalItems += sequenceItems.length;
      });
      _showFeedbackMsg(false,
          "❌ Wrong order! Correct: Select subjects → Measure exposure → Comparison group → Follow-up → Calculate RR");
    }
  }

  void _checkSort() {
    bool ok = userSort.length == sortItems.length;
    if (ok)
      for (final e in sortItems.entries)
        if (userSort[e.key] != e.value) {
          ok = false;
          break;
        }
    if (ok) {
      setState(() {
        _totalCorrect += sortItems.length;
        _totalItems += sortItems.length;
      });
      _animateWater(0.8);
      _showFeedbackMsg(true, "🎉 Perfect sorting! Water filling up!");
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) setState(() => currentRound = 2);
      });
    } else {
      setState(() {
        _totalItems += sortItems.length;
      });
      _showFeedbackMsg(false, "❌ Some items are in the wrong bucket!");
    }
  }

  void _checkMatch() {
    bool ok = userMatch.length == matchItems.length;
    if (ok)
      for (final e in matchItems.entries)
        if (userMatch[e.key] != e.value) {
          ok = false;
          break;
        }
    if (ok) {
      setState(() {
        _totalCorrect += matchItems.length;
        _totalItems += matchItems.length;
      });
      _animateWater(1.0);
      _showFeedbackMsg(true, "🎉 All matched! Bowl is full! Goldfish saved!");
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() => gameWon = true);
          final score = _totalItems == 0
              ? 100
              : ((_totalCorrect / _totalItems) * 100).round();
          // ── PATCH: only save if new score beats current best ──────────
          if (score > (widget.savedScore ?? 0)) {
            widget.onGameComplete?.call(score);
          }
        }
      });
    } else {
      setState(() {
        _totalItems += matchItems.length;
      });
      _showFeedbackMsg(
          false, "❌ Some matches are wrong! Review the risk measure formulas.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _gfBg,
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
        color: _gfBlue,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Save the Goldfish',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
        color: _gfBlueLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Round ${currentRound + 1} of 3',
              style: const TextStyle(
                  color: _gfBlue, fontWeight: FontWeight.w700, fontSize: 13)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                  color: _gfBlue, borderRadius: BorderRadius.circular(20)),
              child: Text('${(waterLevel * 100).round()}% full',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12))),
        ]),
      );

  Widget _buildGame() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _buildFishBowl(),
        const SizedBox(height: 16),
        if (currentRound == 0) _buildRound1(),
        if (currentRound == 1) _buildRound2(),
        if (currentRound == 2) _buildRound3(),
        if (showFeedback) ...[
          const SizedBox(height: 12),
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: feedbackCorrect ? _gfGreenLight : _gfRedLight,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: feedbackCorrect ? _gfGreen : _gfRed)),
              child: Text(feedbackMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: feedbackCorrect
                          ? const Color(0xFF1A5E2A)
                          : const Color(0xFF8B0000)))),
        ],
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => widget.onBackToMenu?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _gfBlue, width: 1.5)),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grid_view_rounded, size: 15, color: _gfBlue),
                  SizedBox(width: 7),
                  Text('Games Menu',
                      style: TextStyle(
                          color: _gfBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildFishBowl() {
    return Center(
        child: SizedBox(
      width: 160,
      height: 160,
      child: Stack(alignment: Alignment.center, children: [
        Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gfBlueLight,
                border: Border.all(color: _gfBlue, width: 3))),
        ClipOval(
            child: AnimatedBuilder(
          animation: _waterController,
          builder: (_, __) => Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: 140,
                  height: 140 * _waterAnimation.value,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                        _gfBlue.withOpacity(0.5),
                        _gfBlue.withOpacity(0.8)
                      ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)))),
        )),
        AnimatedBuilder(
            animation: _fishAnimation,
            builder: (_, __) => Transform.translate(
                offset: Offset(0, _fishAnimation.value),
                child: Text(waterLevel > 0.5 ? "🐟" : "😟🐟",
                    style: TextStyle(fontSize: waterLevel > 0.5 ? 36 : 24)))),
        Positioned(
            bottom: 8,
            child: Text('${(waterLevel * 100).toInt()}%',
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))),
      ]),
    ));
  }

  Widget _roundCard(String title, String subtitle, Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _gfBorder),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: _gfBlue)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: _gfTextMid)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }

  Widget _tag(String text, {Color? bg, Color? border, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: bg ?? _gfBlueLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border ?? _gfBlue)),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              color: textColor ?? _gfBlue,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildRound1() {
    return _roundCard(
        'Round 1: Sequence the Steps',
        'Tap cards in the correct order',
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Available Steps:',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _gfTextDark)),
          const SizedBox(height: 8),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSequence
                  .map((item) => GestureDetector(
                      onTap: () => _addToSequence(item), child: _tag(item)))
                  .toList()),
          const SizedBox(height: 14),
          const Text('Your Sequence (tap to remove):',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _gfTextDark)),
          const SizedBox(height: 8),
          ...List.generate(
              userSequence.length,
              (i) => GestureDetector(
                  onTap: () => _removeFromSequence(userSequence[i]),
                  child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                          color: _gfGreenLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _gfGreen)),
                      child: Row(children: [
                        Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: _gfGreen),
                            child: Center(
                                child: Text('${i + 1}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(userSequence[i],
                                style: const TextStyle(fontSize: 12))),
                        Icon(Icons.close, size: 16, color: _gfRed),
                      ])))),
          const SizedBox(height: 12),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: userSequence.length == sequenceItems.length
                      ? _checkSequence
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _gfBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Check Sequence ✓',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))),
        ]));
  }

  Widget _buildRound2() {
    final unassigned =
        sortItems.keys.where((k) => userSort[k] == null).toList();
    final prospective =
        sortItems.keys.where((k) => userSort[k] == "prospective").toList();
    final retrospective =
        sortItems.keys.where((k) => userSort[k] == "retrospective").toList();

    return _roundCard(
        'Round 2: Identify the Type of Cohort',
        'Tap a statement then tap the correct bucket',
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (unassigned.isNotEmpty) ...[
            const Text('Statements to sort:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _gfTextDark)),
            const SizedBox(height: 8),
            Wrap(
                spacing: 8,
                runSpacing: 8,
                children: unassigned
                    .map((item) => GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                    title: const Text("Sort this statement",
                                        style: TextStyle(fontSize: 15)),
                                    content: Text('"$item"',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() =>
                                                userSort[item] = "prospective");
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text("🔵 Prospective",
                                              style:
                                                  TextStyle(color: _gfBlue))),
                                      TextButton(
                                          onPressed: () {
                                            setState(() => userSort[item] =
                                                "retrospective");
                                            Navigator.pop(ctx);
                                          },
                                          child: Text("🟤 Retrospective",
                                              style: TextStyle(
                                                  color:
                                                      Colors.brown.shade700))),
                                    ])),
                        child: _tag(item)))
                    .toList()),
            const SizedBox(height: 14),
          ],
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: _bucket(
                    '🔵 Prospective', prospective, _gfBlueLight, _gfBlue)),
            const SizedBox(width: 8),
            Expanded(
                child: _bucket('🟤 Retrospective', retrospective,
                    const Color(0xFFFBEEE8), Colors.brown.shade400)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed:
                      userSort.length == sortItems.length ? _checkSort : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _gfBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Check Sorting ✓',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))),
        ]));
  }

  Widget _bucket(String label, List<String> items, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border)),
      child: Column(children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w800, color: border, fontSize: 13)),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text('Drop here',
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12))
        else
          ...items.map((item) => GestureDetector(
              onTap: () => setState(() => userSort.remove(item)),
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(item, style: const TextStyle(fontSize: 11))))),
      ]),
    );
  }

  Widget _buildRound3() {
    final definitions = matchItems.values.toList();
    return _roundCard(
        'Round 3: Match Risk Measures',
        'Tap a term, then tap its matching definition',
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Terms:',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _gfTextDark)),
          const SizedBox(height: 8),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: matchItems.keys.map((term) {
                final isMatched = userMatch[term] != null;
                return GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                            title: Text("Match: $term",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: definitions
                                    .map((def) => GestureDetector(
                                        onTap: () {
                                          setState(() => userMatch[term] = def);
                                          Navigator.pop(ctx);
                                        },
                                        child: Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: _gfBlueLight,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: _gfBorder)),
                                            child: Text(def,
                                                style: const TextStyle(
                                                    fontSize: 13)))))
                                    .toList()))),
                    child: _tag(term,
                        bg: isMatched ? _gfGreenLight : _gfBlueLight,
                        border: isMatched ? _gfGreen : _gfBlue,
                        textColor: isMatched ? _gfGreen : _gfBlue));
              }).toList()),
          const SizedBox(height: 14),
          if (userMatch.isNotEmpty) ...[
            const Text('Your Matches:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _gfTextDark)),
            const SizedBox(height: 6),
            ...userMatch.entries.map((e) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _gfBlueLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _gfBorder)),
                child: Row(children: [
                  Text(e.key,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _gfBlue)),
                  const SizedBox(width: 8),
                  const Text('→', style: TextStyle(color: _gfTextMid)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(e.value ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: _gfTextMid))),
                ]))),
            const SizedBox(height: 12),
          ],
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: userMatch.length == matchItems.length
                      ? _checkMatch
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _gfBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Check Matches ✓',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))),
        ]));
  }

  Widget _buildWinScreen() => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 20),
          Image.network(
              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
              width: 100,
              height: 100,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.emoji_events_rounded,
                  size: 80,
                  color: _gfBlue)),
          const SizedBox(height: 20),
          const Text('Goldfish Saved! 🐟',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w800, color: _gfBlue)),
          const SizedBox(height: 8),
          const Text('Save the Goldfish Complete!',
              style: TextStyle(fontSize: 14, color: _gfTextMid)),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  color: _gfBlueLight, borderRadius: BorderRadius.circular(16)),
              child: const Column(children: [
                Text('💧 All 3 Rounds Complete! 💧',
                    style: TextStyle(fontSize: 14, color: _gfTextMid)),
                SizedBox(height: 4),
                Text('100%',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: _gfBlue)),
              ])),
          const SizedBox(height: 28),
          GestureDetector(
              onTap: () => widget.onNextGame?.call(),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: _gfBlue,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x4D4A90D9),
                            blurRadius: 16,
                            offset: Offset(0, 6))
                      ]),
                  child: const Text('View Results',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)))),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: () => widget.onBackToMenu?.call(),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: const Color(0xFFD8E4F0), width: 1.5)),
                  child: const Text('Games Menu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _gfTextMid,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)))),
        ]),
      );
}

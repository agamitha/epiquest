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

class DragDrop extends StatefulWidget {
  const DragDrop({
    Key? key,
    this.width,
    this.height,
    this.onGameComplete,
    this.onNextGame,
    this.onGoHome,
    this.onBackToMenu,
    this.onReviewContent,
    this.savedScore,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function(int scorePercent)? onGameComplete;
  final Future<dynamic> Function()? onNextGame;
  final Future<dynamic> Function()? onGoHome;
  final Future<dynamic> Function()? onBackToMenu;
  final Future<dynamic> Function()? onReviewContent;
  final int?
      savedScore; // retain highest score — only update if new score beats this

  @override
  State<DragDrop> createState() => _DragDropState();
}

const Color _ddBlue = Color(0xFF4A90D9);
const Color _ddBlueLight = Color(0xFFE3F0FB);
const Color _ddBg = Color(0xFFF0F4FF);
const Color _ddGreen = Color(0xFF2A9940);
const Color _ddGreenLight = Color(0xFFE8FAEA);
const Color _ddRed = Color(0xFFD94040);
const Color _ddRedLight = Color(0xFFFFEAEA);
const Color _ddAmber = Color(0xFFF59E0B);
const Color _ddAmberLight = Color(0xFFFEF3C7);
const Color _ddTextDark = Color(0xFF1E293B);
const Color _ddTextMid = Color(0xFF475569);
const Color _ddDivider = Color(0xFFD8E4F0);
const int _ddPass = 80;

class _DragDropState extends State<DragDrop> {
  int _currentSet = 0;
  int _totalCorrect = 0;
  int _totalItems = 0;
  bool _gameWon = false;

  // ── Set 1: Sequence ────────────────────────────────────────────────
  final List<String> _correctSeq = [
    'Select Cases',
    'Select Controls',
    'Matching',
    'Measure Exposure',
    'Analyze & Interpret',
  ];
  List<String?> _seqSlots = [null, null, null, null, null];
  final List<String> _seqCards = [
    'Matching',
    'Select Cases',
    'Analyze & Interpret',
    'Measure Exposure',
    'Select Controls',
  ];
  // 2 TOTAL submission attempts for Set 1 (not per-card moves)
  int _seqAttempts = 0;
  bool _seqChecked = false; // has the sequence been submitted at least once?
  bool _showSeqRedirect = false;

  // ── Set 2: Sources ──────────────────────────────────────────────────
  final Map<String, String> _sourceAns = {
    'Hospitals': 'cases',
    'Population registries': 'cases',
    'Ongoing cohort study': 'cases',
    'Relatives': 'controls',
    'Neighborhood': 'controls',
    'General population': 'controls',
  };
  Map<String, String?> _sourcePlaced = {};
  late List<String> _shuffledSourceKeys;

  // ── Set 3: Bias — count on actual DROP, not hover ──────────────────
  // Use accept-all approach: onWillAccept=true always,
  // wrong drops handled in onAccept (only fires on actual release)
  final Map<String, String> _biasAns = {
    'Interviewer probes cases more': 'Interviewer bias',
    'Selecting advanced cases only': 'Prevalence-incidence bias',
    'Cases remember more exposures': 'Recall bias',
    'Exposure correlated with another risk factor': 'Confounding',
    'Hospital admission patterns affect sample': 'Berksonian bias',
    'Distant events recalled as recent': 'Telescoping',
  };
  Map<String, String?> _biasPlaced = {};
  late List<String> _shuffledBiasKeys;
  int _biasWrongDrops = 0; // counts on actual release only
  bool _showBiasDialog = false;

  @override
  void initState() {
    super.initState();
    for (final k in _sourceAns.keys) _sourcePlaced[k] = null;
    for (final k in _biasAns.keys) _biasPlaced[k] = null;
    _totalItems = _correctSeq.length + _sourceAns.length + _biasAns.length;
    _shuffledSourceKeys = _sourceAns.keys.toList()..shuffle(Random());
    _shuffledBiasKeys = _biasAns.keys.toList()..shuffle(Random());
  }

  // ── Set 1 check & advance ──────────────────────────────────────────
  void _checkAndSubmitSeq() {
    _seqAttempts++;
    _seqChecked = true;
    final allCorrect =
        List.generate(5, (i) => _seqSlots[i] == _correctSeq[i]).every((v) => v);

    if (allCorrect) {
      // Correct — advance
      setState(() {});
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _nextSet();
      });
    } else if (_seqAttempts >= 2) {
      // Used up both attempts — show redirect
      setState(() => _showSeqRedirect = true);
    } else {
      // 1st wrong attempt — show feedback, allow one more try
      setState(() {});
    }
  }

  // ── Completion checks ──────────────────────────────────────────────
  bool get _seq1AllFilled => _seqSlots.every((s) => s != null);
  bool get _src2Done => _sourcePlaced.values.every((v) => v != null);
  bool get _bias3Done => _biasPlaced.values.every((v) => v != null);

  void _nextSet() {
    if (_currentSet == 0) {
      for (int i = 0; i < _correctSeq.length; i++) {
        if (_seqSlots[i] == _correctSeq[i]) _totalCorrect++;
      }
    } else if (_currentSet == 1) {
      // All placed items are correct (wrong ones rejected by onWillAccept)
      _totalCorrect += _sourcePlaced.values.where((v) => v != null).length;
    } else if (_currentSet == 2) {
      // All placed items are correct (wrong ones returned to pool silently)
      _totalCorrect += _biasPlaced.values.where((v) => v != null).length;
    }
    setState(() => _currentSet++);
    if (_currentSet >= 3) {
      final score =
          _totalItems == 0 ? 0 : ((_totalCorrect / _totalItems) * 100).round();
      setState(() => _gameWon = true);
      // Only update if new score beats the saved best
      if (score > (widget.savedScore ?? 0)) {
        widget.onGameComplete?.call(score);
      }
    }
  }

  // Reset Set 3 (used by "Restart This Set" in bias dialog)
  void _restartSet3() {
    setState(() {
      for (final k in _biasAns.keys) _biasPlaced[k] = null;
      _biasWrongDrops = 0;
      _showBiasDialog = false;
      _shuffledBiasKeys = _biasAns.keys.toList()..shuffle(Random());
    });
  }

  int get _scorePercent =>
      _totalItems == 0 ? 0 : ((_totalCorrect / _totalItems) * 100).round();

  // ── Shared card widget ─────────────────────────────────────────────
  Widget _card(String label) {
    return Draggable<String>(
      data: label,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: _ddBlue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Color(0x334A90D9), blurRadius: 8)
              ]),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
      childWhenDragging: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: _ddDivider, borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.transparent)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _ddBlueLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _ddBlue, width: 1.5),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: _ddBlue)),
      ),
    );
  }

  Widget _setHeader(String badge, String title, String subtitle) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
            color: _ddBlue, borderRadius: BorderRadius.circular(20)),
        child: Text(badge,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ),
      const SizedBox(height: 10),
      Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: _ddTextDark)),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(fontSize: 13, color: _ddTextMid)),
    ]);
  }

  Widget _nextBtn({String label = 'Next Set'}) {
    return GestureDetector(
      onTap: _nextSet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            color: _ddBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x334A90D9), blurRadius: 8, offset: Offset(0, 4))
            ]),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15)),
      ),
    );
  }

  Widget _gamesMenuBtn() {
    return GestureDetector(
      onTap: () => widget.onBackToMenu?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _ddBlue, width: 1.5)),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.grid_view_rounded, size: 15, color: _ddBlue),
          SizedBox(width: 7),
          Text('Games Menu',
              style: TextStyle(
                  color: _ddBlue, fontWeight: FontWeight.w700, fontSize: 14)),
        ]),
      ),
    );
  }

  // ── Set 1: Sequence — 2 total submission attempts ──────────────────
  Widget _buildSet1() {
    final remaining = _seqCards.where((c) => !_seqSlots.contains(c)).toList();
    final attemptsLeft = 2 - _seqAttempts;
    final allFilled = _seq1AllFilled;

    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _setHeader('Set 1 of 3', 'Sequence the Study Steps',
            'Drag cards into the correct order'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: attemptsLeft > 0 ? _ddAmberLight : _ddRedLight,
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(Icons.info_outline_rounded,
                size: 14, color: attemptsLeft > 0 ? _ddAmber : _ddRed),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              _seqAttempts == 0
                  ? 'Fill all 5 slots then tap "Check Sequence". You get 2 attempts.'
                  : attemptsLeft > 0
                      ? 'Wrong sequence! $attemptsLeft attempt${attemptsLeft == 1 ? "" : "s"} remaining — fix and try again.'
                      : 'No attempts left.',
              style: TextStyle(
                  fontSize: 11,
                  color: attemptsLeft > 0 ? _ddTextMid : _ddRed,
                  fontWeight:
                      _seqAttempts > 0 ? FontWeight.w700 : FontWeight.w400),
            )),
          ]),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (i) {
          final placed = _seqSlots[i];
          final correct =
              _seqChecked && placed != null ? placed == _correctSeq[i] : null;
          return DragTarget<String>(
            onAccept: (card) {
              setState(() {
                final prevIdx = _seqSlots.indexOf(card);
                if (prevIdx != -1) _seqSlots[prevIdx] = null;
                _seqSlots[i] = card;
                _seqChecked = false; // reset check state when card moved
              });
            },
            builder: (ctx, cands, _) {
              final hover = cands.isNotEmpty;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 52,
                decoration: BoxDecoration(
                  color: correct == true
                      ? _ddGreenLight
                      : correct == false
                          ? _ddRedLight
                          : hover
                              ? _ddBlueLight
                              : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: correct == true
                        ? _ddGreen
                        : correct == false
                            ? _ddRed
                            : hover
                                ? _ddBlue
                                : _ddDivider,
                    width: 1.5,
                  ),
                ),
                child: Row(children: [
                  Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: _ddTextMid))),
                  Expanded(
                      child: placed != null
                          ? Row(children: [
                              Expanded(
                                  child: Draggable<String>(
                                data: placed,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: _ddBlue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(placed,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                childWhenDragging: const SizedBox(),
                                child: Text(placed,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _ddTextDark)),
                              )),
                              if (correct != null)
                                Icon(
                                    correct
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: correct ? _ddGreen : _ddRed,
                                    size: 20),
                              const SizedBox(width: 8),
                            ])
                          : const Text('Drop here...',
                              style: TextStyle(color: Color(0xFFAAAAAA)))),
                ]),
              );
            },
          );
        }),
        const SizedBox(height: 16),
        if (remaining.isNotEmpty) ...[
          const Text('Cards to place:',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _ddTextMid,
                  fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(children: remaining.map(_card).toList()),
          const SizedBox(height: 16),
        ],
        // Check button — only when all filled and attempts remain
        if (allFilled && attemptsLeft > 0) ...[
          GestureDetector(
            onTap: _checkAndSubmitSeq,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                  color: _ddBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x334A90D9),
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]),
              child: Text(
                _seqAttempts == 0
                    ? 'Check Sequence'
                    : 'Submit Again (${attemptsLeft} left)',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        _gamesMenuBtn(),
      ]),

      // Set 1 redirect overlay (after 2 failed attempts)
      if (_showSeqRedirect)
        Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                width: 280,
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x4DD94040),
                        blurRadius: 30,
                        offset: Offset(0, 8))
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('📚', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('Review Needed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _ddRed)),
                  const SizedBox(height: 10),
                  const Text(
                    'You used both attempts. Please review the lesson on case-control study steps before continuing.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 13, color: _ddTextMid, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showSeqRedirect = false);
                      widget.onReviewContent?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                          color: _ddRed,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('Review Lessons',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Restart Set 1
                      setState(() {
                        _showSeqRedirect = false;
                        _seqSlots = [null, null, null, null, null];
                        _seqAttempts = 0;
                        _seqChecked = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _ddBlue, width: 1.5),
                      ),
                      child: const Text('Restart This Set',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _ddBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
    ]);
  }

  // ── Set 2: Sources — wrong placements rejected ──────────────────────
  Widget _buildSet2() {
    final remaining =
        _shuffledSourceKeys.where((k) => _sourcePlaced[k] == null).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _setHeader('Set 2 of 3', 'Identify Sources',
          'Drag each source to the correct bucket'),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: _ddAmberLight, borderRadius: BorderRadius.circular(8)),
        child: const Row(children: [
          Icon(Icons.info_outline_rounded, size: 14, color: _ddAmber),
          SizedBox(width: 6),
          Expanded(
              child: Text(
                  'Wrong placements are rejected — card returns to the pool.',
                  style: TextStyle(fontSize: 11, color: _ddTextMid))),
        ]),
      ),
      const SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: _bucket2(
                'cases', 'CASES', const Color(0xFF1565C0), _ddBlueLight)),
        const SizedBox(width: 10),
        Expanded(
            child: _bucket2(
                'controls', 'CONTROLS', const Color(0xFF1565C0), _ddBlueLight)),
      ]),
      const SizedBox(height: 16),
      const Text('Sources to place:',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: _ddTextMid, fontSize: 13)),
      const SizedBox(height: 8),
      Wrap(children: remaining.map(_card).toList()),
      const SizedBox(height: 16),
      if (_src2Done) ...[_nextBtn(), const SizedBox(height: 10)],
      _gamesMenuBtn(),
    ]);
  }

  Widget _bucket2(String bucket, String label, Color color, Color bgColor) {
    final placed = _sourcePlaced.entries
        .where((e) => e.value == bucket)
        .map((e) => e.key)
        .toList();
    return DragTarget<String>(
      onWillAccept: (card) => card != null && _sourceAns[card] == bucket,
      onAccept: (card) => setState(() => _sourcePlaced[card] = bucket),
      builder: (ctx, cands, rejected) {
        final hover = cands.isNotEmpty;
        final wrongHover = rejected.isNotEmpty;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: wrongHover
                ? _ddRedLight
                : hover
                    ? _ddGreenLight
                    : bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: wrongHover
                    ? _ddRed
                    : hover
                        ? _ddGreen
                        : const Color(0xFFBDD5EE),
                width: wrongHover || hover ? 2 : 1.5),
          ),
          child: Column(children: [
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: color, fontSize: 13)),
            const SizedBox(height: 8),
            if (placed.isEmpty)
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(wrongHover ? '✗ Wrong bucket!' : 'Drop here',
                      style: TextStyle(
                          color: wrongHover ? _ddRed : const Color(0xFFAAAAAA),
                          fontSize: 12,
                          fontWeight:
                              wrongHover ? FontWeight.w700 : FontWeight.w400)))
            else
              ...placed.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _ddGreenLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _ddGreen),
                    ),
                    child: Row(children: [
                      Expanded(
                          child: Text(c,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600))),
                      const Icon(Icons.check_circle_rounded,
                          color: _ddGreen, size: 16),
                    ]),
                  )),
          ]),
        );
      },
    );
  }

  // ── Set 3: Bias — count on RELEASE, not hover ──────────────────────
  // Uses accept-all (onWillAccept=true) so onAccept fires on actual drop.
  // Wrong drops: card stays in pool (not placed), count incremented.
  // After 3rd wrong drop: show dialog with Review Lessons or Restart Set.
  Widget _buildSet3() {
    final biasTypes = [
      'Recall bias',
      'Berksonian bias',
      'Interviewer bias',
      'Telescoping',
      'Confounding',
      'Prevalence-incidence bias',
    ];
    final remaining =
        _shuffledBiasKeys.where((k) => _biasPlaced[k] == null).toList();
    final wrongsLeft = 3 - _biasWrongDrops;

    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _setHeader('Set 3 of 3', 'Types of Bias',
            'Drag each statement to the correct bias type'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: _biasWrongDrops > 0 ? _ddRedLight : _ddAmberLight,
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(Icons.info_outline_rounded,
                size: 14, color: _biasWrongDrops > 0 ? _ddRed : _ddAmber),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              _biasWrongDrops == 0
                  ? 'Drag each statement to the correct bias type.'
                  : '$wrongsLeft wrong drop${wrongsLeft == 1 ? "" : "s"} remaining before redirect to lessons.',
              style: TextStyle(
                  fontSize: 11,
                  color: _biasWrongDrops > 0 ? _ddRed : _ddTextMid,
                  fontWeight:
                      _biasWrongDrops > 0 ? FontWeight.w700 : FontWeight.w400),
            )),
          ]),
        ),
        const SizedBox(height: 12),
        ...biasTypes.map((bias) => _biasBucket(bias)),
        const SizedBox(height: 16),
        const Text('Statements to place:',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: _ddTextMid, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(children: remaining.map(_card).toList()),
        const SizedBox(height: 16),
        if (_bias3Done) ...[
          _nextBtn(label: 'Finish!'),
          const SizedBox(height: 10)
        ],
        _gamesMenuBtn(),
      ]),

      // Set 3 dialog — shown after 3rd wrong drop
      if (_showBiasDialog)
        Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                width: 280,
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x4DD94040),
                        blurRadius: 30,
                        offset: Offset(0, 8))
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('📚', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('Review Needed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _ddRed)),
                  const SizedBox(height: 10),
                  const Text(
                    'You made 3 wrong placements on bias types. Please review the lesson material or restart this set.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 13, color: _ddTextMid, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showBiasDialog = false);
                      widget.onReviewContent?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                          color: _ddRed,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('Review Lessons',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Restart Set 3 — resets all Set 3 state
                  GestureDetector(
                    onTap: _restartSet3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _ddBlue, width: 1.5),
                      ),
                      child: const Text('Restart This Set',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _ddBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _biasBucket(String bias) {
    final placed = _biasPlaced.entries
        .where((e) => e.value == bias)
        .map((e) => e.key)
        .toList();
    return DragTarget<String>(
      // Accept ALL drops — correct and wrong
      // This ensures onAccept fires on actual release (not hover)
      onWillAccept: (card) => card != null,
      onAccept: (card) {
        if (_biasAns[card] == bias) {
          // CORRECT drop
          setState(() => _biasPlaced[card] = bias);
        } else {
          // WRONG drop — count it, card stays in pool (not placed)
          setState(() {
            _biasWrongDrops++;
            if (_biasWrongDrops >= 3) {
              _showBiasDialog = true;
            }
          });
          // Card is NOT added to _biasPlaced, so it stays in the pool
        }
      },
      builder: (ctx, cands, _) {
        // No red/green hint while hovering — purely neutral
        final hover = cands.isNotEmpty;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: hover ? _ddBlueLight : const Color(0xFFF8F7FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: hover ? _ddBlue : const Color(0xFFD8DBFF), width: 1.5),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(bias,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: _ddBlue, fontSize: 13)),
            if (placed.isEmpty)
              const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('Drop here...',
                      style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)))
            else
              ...placed.map((c) => Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _ddGreenLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _ddGreen),
                    ),
                    child: Row(children: [
                      Expanded(
                          child: Text(c,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500))),
                      const Icon(Icons.check_circle_rounded,
                          color: _ddGreen, size: 16),
                    ]),
                  )),
          ]),
        );
      },
    );
  }

  // ── Win screen ─────────────────────────────────────────────────────
  Widget _winScreen() {
    final pct = _scorePercent;
    final passed = pct >= _ddPass;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        Image.network(
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
          width: 100,
          height: 100,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.emoji_events_rounded, size: 80, color: _ddBlue),
        ),
        const SizedBox(height: 20),
        Text(passed ? 'All Sets Complete!' : 'Keep Practicing!',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: passed ? _ddBlue : const Color(0xFFE65100))),
        const SizedBox(height: 8),
        const Text('Drag & Drop Complete!',
            style: TextStyle(fontSize: 14, color: _ddTextMid)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              color: passed ? _ddBlueLight : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            Text('$_totalCorrect / $_totalItems correct',
                style: const TextStyle(fontSize: 14, color: _ddTextMid)),
            const SizedBox(height: 4),
            Text('$pct%',
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: passed ? _ddBlue : const Color(0xFFE65100))),
            Text(
                passed
                    ? 'You passed! ($_ddPass% required)'
                    : 'You need $_ddPass% to proceed',
                style: TextStyle(
                    fontSize: 12,
                    color: passed ? _ddBlue : const Color(0xFFE65100))),
          ]),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => widget.onNextGame?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: passed ? _ddBlue : const Color(0xFFE65100),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: passed
                          ? const Color(0x4D4A90D9)
                          : const Color(0x4DE65100),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ]),
            child: Text(passed ? 'View Results' : 'Review Module 1 Content',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        ),
      ]),
    );
  }

  // ── Root build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _ddBg,
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            color: _ddBlue,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Drag & Drop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  GestureDetector(
                    onTap: () => widget.onGoHome?.call(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 1)),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
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
          ),
          Container(
            color: _ddBlueLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Set ${_gameWon ? 3 : _currentSet + 1} of 3',
                      style: const TextStyle(
                          color: _ddBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: _ddBlue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('$_scorePercent%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
                ]),
          ),
          Container(
            height: 5,
            color: _ddDivider,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_gameWon ? 3 : _currentSet) / 3,
              child: Container(color: _ddBlue),
            ),
          ),
          Expanded(
            child: _gameWon
                ? _winScreen()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _currentSet == 0
                        ? _buildSet1()
                        : _currentSet == 1
                            ? _buildSet2()
                            : _buildSet3(),
                  ),
          ),
        ]),
      ),
    );
  }
}

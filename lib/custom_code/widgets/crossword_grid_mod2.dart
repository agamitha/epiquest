// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CrosswordGridMod2 extends StatefulWidget {
  const CrosswordGridMod2({
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
  State<CrosswordGridMod2> createState() => _CrosswordGridMod2State();
}

// -- Colours ---------------------------------------------------------------
const Color _cw2Blue = Color(0xFF4A90D9);
const Color _cw2BlueLight = Color(0xFFE3F0FB);
const Color _cw2Bg = Color(0xFFF0F4FF);
const Color _cw2GreenBg = Color(0xFFE8FAEA);
const Color _cw2RedBg = Color(0xFFFFEAEA);
const Color _cw2TextDark = Color(0xFF1E293B);
const Color _cw2TextMid = Color(0xFF475569);
const Color _cw2Border = Color(0xFFBDD5EE);
const Color _cw2Empty = Color(0xFFEEF3FA);

// -- Grid: 16 rows x 22 cols -----------------------------------------------
const int _CW2_ROWS = 16;
const int _CW2_COLS = 22;

const Map<String, String> _cw2Answers = {
  // 1 DOWN  RELATIVERISK  col=5, r0-r11
  '0,5': 'R', '1,5': 'E', '2,5': 'L', '3,5': 'A', '4,5': 'T', '5,5': 'I',
  '6,5': 'V', '7,5': 'E', '8,5': 'R', '9,5': 'I', '10,5': 'S', '11,5': 'K',

  // 3 DOWN  RETROSPECTIVE  col=15, r3-r15
  '3,15': 'R', '4,15': 'E', '5,15': 'T', '6,15': 'R', '7,15': 'O', '8,15': 'S',
  '9,15': 'P', '10,15': 'E', '11,15': 'C', '12,15': 'T', '13,15': 'I',
  '14,15': 'V', '15,15': 'E',

  // 6 DOWN  COHORT  col=6, r7-r12
  '7,6': 'C', '8,6': 'O', '9,6': 'H', '10,6': 'O', '11,6': 'R', '12,6': 'T',

  // 2 ACROSS  FOLLOWUP  r2, c3-c10
  '2,3': 'F', '2,4': 'O', '2,6': 'L', '2,7': 'O', '2,8': 'W', '2,9': 'U',
  '2,10': 'P',

  // 4 ACROSS  ATTRIBUTABLERISK  r4, c4-c19
  '4,4': 'A', '4,6': 'T', '4,7': 'R', '4,8': 'I', '4,9': 'B', '4,10': 'U',
  '4,11': 'T', '4,12': 'A', '4,13': 'B', '4,14': 'L', '4,16': 'R', '4,17': 'I',
  '4,18': 'S', '4,19': 'K',

  // 5 ACROSS  PROSPECTIVE  r7, c0-c10
  '7,0': 'P', '7,1': 'R', '7,2': 'O', '7,3': 'S', '7,4': 'P',
  '7,7': 'T', '7,8': 'I', '7,9': 'V', '7,10': 'E',

  // 7 ACROSS  CONFOUNDING  r7, c11-c21
  '7,11': 'C', '7,12': 'O', '7,13': 'N', '7,14': 'F',
  '7,16': 'U', '7,17': 'N', '7,18': 'D', '7,19': 'I', '7,20': 'N', '7,21': 'G',

  // 8 ACROSS  LATENCY  r10, c12-c18
  '10,12': 'L', '10,13': 'A', '10,14': 'T', '10,16': 'N', '10,17': 'C',
  '10,18': 'Y',

  // 9 ACROSS  INCIDENCE  r11, c13-c21
  '11,13': 'I', '11,14': 'N', '11,16': 'I', '11,17': 'D',
  '11,18': 'E', '11,19': 'N', '11,20': 'C', '11,21': 'E',

  // 10 ACROSS  EXPOSED  r15, c15-c21
  '15,16': 'X', '15,17': 'P', '15,18': 'O', '15,19': 'S', '15,20': 'E',
  '15,21': 'D',
};

const Map<String, int> _cw2Clues = {
  '0,5': 1,
  '2,3': 2,
  '3,15': 3,
  '4,4': 4,
  '7,0': 5,
  '7,6': 6,
  '7,11': 7,
  '10,12': 8,
  '11,13': 9,
  '15,15': 10,
};

const List<Map<String, dynamic>> _cw2Across = [
  {'num': 2, 'clue': 'Must be maintained with losses under 5%'},
  {
    'num': 4,
    'clue':
        'Measure of incidence difference between exposed and unexposed (2 words)'
  },
  {'num': 5, 'clue': 'Cohort type: study moves in the forward direction'},
  {
    'num': 7,
    'clue': 'Bias when another factor influences both exposure and disease'
  },
  {
    'num': 8,
    'clue': 'The time link between cause and effect in a cohort study'
  },
  {'num': 9, 'clue': 'The occurrence of new cases'},
  {'num': 10, 'clue': 'Group with the risk factor'},
];

const List<Map<String, dynamic>> _cw2Down = [
  {'num': 1, 'clue': 'Measure of association in cohort studies (2 words)'},
  {'num': 3, 'clue': 'Cohort type that uses historical data'},
  {'num': 6, 'clue': 'Group of people with similar characteristics'},
];

class _CrosswordGridMod2State extends State<CrosswordGridMod2> {
  late final Map<String, TextEditingController> _controllers;
  final Map<String, bool?> _status = {};
  int _hints = 0;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final k in _cw2Answers.keys) k: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  void _onChange(String key, String val) {
    setState(() {
      _status[key] = val.isEmpty ? null : val.toUpperCase() == _cw2Answers[key];
    });
    _checkWin();
  }

  void _checkWin() {
    if (_won) return;
    final all = _cw2Answers.keys
        .every((k) => _controllers[k]?.text.toUpperCase() == _cw2Answers[k]);
    if (all) {
      setState(() => _won = true);
      final score =
          ((_cw2Answers.length - _hints * 2).clamp(0, _cw2Answers.length) /
                  _cw2Answers.length *
                  100)
              .round();
      // ── PATCH: only save if new score beats current best ──────────────
      if (score > (widget.savedScore ?? 0)) {
        widget.onGameComplete?.call(score);
      }
    }
  }

  void _hint() {
    for (final k in _cw2Answers.keys) {
      if ((_controllers[k]?.text ?? '').isEmpty) {
        setState(() {
          _controllers[k]!.text = _cw2Answers[k]!;
          _status[k] = true;
          _hints++;
        });
        _checkWin();
        return;
      }
    }
  }

  int get _correct => _cw2Answers.keys
      .where((k) => _controllers[k]?.text.toUpperCase() == _cw2Answers[k])
      .length;

  int get _pct =>
      _cw2Answers.isEmpty ? 0 : ((_correct / _cw2Answers.length) * 100).round();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _cw2Bg,
        child: Column(children: [
          _buildHeader(),
          _buildScoreBar(),
          Expanded(child: _won ? _buildWinScreen() : _buildBody()),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      color: _cw2Blue,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Crossword Puzzle',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        GestureDetector(
          onTap: () => widget.onGoHome?.call(),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x80FFFFFF), width: 1)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.home_rounded, size: 14, color: Colors.white),
                SizedBox(width: 5),
                Text('Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ])),
        ),
      ]),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      color: _cw2BlueLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Filled: $_correct / ${_cw2Answers.length}',
            style: const TextStyle(
                color: _cw2Blue, fontWeight: FontWeight.w700, fontSize: 13)),
        Text('Hints used: $_hints',
            style: const TextStyle(color: _cw2TextMid, fontSize: 12)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
                color: _cw2Blue, borderRadius: BorderRadius.circular(20)),
            child: Text('$_pct%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12))),
      ]),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 600;
      if (isWide) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    _buildGrid(),
                    const SizedBox(height: 10),
                    _buildHintButton(),
                    const SizedBox(height: 10),
                    _buildGamesMenuButton()
                  ]))),
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12), child: _buildClues())),
        ]);
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          _buildGrid(),
          const SizedBox(height: 10),
          _buildHintButton(),
          const SizedBox(height: 14),
          _buildClues(),
          const SizedBox(height: 12),
          _buildGamesMenuButton(),
          const SizedBox(height: 20),
        ]),
      );
    });
  }

  Widget _buildGamesMenuButton() {
    return GestureDetector(
      onTap: () => widget.onBackToMenu?.call(),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cw2Blue, width: 1.5),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0F4A90D9),
                    blurRadius: 6,
                    offset: Offset(0, 2))
              ]),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.grid_view_rounded, size: 15, color: _cw2Blue),
            SizedBox(width: 8),
            Text('Games Menu',
                style: TextStyle(
                    color: _cw2Blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ])),
    );
  }

  Widget _buildHintButton() {
    return GestureDetector(
      onTap: _hint,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cw2Blue, width: 1.5),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0F4A90D9),
                    blurRadius: 6,
                    offset: Offset(0, 2))
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    color: _cw2BlueLight,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.lightbulb_rounded,
                    size: 16, color: _cw2Blue)),
            const SizedBox(width: 10),
            const Text('Use a Hint',
                style: TextStyle(
                    color: _cw2Blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            const SizedBox(width: 8),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: _cw2Blue, borderRadius: BorderRadius.circular(10)),
                child: Text('$_hints used',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600))),
          ])),
    );
  }

  Widget _buildGrid() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A4A90D9), blurRadius: 12, offset: Offset(0, 4))
          ]),
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(builder: (ctx, constraints) {
        final cellSize = (constraints.maxWidth - 16) / _CW2_COLS;
        return Column(
            children: List.generate(_CW2_ROWS, (row) {
          return Row(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(_CW2_COLS, (col) {
                final key = '$row,$col';
                if (!_cw2Answers.containsKey(key))
                  return SizedBox(width: cellSize, height: cellSize);
                final st = _status[key];
                final num = _cw2Clues[key];
                Color bg = _cw2Empty;
                if (st == true) bg = _cw2GreenBg;
                if (st == false) bg = _cw2RedBg;
                return Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                        color: bg,
                        border: Border.all(color: _cw2Border, width: 0.8)),
                    child: Stack(children: [
                      if (num != null)
                        Positioned(
                            top: 1,
                            left: 1,
                            child: Text('$num',
                                style: TextStyle(
                                    fontSize: cellSize * 0.22,
                                    fontWeight: FontWeight.w800,
                                    color: _cw2Blue))),
                      Center(
                          child: SizedBox(
                              width: cellSize,
                              height: cellSize,
                              child: Center(
                                  child: TextField(
                                      controller: _controllers[key],
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      maxLength: 1,
                                      style: TextStyle(
                                          fontSize: cellSize * 0.42,
                                          fontWeight: FontWeight.w800,
                                          color: _cw2TextDark,
                                          height: 1.0),
                                      decoration: InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(
                                              bottom: num != null
                                                  ? cellSize * 0.15
                                                  : 0)),
                                      onChanged: (v) => _onChange(key, v))))),
                    ]));
              }));
        }));
      }),
    );
  }

  Widget _buildClues() {
    return Column(children: [
      _buildClueSection('ACROSS', _cw2Across, Icons.arrow_forward_rounded),
      const SizedBox(height: 12),
      _buildClueSection('DOWN', _cw2Down, Icons.arrow_downward_rounded),
    ]);
  }

  Widget _buildClueSection(
      String title, List<Map<String, dynamic>> clues, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 18, color: _cw2Blue),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _cw2Blue,
                  letterSpacing: 1.2)),
        ]),
        const SizedBox(height: 12),
        ...clues.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      color: _cw2BlueLight,
                      borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text('${c['num']}',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _cw2Blue)))),
              const SizedBox(width: 10),
              Expanded(
                  child: Text('${c['clue']}',
                      style: const TextStyle(
                          fontSize: 13, color: _cw2TextMid, height: 1.4))),
            ]))),
      ]),
    );
  }

  Widget _buildWinScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        Image.network(
            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
            width: 100,
            height: 100,
            errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events_rounded,
                size: 80, color: _cw2Blue)),
        const SizedBox(height: 20),
        const Text('Puzzle Complete!',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: _cw2Blue)),
        const SizedBox(height: 8),
        const Text('Cohort Studies Crossword Complete!',
            style: TextStyle(fontSize: 14, color: _cw2TextMid)),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
                color: _cw2BlueLight, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Text('$_correct / ${_cw2Answers.length} cells correct',
                  style: const TextStyle(fontSize: 14, color: _cw2TextMid)),
              const SizedBox(height: 4),
              Text('$_pct%',
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: _cw2Blue)),
              Text('Hints used: $_hints',
                  style: const TextStyle(fontSize: 12, color: _cw2TextMid)),
            ])),
        const SizedBox(height: 28),
        GestureDetector(
            onTap: () => widget.onNextGame?.call(),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: _cw2Blue,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x4D4A90D9),
                          blurRadius: 16,
                          offset: Offset(0, 6))
                    ]),
                child: const Text('Next Game: Save the Goldfish',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)))),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () => setState(() {
                  _won = false;
                  _hints = 0;
                  _status.clear();
                  for (final c in _controllers.values) c.clear();
                }),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(28),
                    border:
                        Border.all(color: const Color(0xFFD8E4F0), width: 1.5)),
                child: const Text('Play Again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w700,
                        fontSize: 15)))),
      ]),
    );
  }
}

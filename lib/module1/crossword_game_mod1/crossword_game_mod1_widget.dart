// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ── Colours ────────────────────────────────────────────────────────────────
const Color _cwBlue = Color(0xFF4A90D9);
const Color _cwBlueLight = Color(0xFFE3F0FB);
const Color _cwBg = Color(0xFFF0F4FF);
const Color _cwGreenBg = Color(0xFFE8FAEA);
const Color _cwRedBg = Color(0xFFFFEAEA);
const Color _cwTextDark = Color(0xFF1E293B);
const Color _cwTextMid = Color(0xFF475569);
const Color _cwBorder = Color(0xFFBDD5EE);
const Color _cwEmpty = Color(0xFFEEF3FA);
const Color _cwGreen = Color(0xFF2A9940);
const Color _cwRed = Color(0xFFD94040);

// ── Grid dimensions ────────────────────────────────────────────────────────
// 19 rows × 19 cols
// All intersections verified by automated conflict checker:
//   (2,9)  = R  RARE ↔ RETROSPECTIVE
//   (6,9)  = O  CONFOUNDING ↔ RETROSPECTIVE
//   (6,12) = O  CONFOUNDING ↔ BERKSON
//   (10,4) = I  PAIRMATCHING ↔ SELECTION
//   (10,5) = R  PAIRMATCHING ↔ ODDSRATIO
//   (10,9) = C  PAIRMATCHING ↔ RETROSPECTIVE
//   (14,9) = E  RECALLBIAS ↔ RETROSPECTIVE
//   (14,16)= A  RECALLBIAS ↔ POPULATION
const int _CW_ROWS = 19;
const int _CW_COLS = 19;

// ── Answer map ─────────────────────────────────────────────────────────────
const Map<String, String> _cwAnswers = {
  // 1 Down: BERKSON (col=12, rows=1–7)
  // Ends row 7. Nearest across word at that col is PAIRMATCHING at row 10 → 2-row gap.
  '1,12': 'B', '2,12': 'E', '3,12': 'R', '4,12': 'K', '5,12': 'S',
  // '6,12': 'O' → shared with CONFOUNDING (owned below)
  '7,12': 'N',

  // 2 Across: RARE (row=2, cols=7–10)
  '2,7': 'R', '2,8': 'A',
  // '2,9': 'R' → shared with RETROSPECTIVE (owned below)
  '2,10': 'E',

  // 3 Down: RETROSPECTIVE (col=9, rows=2–14)
  // Shared at row=2 (RARE), row=6 (CONFOUNDING), row=10 (PAIRMATCHING), row=14 (RECALLBIAS)
  '2,9': 'R', '3,9': 'E', '4,9': 'T', '5,9': 'R',
  // '6,9': 'O' → owned by CONFOUNDING
  '7,9': 'S', '8,9': 'P', '9,9': 'E',
  // '10,9': 'C' → owned by PAIRMATCHING
  '11,9': 'T', '12,9': 'I', '13,9': 'V',
  // '14,9': 'E' → owned by RECALLBIAS

  // 4 Down: SELECTION (col=4, rows=4–12)
  // row=10 shared with PAIRMATCHING. Ends row=12.
  // RECALLBIAS (row=14) starts col=8 → never reaches col=4. ✓
  '4,4': 'S', '5,4': 'E', '6,4': 'L', '7,4': 'E', '8,4': 'C', '9,4': 'T',
  // '10,4': 'I' → owned by PAIRMATCHING
  '11,4': 'O', '12,4': 'N',

  // 5 Down: ODDSRATIO (col=5, rows=6–14)
  // row=10 shared with PAIRMATCHING. Ends row=14.
  // RECALLBIAS (row=14) starts col=8 → never reaches col=5. ✓
  '6,5': 'O', '7,5': 'D', '8,5': 'D', '9,5': 'S',
  // '10,5': 'R' → owned by PAIRMATCHING
  '11,5': 'A', '12,5': 'T', '13,5': 'I', '14,5': 'O',

  // 6 Across: CONFOUNDING (row=6, cols=8–18)
  // col=9 shared with RETROSPECTIVE, col=12 shared with BERKSON
  '6,8': 'C',
  '6,9': 'O',  // shared with RETROSPECTIVE
  '6,10': 'N', '6,11': 'F',
  '6,12': 'O', // shared with BERKSON
  '6,13': 'U', '6,14': 'N', '6,15': 'D', '6,16': 'I', '6,17': 'N', '6,18': 'G',

  // 7 Down: POPULATION (col=16, rows=9–18)
  // row=14 shared with RECALLBIAS. CONFOUNDING (row=6) ends before row=9 → 2-row gap. ✓
  '9,16': 'P', '10,16': 'O', '11,16': 'P', '12,16': 'U', '13,16': 'L',
  // '14,16': 'A' → owned by RECALLBIAS
  '15,16': 'T', '16,16': 'I', '17,16': 'O', '18,16': 'N',

  // 8 Across: PAIRMATCHING (row=10, cols=2–13)
  // col=4 shared with SELECTION, col=5 shared with ODDSRATIO,
  // col=9 shared with RETROSPECTIVE
  '10,2': 'P', '10,3': 'A',
  '10,4': 'I', // shared with SELECTION
  '10,5': 'R', // shared with ODDSRATIO
  '10,6': 'M', '10,7': 'A', '10,8': 'T',
  '10,9': 'C', // shared with RETROSPECTIVE
  '10,10': 'H', '10,11': 'I', '10,12': 'N', '10,13': 'G',

  // 9 Across: RECALLBIAS (row=14, cols=8–17)
  // col=9 shared with RETROSPECTIVE, col=16 shared with POPULATION
  '14,8': 'R',
  '14,9': 'E',  // shared with RETROSPECTIVE
  '14,10': 'C', '14,11': 'A', '14,12': 'L', '14,13': 'L', '14,14': 'B', '14,15': 'I',
  '14,16': 'A', // shared with POPULATION
  '14,17': 'S',
};

// ── Clue numbers: left→right, top→bottom ──────────────────────────────────
const Map<String, int> _cwClues = {
  '1,12': 1,  // BERKSON      Down
  '2,7':  2,  // RARE         Across
  '2,9':  3,  // RETROSPECTIVE Down
  '4,4':  4,  // SELECTION    Down
  '6,5':  5,  // ODDSRATIO    Down
  '6,8':  6,  // CONFOUNDING  Across
  '9,16': 7,  // POPULATION   Down
  '10,2': 8,  // PAIRMATCHING Across
  '14,8': 9,  // RECALLBIAS   Across
};

const List<Map<String, dynamic>> _cwAcross = [
  {'num': 2, 'clue': 'Case-control studies are ideal for these (4)'},
  {'num': 6, 'clue': 'A third variable linked to both exposure and disease (11)'},
  {'num': 8, 'clue': 'Type of matching: one case paired with one control (12)'},
  {'num': 9, 'clue': 'Cases remember past exposures better than controls (10)'},
];

const List<Map<String, dynamic>> _cwDown = [
  {'num': 1, 'clue': 'Bias named after a statistician, due to hospital admission (7)'},
  {'num': 3, 'clue': 'Case-control studies look ___ in time (13)'},
  {'num': 4, 'clue': 'Bias from improper sampling of cases or controls (9)'},
  {'num': 5, 'clue': 'Measure of association used in case-control studies (9)'},
  {'num': 7, 'clue': 'Where both cases and controls are often recruited (10)'},
];

// ══════════════════════════════════════════════════════════════════════════════
class CrosswordGameMod1 extends StatefulWidget {
  const CrosswordGameMod1({
    Key? key,
    this.width,
    this.height,
    this.onGameComplete,
    this.onNextGame,
    this.onGoHome,
    this.onBackToMenu,
    this.savedScore,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function(int scorePercent)? onGameComplete;
  final Future<dynamic> Function()? onNextGame;
  final Future<dynamic> Function()? onGoHome;
  final Future<dynamic> Function()? onBackToMenu;
  final int? savedScore; // retain highest score — only update if new score beats this

  @override
  State<CrosswordGameMod1> createState() => _CrosswordGameMod1State();
}

class _CrosswordGameMod1State extends State<CrosswordGameMod1> {
  late final Map<String, TextEditingController> _controllers;
  final Map<String, bool?> _status = {};
  int _hints = 0;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final k in _cwAnswers.keys) k: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  void _onChange(String key, String val) {
    setState(() {
      _status[key] = val.isEmpty ? null : val.toUpperCase() == _cwAnswers[key];
    });
    _checkWin();
  }

  void _checkWin() {
    if (_won) return;
    final all = _cwAnswers.keys
        .every((k) => _controllers[k]?.text.toUpperCase() == _cwAnswers[k]);
    if (all) {
      setState(() => _won = true);
      final score =
          ((_cwAnswers.length - _hints * 2).clamp(0, _cwAnswers.length) /
                  _cwAnswers.length *
                  100)
              .round();
      // Only update if new score beats the saved best
      if (score > (widget.savedScore ?? 0)) {
        widget.onGameComplete?.call(score);
      }
    }
  }

  void _hint() {
    for (final k in _cwAnswers.keys) {
      if ((_controllers[k]?.text ?? '').isEmpty) {
        setState(() {
          _controllers[k]!.text = _cwAnswers[k]!;
          _status[k] = true;
          _hints++;
        });
        _checkWin();
        return;
      }
    }
  }

  int get _correct => _cwAnswers.keys
      .where((k) => _controllers[k]?.text.toUpperCase() == _cwAnswers[k])
      .length;

  int get _pct =>
      _cwAnswers.isEmpty ? 0 : ((_correct / _cwAnswers.length) * 100).round();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _cwBg,
        child: Column(children: [
          _buildHeader(),
          _buildScoreBar(),
          Expanded(child: _won ? _buildWinScreen() : _buildBody()),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      color: _cwBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Crossword Puzzle',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
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
        ],
      ),
    );
  }

  // ── Score bar ──────────────────────────────────────────────────────────
  Widget _buildScoreBar() {
    return Container(
      color: _cwBlueLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filled: $_correct / ${_cwAnswers.length}',
              style: const TextStyle(
                  color: _cwBlue, fontWeight: FontWeight.w700, fontSize: 13)),
          Text('Hints: $_hints',
              style: const TextStyle(color: _cwTextMid, fontSize: 12)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
                color: _cwBlue, borderRadius: BorderRadius.circular(20)),
            child: Text('$_pct%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────
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
                    _buildGamesMenuButton(),
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

  // ── Games Menu button ──────────────────────────────────────────────────
  Widget _buildGamesMenuButton() {
    return GestureDetector(
      onTap: () => widget.onBackToMenu?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cwBlue, width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F4A90D9), blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_rounded, size: 15, color: _cwBlue),
            SizedBox(width: 8),
            Text('Games Menu',
                style: TextStyle(
                    color: _cwBlue, fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ── Hint button ────────────────────────────────────────────────────────
  Widget _buildHintButton() {
    return GestureDetector(
      onTap: _hint,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cwBlue, width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F4A90D9), blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                  color: _cwBlueLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.lightbulb_rounded, size: 16, color: _cwBlue),
            ),
            const SizedBox(width: 10),
            const Text('Use a Hint',
                style: TextStyle(
                    color: _cwBlue, fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: _cwBlue, borderRadius: BorderRadius.circular(10)),
              child: Text('$_hints used',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────
  Widget _buildGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A4A90D9), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(builder: (ctx, constraints) {
        final cellSize = (constraints.maxWidth - 16) / _CW_COLS;
        return Column(
          children: List.generate(_CW_ROWS, (row) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(_CW_COLS, (col) {
                final key = '$row,$col';
                if (!_cwAnswers.containsKey(key)) {
                  // Empty cell — dark background
                  return Container(
                    width: cellSize, height: cellSize,
                    color: const Color(0xFFCDD8E8),
                  );
                }
                final st = _status[key];
                final num = _cwClues[key];
                Color bg = _cwEmpty;
                if (st == true) bg = _cwGreenBg;
                if (st == false) bg = _cwRedBg;
                return Container(
                  width: cellSize, height: cellSize,
                  decoration: BoxDecoration(
                      color: bg,
                      border: Border.all(color: _cwBorder, width: 0.8)),
                  child: Stack(children: [
                    if (num != null)
                      Positioned(
                          top: 1, left: 1,
                          child: Text('$num',
                              style: TextStyle(
                                  fontSize: cellSize * 0.22,
                                  fontWeight: FontWeight.w800,
                                  color: _cwBlue))),
                    Center(
                      child: SizedBox(
                        width: cellSize, height: cellSize,
                        child: Center(
                          child: TextField(
                            controller: _controllers[key],
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 1,
                            style: TextStyle(
                                fontSize: cellSize * 0.42,
                                fontWeight: FontWeight.w800,
                                color: _cwTextDark,
                                height: 1.0),
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  bottom: num != null ? cellSize * 0.15 : 0),
                            ),
                            onChanged: (v) => _onChange(key, v),
                          ),
                        ),
                      ),
                    ),
                  ]),
                );
              }),
            );
          }),
        );
      }),
    );
  }

  // ── Clues ──────────────────────────────────────────────────────────────
  Widget _buildClues() {
    return Column(children: [
      _buildClueSection('ACROSS', _cwAcross, Icons.arrow_forward_rounded),
      const SizedBox(height: 12),
      _buildClueSection('DOWN', _cwDown, Icons.arrow_downward_rounded),
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
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 18, color: _cwBlue),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _cwBlue,
                  letterSpacing: 1.2)),
        ]),
        const SizedBox(height: 12),
        ...clues.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                    color: _cwBlueLight,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                    child: Text('${c['num']}',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _cwBlue))),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text('${c['clue']}',
                      style: const TextStyle(
                          fontSize: 13, color: _cwTextMid, height: 1.4))),
            ]),
          );
        }),
      ]),
    );
  }

  // ── Win screen ─────────────────────────────────────────────────────────
  Widget _buildWinScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        Image.network(
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
          width: 100, height: 100,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.emoji_events_rounded, size: 80, color: _cwBlue),
        ),
        const SizedBox(height: 20),
        const Text('Puzzle Complete!',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: _cwBlue)),
        const SizedBox(height: 8),
        const Text('Crossword Puzzle Complete!',
            style: TextStyle(fontSize: 14, color: _cwTextMid)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              color: _cwBlueLight, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            Text('$_correct / ${_cwAnswers.length} cells correct',
                style: const TextStyle(fontSize: 14, color: _cwTextMid)),
            const SizedBox(height: 4),
            Text('$_pct%',
                style: const TextStyle(
                    fontSize: 48, fontWeight: FontWeight.w900, color: _cwBlue)),
            Text('Hints used: $_hints',
                style: const TextStyle(fontSize: 12, color: _cwTextMid)),
          ]),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => widget.onNextGame?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: _cwBlue,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x4D4A90D9),
                      blurRadius: 16,
                      offset: Offset(0, 6))
                ]),
            child: const Text('Next Game: Word Finder',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onBackToMenu?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _cwBlue, width: 1.5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.grid_view_rounded, size: 15, color: _cwBlue),
                SizedBox(width: 7),
                Text('Games Menu',
                    style: TextStyle(
                        color: _cwBlue, fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
          ),
        ),
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
                border: Border.all(color: const Color(0xFFD8E4F0), width: 1.5)),
            child: const Text('Play Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ),
      ]),
    ),
    );
  }
}

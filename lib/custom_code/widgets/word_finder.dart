// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class WordFinder extends StatefulWidget {
  const WordFinder({
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
  final int? savedScore;

  @override
  State<WordFinder> createState() => _WordFinderState();
}

const Color _wBlue = Color(0xFF4A90D9);
const Color _wBlueLight = Color(0xFFE3F0FB);
const Color _wBg = Color(0xFFF0F4FF);
const Color _wGreen = Color(0xFF2A9940);
const Color _wGreenLight = Color(0xFFE8FAEA);
const Color _wTextDark = Color(0xFF1E293B);
const Color _wTextMid = Color(0xFF475569);

const int _WF_GRID = 15;

class _WFPlacement {
  final String word;
  final int row, col;
  final bool horiz;
  const _WFPlacement(this.word, this.row, this.col, this.horiz);
}

const List<_WFPlacement> _wfPlacements = [
  _WFPlacement('RETROSPECTIVE', 0, 1, true),
  _WFPlacement('CONFOUNDER', 2, 2, true),
  _WFPlacement('ODDSRATIO', 4, 4, true),
  _WFPlacement('INTERVIEW', 6, 2, true),
  _WFPlacement('EXPOSURE', 8, 1, true),
  _WFPlacement('MATCHING', 10, 3, true),
  _WFPlacement('CONTROL', 14, 1, true),
  _WFPlacement('CASE', 0, 0, false),
  _WFPlacement('RARE', 4, 0, false),
];

const List<String> _wfWords = [
  'CASE',
  'CONTROL',
  'EXPOSURE',
  'MATCHING',
  'INTERVIEW',
  'RETROSPECTIVE',
  'CONFOUNDER',
  'RARE',
  'ODDSRATIO',
];

const List<String> _wfFacts = [
  'Individuals with disease',
  'Individuals without disease',
  'A risk factor compared between cases and controls',
  'Selecting controls similar to cases reduces confounding bias',
  'A common data collection method in case-control studies',
  'Looks back in time to assess past exposures',
  'An outside factor that distorts the true association',
  'Case-control studies are ideal for studying rare diseases',
  'The key measure of association in a case-control study',
];

class _WordFinderState extends State<WordFinder> {
  late final List<List<String>> _grid;
  late final Map<String, String> _cellWord;

  Set<String> _foundWords = {};
  Set<String> _foundCells = {};
  Set<String> _highlighted = {};
  String? _dragStart;
  List<String> _dragCells = [];
  bool _gameWon = false;

  @override
  void initState() {
    super.initState();
    _buildGrid();
  }

  void _buildGrid() {
    _grid = List.generate(_WF_GRID, (_) => List.generate(_WF_GRID, (_) => ''));
    _cellWord = {};

    for (final p in _wfPlacements) {
      for (int i = 0; i < p.word.length; i++) {
        final r = p.horiz ? p.row : p.row + i;
        final c = p.horiz ? p.col + i : p.col;
        _grid[r][c] = p.word[i];
        _cellWord['$r,$c'] = p.word;
      }
    }

    const fillers = 'XZQJVKYWNPHGFUDTLMBSRIEOAC';
    int idx = 0;

    for (int r = 0; r < _WF_GRID; r++) {
      for (int c = 0; c < _WF_GRID; c++) {
        if (_grid[r][c] == '') {
          _grid[r][c] = fillers[idx % fillers.length];
          idx++;
        }
      }
    }
  }

  List<String> _cellsBetween(String start, String end) {
    final s = start.split(',');
    final e = end.split(',');

    int r1 = int.parse(s[0]);
    int c1 = int.parse(s[1]);
    int r2 = int.parse(e[0]);
    int c2 = int.parse(e[1]);

    final dr = (r2 - r1).abs();
    final dc = (c2 - c1).abs();

    if (dr == 0 && dc == 0) return [start];

    int dirR;
    int dirC;

    if (dr >= dc) {
      dirR = r2 > r1 ? 1 : -1;
      dirC = 0;
      r2 = r1 + dirR * dr;
    } else {
      dirR = 0;
      dirC = c2 > c1 ? 1 : -1;
      c2 = c1 + dirC * dc;
    }

    final cells = <String>[];
    int r = r1;
    int c = c1;

    while (true) {
      if (r < 0 || r >= _WF_GRID || c < 0 || c >= _WF_GRID) break;
      cells.add('$r,$c');
      if (r == r2 && c == c2) break;
      r += dirR;
      c += dirC;
    }

    return cells;
  }

  void _checkWord() {
    if (_dragCells.isEmpty) return;

    final selected = _dragCells.map((cell) {
      final p = cell.split(',');
      return _grid[int.parse(p[0])][int.parse(p[1])];
    }).join();

    final reversed = selected.split('').reversed.join();

    for (final word in _wfWords) {
      if (!_foundWords.contains(word) &&
          (selected == word || reversed == word)) {
        setState(() {
          _foundWords.add(word);
          _foundCells.addAll(_dragCells);
        });

        _showFact(word);

        if (_foundWords.length == _wfWords.length) {
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;

            setState(() => _gameWon = true);

            if (100 > (widget.savedScore ?? 0)) {
              widget.onGameComplete?.call(100);
            }
          });
        }

        return;
      }
    }
  }

  void _showFact(String word) {
    final idx = _wfWords.indexOf(word);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: _wGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: _wGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Found: $word!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _wGreen,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _wBlueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  idx < _wfFacts.length ? _wfFacts[idx] : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _wTextDark,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _wBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Got it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _cellFromOffset(Offset offset, double cellSize) {
    final col = (offset.dx / cellSize).floor();
    final row = (offset.dy / cellSize).floor();

    if (row >= 0 && row < _WF_GRID && col >= 0 && col < _WF_GRID) {
      return '$row,$col';
    }

    return null;
  }

  int get _scorePercent => _wfWords.isEmpty
      ? 0
      : ((_foundWords.length / _wfWords.length) * 100).round();

  Widget _gamesMenuBtn() {
    return GestureDetector(
      onTap: () => widget.onBackToMenu?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _wBlue, width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_rounded, size: 15, color: _wBlue),
            SizedBox(width: 7),
            Text(
              'Games Menu',
              style: TextStyle(
                color: _wBlue,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _wBg,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              color: _wBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Word Finder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onGoHome?.call(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: _wBlueLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found: ${_foundWords.length} / ${_wfWords.length}',
                    style: const TextStyle(
                      color: _wBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _wBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_scorePercent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              color: const Color(0xFFD8E4F0),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    _wfWords.isEmpty ? 0 : _foundWords.length / _wfWords.length,
                child: Container(color: _wBlue),
              ),
            ),
            Expanded(child: _gameWon ? _winScreen() : _gameBody()),
          ],
        ),
      ),
    );
  }

  Widget _gameBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / _WF_GRID;
        final gridHeight = cellSize * _WF_GRID;

        return Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: gridHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (d) {
                  final cell = _cellFromOffset(d.localPosition, cellSize);
                  if (cell != null) {
                    setState(() {
                      _dragStart = cell;
                      _dragCells = [cell];
                      _highlighted = {cell};
                    });
                  }
                },
                onPanUpdate: (d) {
                  final cell = _cellFromOffset(d.localPosition, cellSize);
                  if (cell != null && _dragStart != null) {
                    final cells = _cellsBetween(_dragStart!, cell);
                    setState(() {
                      _dragCells = cells;
                      _highlighted = cells.toSet();
                    });
                  }
                },
                onPanEnd: (_) {
                  _checkWord();
                  setState(() {
                    _highlighted = {};
                    _dragCells = [];
                    _dragStart = null;
                  });
                },
                child: _buildGridWidget(cellSize),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A4A90D9),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _wfWords.map((word) {
                          final found = _foundWords.contains(word);

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: found ? _wGreenLight : _wBlueLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: found ? _wGreen : _wBlue,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              word,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: found ? _wGreen : _wBlue,
                                decoration:
                                    found ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _gamesMenuBtn(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridWidget(double cellSize) {
    return Column(
      children: List.generate(
        _WF_GRID,
        (r) => Row(
          children: List.generate(_WF_GRID, (c) {
            final key = '$r,$c';
            final isHighlighted = _highlighted.contains(key);
            final isFound = _foundCells.contains(key);

            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: isFound
                    ? _wGreenLight
                    : isHighlighted
                        ? _wBlueLight
                        : Colors.white,
                border: Border.all(
                  color: const Color(0xFFE8EEF5),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  _grid[r][c],
                  style: TextStyle(
                    fontSize: cellSize * 0.44,
                    fontWeight: FontWeight.w700,
                    color: isFound
                        ? _wGreen
                        : isHighlighted
                            ? _wBlue
                            : const Color(0xFF334155),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _winScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.network(
            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
            width: 100,
            height: 100,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.emoji_events_rounded,
              size: 80,
              color: _wBlue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'All Words Found!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: _wBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Word Finder Complete!',
            style: TextStyle(fontSize: 14, color: _wTextMid),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: _wBlueLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '${_foundWords.length} / ${_wfWords.length} words found',
                  style: const TextStyle(fontSize: 14, color: _wTextMid),
                ),
                const SizedBox(height: 4),
                const Text(
                  '100%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: _wBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => widget.onNextGame?.call(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: _wBlue,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D4A90D9),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Next Game: Drag & Drop',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() {
              _gameWon = false;
              _foundWords.clear();
              _foundCells.clear();
              _highlighted.clear();
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFD8E4F0),
                  width: 1.5,
                ),
              ),
              child: const Text(
                'Play Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

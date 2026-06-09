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

const Color _spBlue = Color(0xFF4A90D9);
const Color _spBlueDark = Color(0xFF1565C0);
const Color _spBlueLight = Color(0xFFE3F0FB);
const Color _spBg = Color(0xFFF0F4FF);
const Color _spGreen = Color(0xFF2A9940);
const Color _spGreenLight = Color(0xFFE8FAEA);
const Color _spRed = Color(0xFFD94040);
const Color _spRedLight = Color(0xFFFFEAEA);
const Color _spBorder = Color(0xFFBDD5EE);
const Color _spTextDark = Color(0xFF1E293B);
const Color _spTextMid = Color(0xFF475569);
const Color _spAmber = Color(0xFFF59E0B);
const Color _spAmberLight = Color(0xFFFEF3C7);

// ── Shuffled question model ────────────────────────────────────────────────
class _SQM2 {
  final String q;
  final List<String> opts;
  final int ans;
  final String clue;
  _SQM2(this.q, this.opts, this.ans, this.clue);
}

class SaveThePrincess extends StatefulWidget {
  const SaveThePrincess({
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
  final int? savedScore; // current best score — only update if new score beats this

  @override
  State<SaveThePrincess> createState() => _SaveThePrincessState();
}

class _SaveThePrincessState extends State<SaveThePrincess>
    with TickerProviderStateMixin {
  int _screen = 0;
  int currentGate = 0;
  int currentQuestion = 0;
  bool gameWon = false;

  // ── Per-question state ─────────────────────────────────────────────────
  bool _hintShown = false;
  bool _showHint = false;
  String _hintText = '';
  int? _wrongChosen;
  int? _correctChosen;
  bool _isProcessing = false;

  // ── Per-gate tracking ──────────────────────────────────────────────────
  int _gateCorrectCount = 0;
  bool _showGateFail = false;
  bool _showGateUnlock = false;
  int _unlockedGateNum = 0;

  // ── GLOBAL mistake budget: max 3 total mistakes across entire game ──────
  static const int _maxMistakes = 3;
  static const int _maxHints = 5;
  int _totalMistakes = 0;
  int _hintsRemaining = 5;         // global hint budget
  bool _showMistakeGameOver = false;

  // ── Score: first-attempt correct only ─────────────────────────────────
  int _totalCorrect = 0;          // all correct answers (hint-assisted included)

  late List<List<_SQM2>> _gates;

  late AnimationController _princessBounce;
  late AnimationController _shakeCtrl;
  late AnimationController _castleCtrl;
  late AnimationController _unlockCtrl;
  late Animation<double> _princessBounceAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _castleAnim;
  late Animation<double> _unlockAnim;

  // ── Raw gate data (Cohort Studies) ────────────────────────────────────
  final List<Map<String, dynamic>> _rawGates = [
    {
      "title": "Gate 1", "topic": "Basics of Cohort Studies",
      "hint": "Answer at least 2 of 3 questions correctly to open Gate 1!",
      "questions": [
        { "q": "The guards ask: Cohort studies begin with…",
          "options": ["Disease", "Exposure status", "Outcome", "Matching"],
          "answer": 1,
          "clue": "Remember: COHORT = Cause → Outcome. You start with people who have or don't have the EXPOSURE, then follow them forward." },
        { "q": "Gate challenge: Disease status at baseline should be:",
          "options": ["Present", "Unknown", "Absent", "Not assessed"],
          "answer": 2,
          "clue": "If participants already have the disease at the start, you cannot watch it DEVELOP over time — so they must be disease-free at baseline." },
        { "q": "Gate riddle: Cohort studies move…",
          "options": ["Backward always", "Forward in time to observe outcomes", "Sideways", "Only through historical data"],
          "answer": 1,
          "clue": "Cohort studies start with exposure and then WAIT to see who develops the disease. Which direction does that represent in time?" },
      ]
    },
    {
      "title": "Gate 2", "topic": "Types of Cohorts",
      "hint": "Answer at least 2 of 3 questions correctly to unlock Gate 2!",
      "questions": [
        { "q": "The guard asks: In a prospective cohort study…",
          "options": ["Exposure and outcome already occurred", "Exposure is measured now, outcome happens later", "Only secondary data used", "It's faster than retrospective"],
          "answer": 1,
          "clue": "'Prospective' = looking ahead. The study starts NOW and follows participants into the FUTURE to see who gets the disease." },
        { "q": "Gate challenge: Retrospective cohort studies use:",
          "options": ["Only interviews", "Future records", "Historical data where exposure and outcome already occurred", "Randomized data"],
          "answer": 2,
          "clue": "'Retrospective' = looking back. Both exposure and outcome have already happened — the researcher uses PAST records to trace the cohort forward." },
        { "q": "Gate riddle: Ambispective cohorts include:",
          "options": ["Only past data", "Retrospective + prospective components", "Prospective only", "Ecological data"],
          "answer": 1,
          "clue": "'Ambi' means BOTH (like ambidextrous = both hands). An ambispective cohort combines looking backward AND looking forward." },
      ]
    },
    {
      "title": "Gate 3", "topic": "Steps in Cohort Studies",
      "hint": "Answer at least 2 of 3 questions correctly to unlock Gate 3!",
      "questions": [
        { "q": "The guard demands: First step in a cohort study:",
          "options": ["Calculate RR", "Select disease patients", "Select disease-free subjects", "Loss-to-follow-up"],
          "answer": 2,
          "clue": "The whole point is to WATCH who gets the disease over time. Participants must be free of the disease at the START — otherwise you can't observe it developing." },
        { "q": "Gate challenge: Loss to follow-up should ideally be:",
          "options": [">20% lost", "<5% lost", "Not monitored", "None of the above"],
          "answer": 1,
          "clue": "If too many people drop out, your results become unreliable. You need to KEEP loss very small. Which threshold ensures the study remains valid?" },
        { "q": "Gate riddle: Comparison groups in cohort include:",
          "options": ["Case groups", "Matched controls", "Internal or external cohorts", "Neighborhood samples only"],
          "answer": 2,
          "clue": "In a cohort study you compare EXPOSED vs UNEXPOSED — not cases vs controls. The unexposed group can be from the same study (internal) or a separate group (external)." },
      ]
    },
    {
      "title": "Gate 4", "topic": "Measures of Risk",
      "hint": "Answer at least 2 of 3 questions correctly to unlock Gate 4!",
      "questions": [
        { "q": "The guard asks: Relative Risk (RR) is calculated using:",
          "options": ["Odds", "Prevalence", "Incidence", "Cross-sectional rates"],
          "answer": 2,
          "clue": "RR compares the RATE of NEW disease in exposed vs unexposed groups. Which measure specifically captures the rate of new cases appearing over time?" },
        { "q": "Gate challenge: RR less than 1 (RR < 1) indicates:",
          "options": ["No association", "A protective factor", "True risk factor", "Bias"],
          "answer": 1,
          "clue": "RR = 1 means no difference. RR > 1 means MORE disease in exposed. So RR < 1 means LESS disease in the exposed group — what does that make the exposure?" },
        { "q": "Gate riddle: Attributable Risk (AR) =",
          "options": ["Incidence ratio", "Incidence among exposed minus Incidence among unexposed", "Prevalence difference", "Causal score"],
          "answer": 1,
          "clue": "AR measures the EXTRA risk due to the exposure. You isolate the exposure's contribution by subtracting the unexposed rate from the exposed rate." },
      ]
    },
    {
      "title": "Gate 5", "topic": "Bias & Advantages",
      "hint": "Answer at least 2 of 3 questions correctly to free the princess!",
      "questions": [
        { "q": "Last guard: Loss to follow-up mainly leads to:",
          "options": ["Information bias", "Selection bias", "Confounding", "Post-hoc bias"],
          "answer": 1,
          "clue": "When people drop out unevenly (e.g. sicker people leave more), the remaining group is NO LONGER REPRESENTATIVE of the original cohort. Which bias is about WHO ends up in your study?" },
        { "q": "Final challenge: Which is an advantage of cohort studies?",
          "options": ["Cannot calculate incidence", "Clear temporality", "Very small sample required", "Best for rare diseases"],
          "answer": 1,
          "clue": "Because cohort studies start with exposure and follow people forward, they can prove WHICH CAME FIRST — the exposure or the disease. What is this temporal principle called?" },
        { "q": "Final riddle: Which measure can cohort studies directly calculate?",
          "options": ["Odds Ratio", "Relative Risk", "Prevalence Ratio", "None"],
          "answer": 1,
          "clue": "Since cohort studies measure incidence in both exposed and unexposed groups, you can directly calculate the measure by dividing incidence in exposed by incidence in unexposed." },
      ]
    },
  ];

  List<List<_SQM2>> _buildShuffledGates() {
    final rng = Random();
    return _rawGates.map((gate) {
      final qs = gate["questions"] as List;
      return qs.map((q) {
        final opts = List<String>.from(q["options"] as List);
        final correctText = opts[q["answer"] as int];
        for (int i = opts.length - 1; i > 0; i--) {
          final j = rng.nextInt(i + 1);
          final tmp = opts[i]; opts[i] = opts[j]; opts[j] = tmp;
        }
        return _SQM2(q["q"], opts, opts.indexOf(correctText), q["clue"]);
      }).toList();
    }).toList();
  }

  List<_SQM2> _reshuffleGate(int idx) {
    final rng = Random();
    final gate = _rawGates[idx];
    return (gate["questions"] as List).map((q) {
      final opts = List<String>.from(q["options"] as List);
      final correctText = opts[q["answer"] as int];
      for (int i = opts.length - 1; i > 0; i--) {
        final j = rng.nextInt(i + 1);
        final tmp = opts[i]; opts[i] = opts[j]; opts[j] = tmp;
      }
      return _SQM2(q["q"], opts, opts.indexOf(correctText), q["clue"]);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _gates = _buildShuffledGates();
    _princessBounce = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat(reverse: true);
    _princessBounceAnim = Tween<double>(begin: -6, end: 6).animate(
        CurvedAnimation(parent: _princessBounce, curve: Curves.easeInOut));
    _shakeCtrl = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _shakeAnim = Tween<double>(begin: -8, end: 8).animate(
        CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticInOut));
    _castleCtrl = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _castleAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _castleCtrl, curve: Curves.elasticOut));
    _castleCtrl.forward();
    _unlockCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _unlockAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _unlockCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _princessBounce.dispose();
    _shakeCtrl.dispose();
    _castleCtrl.dispose();
    _unlockCtrl.dispose();
    super.dispose();
  }

  int get _pct => ((currentGate * 3 + currentQuestion) / 15 * 100).round();
  int get _scorePercent => ((_totalCorrect / 15) * 100).round();
  int get _mistakesLeft => _maxMistakes - _totalMistakes;
  _SQM2 get _currentQ => _gates[currentGate][currentQuestion];

  // ── Answer handling ────────────────────────────────────────────────────
  void _handleAnswer(int idx) {
    if (_isProcessing) return;

    if (idx == _currentQ.ans) {
      // ── CORRECT ──────────────────────────────────────────────────────
      // All correct answers score — whether hint was used or not
      // No heart lost even if a hint was used to get here
      _gateCorrectCount++;
      _totalCorrect++;
      setState(() {
        _isProcessing = true;
        _correctChosen = idx;
        _wrongChosen = null;
        _showHint = false;
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _advanceQuestion();
      });

    } else {
      // ── WRONG ────────────────────────────────────────────────────────
      if (!_hintShown) {
        // First wrong on this question
        if (_hintsRemaining > 0) {
          // Hints available → show hint, allow retry (NO heart lost yet)
          _hintsRemaining--;
          setState(() {
            _isProcessing = true;
            _wrongChosen = idx;
            _showHint = true;
            _hintShown = true;
            _hintText = _currentQ.clue;
          });
          _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
          Future.delayed(const Duration(milliseconds: 3000), () {
            if (!mounted) return;
            setState(() {
              _showHint = false;
              _wrongChosen = null;
              _isProcessing = false;
            });
          });
        } else {
          // No hints left → heart lost, auto-advance, 0 points
          _totalMistakes++;
          if (_totalMistakes >= _maxMistakes) {
            setState(() {
              _isProcessing = true;
              _wrongChosen = idx;
              _showMistakeGameOver = true;
            });
          } else {
            setState(() {
              _isProcessing = true;
              _wrongChosen = idx;
            });
            _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (!mounted) return;
              _advanceQuestion();
            });
          }
          _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
        }
      } else {
        // Second wrong (after hint) → heart lost, auto-advance, 0 points
        _totalMistakes++;
        if (_totalMistakes >= _maxMistakes) {
          setState(() {
            _isProcessing = true;
            _wrongChosen = idx;
            _showMistakeGameOver = true;
          });
        } else {
          setState(() {
            _isProcessing = true;
            _wrongChosen = idx;
          });
          _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (!mounted) return;
            _advanceQuestion();
          });
        }
        _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
      }
    }
  }

  void _advanceQuestion() {
    setState(() {
      _showHint = false;
      _wrongChosen = null;
      _correctChosen = null;
      _hintShown = false;
      _isProcessing = false;
    });

    if (currentQuestion < 2) {
      setState(() => currentQuestion++);
    } else {
      if (_gateCorrectCount >= 2) {
        if (currentGate < 4) {
          final justUnlocked = currentGate + 1;
          setState(() {
            _showGateUnlock = true;
            _unlockedGateNum = justUnlocked;
            _gateCorrectCount = 0;
          });
          _unlockCtrl.forward(from: 0);
          Future.delayed(const Duration(milliseconds: 2800), () {
            if (!mounted) return;
            setState(() {
              _showGateUnlock = false;
              currentGate++;
              currentQuestion = 0;
            });
            _castleCtrl.forward(from: 0);
          });
        } else {
          setState(() {
            gameWon = true;
            _gateCorrectCount = 0;
          });
          // Only save if new score beats the current best
          if (_scorePercent > (widget.savedScore ?? 0)) {
            widget.onGameComplete();
          }
        }
      } else {
        setState(() {
          _showGateFail = true;
          _gateCorrectCount = 0;
        });
      }
    }
  }

  void _fullReset() {
    setState(() {
      _screen = 0;
      currentGate = 0;
      currentQuestion = 0;
      gameWon = false;
      _showHint = false;
      _wrongChosen = null;
      _correctChosen = null;
      _hintShown = false;
      _isProcessing = false;
      _gateCorrectCount = 0;
      _totalCorrect = 0;
      _hintsRemaining = 5;
      _totalMistakes = 0;
      _showMistakeGameOver = false;
      _showGateFail = false;
      _showGateUnlock = false;
      _gates = _buildShuffledGates();
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
        color: _spBg,
        child: Stack(children: [
          Column(children: [
            _buildHeader(),
            if (_screen == 1) _buildScoreBar(),
            Expanded(child: _screen == 0 ? _buildIntro() : gameWon ? _buildWinScreen() : _buildGame()),
          ]),
          if (_showGateUnlock) _buildUnlockOverlay(),
          if (_showGateFail) _buildGateFailOverlay(),
          if (_showMistakeGameOver) _buildMistakeGameOverOverlay(),
        ]),
      ),
    );
  }

  Widget _buildUnlockOverlay() {
    return AnimatedBuilder(
      animation: _unlockAnim,
      builder: (_, __) => Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.55 * _unlockAnim.value),
          child: Center(
            child: Transform.scale(
              scale: 0.7 + 0.3 * _unlockAnim.value,
              child: Container(
                width: 260,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Color(0x4D2A9940), blurRadius: 40, offset: Offset(0, 10))]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🔓', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 14),
                  Text('Gate $_unlockedGateNum Unlocked!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _spGreen)),
                  const SizedBox(height: 8),
                  Text(
                    _unlockedGateNum < 5 ? '${5 - _unlockedGateNum} gate${5 - _unlockedGateNum == 1 ? "" : "s"} remaining!' : 'All gates open! 🎉',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: _spTextMid, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGateFailOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: Color(0x4DD94040), blurRadius: 40, offset: Offset(0, 10))]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🔒', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 14),
              const Text('Gate Still Locked!', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _spRed)),
              const SizedBox(height: 10),
              const Text('You need at least 2 out of 3 correct to unlock this gate.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: _spTextMid, height: 1.5)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showGateFail = false;
                    currentQuestion = 0;
                    _gateCorrectCount = 0;
                    _showHint = false;
                    _wrongChosen = null;
                    _correctChosen = null;
                    _hintShown = false;
                    _isProcessing = false;
                    _gates[currentGate] = _reshuffleGate(currentGate);
                  });
                },
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _spBlue, width: 1.5)),
                  child: const Text('Try This Gate Again', textAlign: TextAlign.center,
                      style: TextStyle(color: _spBlue, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildMistakeGameOverOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 290,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: Color(0x4DD94040), blurRadius: 40, offset: Offset(0, 10))]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('⚠️', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 14),
              const Text('Mistake Limit Reached!', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _spRed)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: _spRedLight, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _spRed.withOpacity(0.5))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Text('❌', style: TextStyle(fontSize: 20))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Text('❌', style: TextStyle(fontSize: 20))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Text('❌', style: TextStyle(fontSize: 20))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Text('❌', style: TextStyle(fontSize: 20))),
                ]),
              ),
              const SizedBox(height: 8),
              const Text(
                'You made 3 mistakes — the maximum allowed. Please review the lesson material and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: _spTextMid, height: 1.5),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => widget.onBackToMenu?.call(),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(color: _spRed, borderRadius: BorderRadius.circular(14)),
                  child: const Text('Go to Games Menu', textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _fullReset,
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _spBlue, width: 1.5)),
                  child: const Text('Start Over', textAlign: TextAlign.center,
                      style: TextStyle(color: _spBlue, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
        color: _spBlue,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Save the Princess',
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
              ]),
            ),
          ),
        ]),
      );

  Widget _buildScoreBar() {
    final ml = _mistakesLeft;
    return Container(
      color: _spBlueLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Gate ${currentGate + 1} / 5',
            style: const TextStyle(color: _spBlue, fontWeight: FontWeight.w700, fontSize: 13)),
        Row(mainAxisSize: MainAxisSize.min, children: [
          ...List.generate(_maxMistakes, (i) =>
            Text(i < ml ? '❤️' : '🖤', style: const TextStyle(fontSize: 14))),
        ]),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(color: _spBlue, borderRadius: BorderRadius.circular(20)),
          child: Text('$_pct%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _buildIntro() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 8),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1565C0), _spBlue],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Color(0x334A90D9), blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(children: [
            Stack(alignment: Alignment.center, children: [
              const Text('🏰', style: TextStyle(fontSize: 72)),
              Positioned(top: 8, right: 30,
                child: AnimatedBuilder(animation: _princessBounceAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _princessBounceAnim.value),
                    child: const Text('👸', style: TextStyle(fontSize: 28))))),
              const Positioned(bottom: 0, left: 40, child: Text('🔐', style: TextStyle(fontSize: 22))),
            ]),
            const SizedBox(height: 16),
            const Text('The Princess is Trapped!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('A wicked spell has locked the princess inside a castle protected by 5 magical gates.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _spBorder),
            boxShadow: const [BoxShadow(color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.info_outline_rounded, color: _spBlue, size: 20),
              SizedBox(width: 8),
              Text('How to Play', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _spTextDark)),
            ]),
            const SizedBox(height: 14),
            _introStep('1', '5 locked gates stand between you and the princess.', Icons.lock_rounded, _spRed),
            _introStep('2', 'Each gate has 3 questions about Cohort Studies. Answer at least 2 correctly.', Icons.quiz_rounded, _spBlue),
            _introStep('3', 'Wrong answer? You get ONE hint per question. Wrong again? Question is skipped.', Icons.lightbulb_outline_rounded, _spAmber),
            _introStep('4', 'You only have 3 ❤️ mistakes for the ENTIRE game. 4th mistake = game over.', Icons.favorite_rounded, _spRed),
            _introStep('5', '5 💡 hints available. Hint + correct = full point, no heart lost. Hint + wrong = heart lost. No hints left = heart lost immediately.', Icons.star_rounded, _spGreen, isLast: true),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _spRedLight, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _spRed.withOpacity(0.3))),
          child: Column(children: [
            const Text('Your Mistake Budget',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _spRed)),
            const SizedBox(height: 10),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('❤️', style: TextStyle(fontSize: 32)),
              SizedBox(width: 8),
              Text('❤️', style: TextStyle(fontSize: 32)),
              SizedBox(width: 8),
              Text('❤️', style: TextStyle(fontSize: 32)),
            ]),
            const SizedBox(height: 8),
            const Text('3 mistakes = game over  •  5 hints available  •  Correct after hint = still scores',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _spTextMid)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _spBlueLight, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _spBorder)),
          child: Column(children: [
            const Text('The 5 Gates',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _spBlue)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (i) {
                  final topics = ['Basics', 'Types', 'Steps', 'Measures', 'Bias'];
                  return Column(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: _spBlue, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _spBlue.withOpacity(0.3), blurRadius: 6)]),
                      child: Center(child: Text('${i + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
                    ),
                    const SizedBox(height: 6),
                    Text(topics[i], style: const TextStyle(fontSize: 9, color: _spTextMid, fontWeight: FontWeight.w600)),
                  ]);
                })),
          ]),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => setState(() => _screen = 1),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(color: _spBlue, borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Color(0x4D4A90D9), blurRadius: 16, offset: Offset(0, 6))]),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Start Rescue Mission',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
              SizedBox(width: 8),
              Text('🗡️', style: TextStyle(fontSize: 18)),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onBackToMenu?.call(),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _spBorder, width: 1.5)),
            child: const Text('Games Menu', textAlign: TextAlign.center,
                style: TextStyle(color: _spTextMid, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ]),
    );
  }

  Widget _introStep(String num, String text, IconData icon, Color color, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Center(child: Icon(icon, size: 15, color: color))),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: _spTextMid, height: 1.5))),
      ]),
    );
  }

  Widget _buildGame() {
    final gate = _rawGates[currentGate];
    final q = _currentQ;
    final ml = _mistakesLeft;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(children: [
        // Gate progress strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _spBorder),
              boxShadow: const [BoxShadow(color: Color(0x1A4A90D9), blurRadius: 6, offset: Offset(0, 2))]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final done = i < currentGate;
                final current = i == currentGate;
                return Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: current ? 46 : 36, height: current ? 46 : 36,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: done ? _spGreen : current ? _spBlue : const Color(0xFFD8E4F0),
                      border: current ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow: current ? [BoxShadow(color: _spBlue.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)] : null),
                    child: Center(child: Text(done ? "✓" : "${i + 1}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: current ? 18 : 13))),
                  ),
                  if (i < 4) Container(width: 18, height: 3, color: i < currentGate ? _spGreen : const Color(0xFFD8E4F0)),
                ]);
              })),
        ),
        const SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(color: _spBlue, borderRadius: BorderRadius.circular(20)),
            child: Text('${gate["title"]} · ${gate["topic"]}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ]),
        const SizedBox(height: 6),

        // Hearts row
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...List.generate(_maxMistakes, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(i < ml ? '❤️' : '🖤', style: const TextStyle(fontSize: 18)))),
          const SizedBox(width: 6),
          Text('$ml mistake${ml == 1 ? "" : "s"} remaining',
              style: TextStyle(fontSize: 11,
                color: ml == 0 ? _spRed : _spTextMid,
                fontWeight: ml <= 1 ? FontWeight.w700 : FontWeight.w400)),
        ]),
        const SizedBox(height: 4),
        Text('Question ${currentQuestion + 1} of 3',
            style: const TextStyle(fontSize: 12, color: _spTextMid)),
        const SizedBox(height: 12),

        // Castle scene
        AnimatedBuilder(
          animation: _castleAnim,
          builder: (_, child) => Transform.scale(scale: 0.92 + 0.08 * _castleAnim.value, child: child),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_spBlueDark.withOpacity(0.08), _spBlue.withOpacity(0.12)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18), border: Border.all(color: _spBorder),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.place_rounded, size: 14, color: _spTextMid),
                const SizedBox(width: 4),
                Text(
                  currentGate == 0 ? 'The princess is deep inside the castle…'
                      : currentGate == 1 ? 'Gate 1 open! She can sense you coming!'
                      : currentGate == 2 ? 'Halfway there! She can hear your footsteps!'
                      : currentGate == 3 ? 'Almost there! One last gate!'
                      : 'So close! The final gate!',
                  style: const TextStyle(fontSize: 11, color: _spTextMid, fontStyle: FontStyle.italic)),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedBuilder(animation: _shakeAnim,
                    builder: (_, __) => Transform.translate(
                      offset: Offset((_showHint || _wrongChosen != null) ? _shakeAnim.value : 0, 0),
                      child: const Text('🧑‍🎓', style: TextStyle(fontSize: 32)))),
                  const SizedBox(height: 4),
                  const Text('You', style: TextStyle(fontSize: 10, color: _spTextMid, fontWeight: FontWeight.w600)),
                ]),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (i) => Text(
                        i < currentGate ? '🔓' : '🔒',
                        style: TextStyle(fontSize: i == currentGate ? 22 : 16)))),
                )),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Stack(alignment: Alignment.center, children: [
                    const Text('🏰', style: TextStyle(fontSize: 40)),
                    Positioned(top: 2, right: 4,
                      child: AnimatedBuilder(animation: _princessBounceAnim,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, _princessBounceAnim.value * 0.5),
                          child: const Text('👸', style: TextStyle(fontSize: 16))))),
                  ]),
                  const SizedBox(height: 4),
                  const Text('Princess', style: TextStyle(fontSize: 10, color: _spTextMid, fontWeight: FontWeight.w600)),
                ]),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i <= currentQuestion ? 18 : 10, height: 6,
                    decoration: BoxDecoration(
                      color: i < currentQuestion ? _spGreen : i == currentQuestion ? _spBlue : const Color(0xFFD8E4F0),
                      borderRadius: BorderRadius.circular(4))))),
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Gate hint banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: _spAmberLight, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _spAmber.withOpacity(0.5))),
          child: Row(children: [
            const Text('🗝️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(child: Text(gate["hint"],
                style: TextStyle(fontSize: 12, color: _spAmber.withOpacity(0.9), fontWeight: FontWeight.w600, height: 1.4))),
          ]),
        ),
        const SizedBox(height: 12),

        // Question
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _spBorder, width: 1.5),
            boxShadow: const [BoxShadow(color: Color(0x1A4A90D9), blurRadius: 8, offset: Offset(0, 2))]),
          child: Text(q.q, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _spTextDark),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 12),

        // Answers
        ...List.generate(4, (i) {
          Color bg = const Color(0xFFF7F8FF);
          Color bdr = const Color(0xFFD0D8F0);
          Color txt = _spTextDark;
          if (_correctChosen == i) { bg = _spGreenLight; bdr = _spGreen; txt = const Color(0xFF1A5E2A); }
          else if (_wrongChosen == i) { bg = _spRedLight; bdr = _spRed; txt = const Color(0xFF8B0000); }
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: GestureDetector(
              onTap: _isProcessing ? null : () => _handleAnswer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bdr, width: 1.5)),
                child: Row(children: [
                  Container(width: 30, height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        color: _correctChosen == i ? _spGreen : _wrongChosen == i ? _spRed : _spBlueLight),
                    child: Center(child: Text(["A", "B", "C", "D"][i],
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: (_correctChosen == i || _wrongChosen == i) ? Colors.white : _spBlue,
                            fontSize: 13)))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(q.opts[i],
                      style: TextStyle(fontSize: 14, color: txt, fontWeight: FontWeight.w500))),
                  if (_correctChosen == i) const Icon(Icons.check_circle_rounded, color: _spGreen, size: 20),
                  if (_wrongChosen == i) const Icon(Icons.cancel_rounded, color: _spRed, size: 20),
                ]),
              ),
            ),
          );
        }),

        // Hint banner
        if (_showHint)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _spAmberLight, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _spAmber.withOpacity(0.6))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Hint (retry free — heart only if wrong again):',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _spAmber.withOpacity(0.9))),
                const SizedBox(height: 4),
                Text(_hintText, style: const TextStyle(fontSize: 13, color: _spTextDark, height: 1.4)),
              ])),
            ]),
          ),

        // Second wrong message
        if (!_showHint && _wrongChosen != null && _hintShown && _isProcessing && !_showMistakeGameOver)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _spRedLight, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _spRed.withOpacity(0.6))),
            child: const Row(children: [
              Text('❌', style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
              Expanded(child: Text('Wrong again — ❤️ lost. Moving to next question.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF8B0000), fontWeight: FontWeight.w600))),
            ]),
          ),

        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => widget.onBackToMenu?.call(),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _spBlue, width: 1.5)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.grid_view_rounded, size: 15, color: _spBlue),
              SizedBox(width: 7),
              Text('Games Menu', style: TextStyle(color: _spBlue, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildWinScreen() {
    final passed = _scorePercent >= 80;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1565C0), _spBlue],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Color(0x334A90D9), blurRadius: 16, offset: Offset(0, 6))]),
          child: Column(children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('🧑‍🎓', style: TextStyle(fontSize: 40)),
              SizedBox(width: 12),
              Text('🤝', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Text('👸', style: TextStyle(fontSize: 40)),
            ]),
            const SizedBox(height: 16),
            const Text('Princess Saved!',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('All 5 gates unlocked!', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('🔓', style: TextStyle(fontSize: 22))))),
          ]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
              color: passed ? _spBlueLight : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _spBorder)),
          child: Column(children: [
            const Text('Mission Complete!',
                style: TextStyle(fontSize: 14, color: _spTextMid, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('$_scorePercent%',
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900,
                    color: passed ? _spBlue : const Color(0xFFE65100))),
            Text('$_totalCorrect / 15 answered correctly',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: _spTextMid)),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(_maxMistakes, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  i < (_maxMistakes - _totalMistakes.clamp(0, _maxMistakes)) ? '❤️' : '🖤',
                  style: const TextStyle(fontSize: 16)))),
              const SizedBox(width: 6),
              Text('$_totalMistakes mistake${_totalMistakes == 1 ? "" : "s"} used',
                  style: const TextStyle(fontSize: 11, color: _spTextMid)),
            ]),
            const SizedBox(height: 4),
            Text(passed ? 'You passed! (80% required)' : 'You need 80% to proceed',
                style: TextStyle(fontSize: 12, color: passed ? _spGreen : const Color(0xFFE65100))),
          ]),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => widget.onNextGame?.call(),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: _spBlue, borderRadius: BorderRadius.circular(28),
                boxShadow: const [BoxShadow(color: Color(0x4D4A90D9), blurRadius: 16, offset: Offset(0, 6))]),
            child: const Text('Next Game: Witch Hunter', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onBackToMenu?.call(),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _spBlue, width: 1.5)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.grid_view_rounded, size: 15, color: _spBlue),
              SizedBox(width: 7),
              Text('Games Menu', style: TextStyle(color: _spBlue, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _fullReset,
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFD8E4F0), width: 1.5)),
            child: const Text('Play Again', textAlign: TextAlign.center,
                style: TextStyle(color: _spTextMid, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      ]),
    ),
    );
  }
}

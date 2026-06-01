// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.width,
    this.height,
    this.displayName,
    this.module1LessonDone,
    this.module1Completed,
    this.module1AvgScore,
    this.module2LessonDone,
    this.module2Completed,
    this.module1Game1Score,
    this.module1Game2Score,
    this.module1Game3Score,
    this.module1Game4Score,
    this.onGoToMod1Lesson,
    this.onGoToMod1Games,
    this.onGoToMod2Lesson,
    this.onGoToMod2Games,
    this.onGoToFinalGame,
    this.onLogout,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? displayName;
  final bool? module1LessonDone;
  final bool? module1Completed;
  final int? module1AvgScore;
  final bool? module2LessonDone;
  final bool? module2Completed;
  final int? module1Game1Score;
  final int? module1Game2Score;
  final int? module1Game3Score;
  final int? module1Game4Score;
  final Future<dynamic> Function()? onGoToMod1Lesson;
  final Future<dynamic> Function()? onGoToMod1Games;
  final Future<dynamic> Function()? onGoToMod2Lesson;
  final Future<dynamic> Function()? onGoToMod2Games;
  final Future<dynamic> Function()? onGoToFinalGame;
  final Future<dynamic> Function()? onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── Derived state ─────────────────────────────────────────

  bool get _mod1LessonDone => widget.module1LessonDone ?? false;

  int get _mod1GamesPlayed => [
        widget.module1Game1Score ?? 0,
        widget.module1Game2Score ?? 0,
        widget.module1Game3Score ?? 0,
        widget.module1Game4Score ?? 0,
      ].where((s) => s > 0).length;

  bool get _mod1AllGamesPlayed => _mod1GamesPlayed == 4;

  // Module 1 is "completed" when all 4 games have been played
  bool get _mod1Completed =>
      widget.module1Completed ?? false || _mod1AllGamesPlayed;

  // Module 2 is unlocked once mod1 is completed
  bool get _mod2Locked => !_mod1Completed;

  bool get _mod2LessonDone => widget.module2LessonDone ?? false;

  bool get _mod2Completed => widget.module2Completed ?? false;

  String get _name =>
      (widget.displayName != null && widget.displayName!.isNotEmpty)
          ? widget.displayName!
          : 'there';

  // ── Status logic ──────────────────────────────────────────
  // Module 1:
  //   Not Started  = lesson not done AND no games played
  //   In Progress  = lesson done OR some games played (but not all)
  //   Completed    = all 4 games played
  //
  // Module 2:
  //   Not Started  = lesson not done AND not completed
  //   In Progress  = lesson done but games not completed
  //   Completed    = module2Completed = true

  String get _mod1StatusLabel {
    if (_mod1Completed) return 'Completed';
    if (_mod1LessonDone || _mod1GamesPlayed > 0) return 'In Progress';
    return 'Not Started';
  }

  Color get _mod1StatusColor {
    if (_mod1Completed) return const Color(0xFF2A9940); // green
    if (_mod1LessonDone || _mod1GamesPlayed > 0)
      return const Color(0xFFE65100); // orange
    return const Color(0xFF888888); // gray
  }

  String get _mod2StatusLabel {
    if (_mod2Completed) return 'Completed';
    if (_mod2LessonDone) return 'In Progress';
    return 'Not Started';
  }

  Color get _mod2StatusColor {
    if (_mod2Completed) return const Color(0xFF2A9940); // green
    if (_mod2LessonDone) return const Color(0xFFE65100); // orange
    return const Color(0xFF888888); // gray
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcome(),
            const SizedBox(height: 8),
            _sectionLabel('Projects'),
            const SizedBox(height: 8),
            _mod1Card(),
            const SizedBox(height: 12),
            _mod2Card(),
            const SizedBox(height: 12),
            if (_mod2Completed) _finalGameCard(),
            if (!_mod2Completed) _finalGameCardLocked(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Welcome header ────────────────────────────────────────
  Widget _welcome() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
            color: const Color(0xFF4A90D9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EpiQuest',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800)),
                GestureDetector(
                  onTap: () async => await widget.onLogout?.call(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.logout_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('Welcome, ',
                          style: TextStyle(
                              color: Color(0xFF1A1A2E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      Text(_name,
                          style: const TextStyle(
                              color: Color(0xFF4A90D9),
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 4),
                    const Text('Your learning adventure begins here',
                        style: TextStyle(
                            color: Color(0xFF1A1A2E),
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(width: 8),
                Image.network(
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.health_and_safety_rounded,
                      size: 48,
                      color: Color(0xFF4A90D9)),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(label,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
      );

  // ── Module 1 card ─────────────────────────────────────────
  Widget _mod1Card() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF4A90D9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x334A90D9),
                  blurRadius: 12,
                  offset: Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1565C0), Color(0xFF4A90D9)],
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.biotech_rounded,
                            size: 64, color: Color(0x99FFFFFF)),
                        SizedBox(height: 8),
                        Text('Case-Control Studies',
                            style: TextStyle(
                                color: Color(0xCCFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _statusBadge(_mod1StatusLabel, _mod1StatusColor),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Module 1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    const Text('Case-Control Studies',
                        style:
                            TextStyle(color: Color(0xCCFFFFFF), fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                          child: _actionBtn(
                        label: 'Start Lesson',
                        icon: Icons.menu_book_rounded,
                        bgColor: Colors.white,
                        textColor: const Color(0xFF4A90D9),
                        onTap: () async =>
                            await widget.onGoToMod1Lesson?.call(),
                        locked: false,
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _actionBtn(
                        label: 'Skip to Games',
                        icon: Icons.sports_esports_rounded,
                        bgColor: _mod1LessonDone
                            ? const Color(0xFF1A5E2A)
                            : const Color(0xFF444444),
                        textColor: Colors.white,
                        onTap: _mod1LessonDone
                            ? () async => await widget.onGoToMod1Games?.call()
                            : () =>
                                _snackbar('Complete Module 1 lesson first!'),
                        locked: !_mod1LessonDone,
                      )),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  // ── Module 2 card ─────────────────────────────────────────
  Widget _mod2Card() {
    final locked = _mod2Locked;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: locked ? const Color(0xFF888888) : const Color(0xFF4A90D9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 12,
                  offset: Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: locked
                            ? [const Color(0xFF444444), const Color(0xFF666666)]
                            : [
                                const Color(0xFF1565C0),
                                const Color(0xFF4A90D9)
                              ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(locked ? Icons.lock_rounded : Icons.group_rounded,
                            size: 64, color: const Color(0x99FFFFFF)),
                        const SizedBox(height: 8),
                        Text(
                            locked
                                ? 'Complete Module 1 to unlock'
                                : 'Cohort Studies',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xCCFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  // Status badge — always shown (locked shows gray "Not Started")
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _statusBadge(
                      locked ? 'Not Started' : _mod2StatusLabel,
                      locked ? const Color(0xFF888888) : _mod2StatusColor,
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Module 2',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    Text(locked ? 'Locked' : 'Cohort Studies',
                        style: const TextStyle(
                            color: Color(0xCCFFFFFF), fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                          child: _actionBtn(
                        label: locked ? 'Locked' : 'Start Lesson',
                        icon: locked
                            ? Icons.lock_rounded
                            : Icons.menu_book_rounded,
                        bgColor: Colors.white,
                        textColor: locked
                            ? const Color(0xFF888888)
                            : const Color(0xFF4A90D9),
                        onTap: locked
                            ? () =>
                                _snackbar('Complete Module 1 games to unlock!')
                            : () async => await widget.onGoToMod2Lesson?.call(),
                        locked: locked,
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _actionBtn(
                        label: 'Skip to Games',
                        icon: Icons.sports_esports_rounded,
                        bgColor: (!locked && _mod2LessonDone)
                            ? const Color(0xFF1A5E2A)
                            : const Color(0xFF444444),
                        textColor: Colors.white,
                        onTap: (!locked && _mod2LessonDone)
                            ? () async => await widget.onGoToMod2Games?.call()
                            : () => _snackbar(locked
                                ? 'Complete Module 1 games to unlock!'
                                : 'Complete Module 2 lesson first!'),
                        locked: locked || !_mod2LessonDone,
                      )),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tap blocker when locked
        if (locked)
          Positioned.fill(
            child: GestureDetector(
              onTap: () =>
                  _snackbar('Complete all Module 1 games to unlock Module 2!'),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x11000000),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
  Widget _statusBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ]),
      );

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
    required bool locked,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: locked
                ? Border.all(color: const Color(0x44FFFFFF), width: 1)
                : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(locked ? Icons.lock_outline_rounded : icon,
                size: 16, color: textColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
            ),
          ]),
        ),
      );

  // ── Final Game Card (locked) ──────────────────────────────
  Widget _finalGameCardLocked() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD8D8D8), width: 1.5),
          ),
          child: Row(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                  child: Icon(Icons.lock_rounded,
                      size: 28, color: Color(0xFF999999))),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Final Challenge',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF999999))),
                    SizedBox(height: 4),
                    Text('Fire & Water Balance',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFAAAAAA),
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 6),
                    Text('Complete Module 2 to unlock',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFFBBBBBB))),
                  ]),
            ),
            const Icon(Icons.lock_rounded, color: Color(0xFF999999), size: 28),
          ]),
        ),
      );

  // ── Final Game Card ───────────────────────────────────────
  Widget _finalGameCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () async => await widget.onGoToFinalGame?.call(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF4A90D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x4D4A90D9),
                    blurRadius: 16,
                    offset: Offset(0, 6))
              ],
            ),
            child: Row(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                    child: Text('⚔️', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Final Challenge',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Fire & Water Balance',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 6),
                      Text('Case-Control vs Cohort Studies',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white60)),
                    ]),
              ),
              const Icon(Icons.play_circle_filled_rounded,
                  color: Colors.white, size: 36),
            ]),
          ),
        ),
      );

  void _snackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF1A1A2E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }
}

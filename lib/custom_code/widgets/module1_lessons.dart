// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Module1Lessons extends StatefulWidget {
  const Module1Lessons({
    super.key,
    this.width,
    this.height,
    this.onDone,
    this.onBack,
  });

  final double? width;
  final double? height;
  final Future<dynamic> Function()? onDone;
  final Future<dynamic> Function()? onBack;

  @override
  State<Module1Lessons> createState() => _Module1LessonsState();
}

class _LessonCard {
  final int id;
  final String sectionNumber;
  final String title;
  final String? mnemonic;
  final List<String> bullets;
  final _CardStyle style;

  const _LessonCard({
    required this.id,
    required this.sectionNumber,
    required this.title,
    this.mnemonic,
    required this.bullets,
    required this.style,
  });
}

enum _CardStyle { intro, definition, list, flow, formula, bias, summary }

// ── Colors — all using #4A90D9 theme ──────────────────────
const Color _primary = Color(0xFF4A90D9);
const Color _accent = Color(0xFF2176C7);
const Color _mint = Color(0xFF10B981);
const Color _amber = Color(0xFFF59E0B);
const Color _rose = Color(0xFFEF4444);
const Color _purple = Color(0xFF8B5CF6);
const Color _bg = Color(0xFFF0F4FF);
const Color _white = Color(0xFFFFFFFF);
const Color _textDark = Color(0xFF1E293B);
const Color _textMid = Color(0xFF475569);
const Color _divider = Color(0xFFD8E4F0);
const Color _cardBorder = Color(0xFFBDD5EE);

const List<_LessonCard> _lessons = [
  _LessonCard(
    id: 1,
    sectionNumber: '01',
    title: 'Analytical Epidemiology',
    mnemonic: 'A = Association',
    bullets: [
      'Studies disease determinants at the individual level',
      'Tests hypotheses about associations between exposure & disease',
      'Two major designs: Case-Control & Cohort',
    ],
    style: _CardStyle.intro,
  ),
  _LessonCard(
    id: 2,
    sectionNumber: '02',
    title: 'What is a Case-Control Study?',
    mnemonic: 'CASE -> CAUSE (reverse order)',
    bullets: [
      'Begins with disease status (case / control)',
      'Looks backward in time to identify exposure',
      'Compares past exposures between groups',
    ],
    style: _CardStyle.definition,
  ),
  _LessonCard(
    id: 3,
    sectionNumber: '03',
    title: 'Key Features',
    bullets: [
      'Retrospective — exposure & outcome already occurred',
      'Uses a comparison group (controls)',
      'Quick & inexpensive to conduct',
      'Best suited for rare diseases',
      'Smaller sample size needed',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 4,
    sectionNumber: '04',
    title: 'When is it Used?',
    bullets: [
      'Rare or uncommon diseases',
      'Long latency period diseases',
      'Early hypothesis generation',
      'Limited time, resources, or budget',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 5,
    sectionNumber: '05',
    title: 'Basic Study Flow',
    bullets: [
      'Select Cases',
      'Select Controls',
      'Matching (reduce confounding)',
      'Measure Exposure',
      'Analyze & Interpret',
    ],
    style: _CardStyle.flow,
  ),
  _LessonCard(
    id: 6,
    sectionNumber: '06',
    title: 'Selecting Cases',
    bullets: [
      'Clear, uniform diagnostic criteria',
      'Prefer incident (newly diagnosed) cases',
      'Avoid prevalent/advanced cases — prevents survival bias',
      'Sources: hospitals, population registries, nested cohort studies',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 7,
    sectionNumber: '07',
    title: 'Selecting Controls',
    bullets: [
      'Must come from the same source population',
      'Similar to cases except disease status',
      'Must be disease-free',
      'Not affected by exposure-related diseases',
      'Sources: hospital, relatives, neighborhood, general population',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 8,
    sectionNumber: '08',
    title: 'Number of Controls',
    bullets: [
      'Standard ratio: 1 case : 1 control',
      'When cases are few — up to 4 controls per case',
      'Multiple control groups improve validity',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 9,
    sectionNumber: '09',
    title: 'Matching',
    bullets: [
      'Purpose: reduce confounding',
      'Types: Group Matching & Pair Matching',
      'Do NOT match on the exposure of interest',
      'Avoid overmatching (too many variables)',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 10,
    sectionNumber: '10',
    title: 'Measuring Exposure',
    bullets: [
      'Methods: interviews, questionnaires, medical/employment records, lab tests',
      'Must be identical for cases AND controls',
      'Use blinding to reduce interviewer bias',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 11,
    sectionNumber: '11',
    title: 'Odds Ratio (OR)',
    mnemonic: 'OR = ad / bc',
    bullets: [
      'a = exposed cases        b = exposed controls',
      'c = unexposed cases    d = unexposed controls',
      'OR = 1  ->  No association',
      'OR > 1  ->  Risk factor',
      'OR < 1  ->  Protective factor',
    ],
    style: _CardStyle.formula,
  ),
  _LessonCard(
    id: 12,
    sectionNumber: '12',
    title: 'Types of Bias',
    bullets: [
      '1. Selection Bias — cases/controls not representative; includes Berksonian & prevalence-incidence bias',
      '2. Information Bias — error in exposure measurement; includes recall bias, telescoping, interviewer bias',
      '3. Confounding Bias — third variable linked to both exposure & disease; solved by matching or statistical adjustment',
    ],
    style: _CardStyle.bias,
  ),
  _LessonCard(
    id: 13,
    sectionNumber: '13',
    title: 'Advantages vs Disadvantages',
    bullets: [
      'Fast & inexpensive',
      'Good for rare diseases',
      'Smaller sample size',
      'Study multiple exposures',
      'No risk to participants',
      'High bias potential',
      'Difficult control selection',
      'Cannot measure incidence',
      'OR only (not Relative Risk)',
      'Unclear temporality',
    ],
    style: _CardStyle.list,
  ),
  _LessonCard(
    id: 14,
    sectionNumber: '14',
    title: 'Summary',
    mnemonic: 'Key takeaway',
    bullets: [
      'Compares exposure between those with and without disease',
      'Uses Odds Ratio as the measure of association',
      'Ideal for rare diseases — but prone to bias',
    ],
    style: _CardStyle.summary,
  ),
];

class _Module1LessonsState extends State<Module1Lessons> {
  int _current = 0;

  Color _accentFor(_CardStyle s) {
    return _primary; // all cards use same blue theme
  }

  Color _cardBgFor(_CardStyle s) {
    return _white; // all cards use white background
  }

  IconData _iconFor(_CardStyle s) {
    switch (s) {
      case _CardStyle.intro:
        return Icons.auto_stories_rounded;
      case _CardStyle.definition:
        return Icons.lightbulb_outline_rounded;
      case _CardStyle.flow:
        return Icons.account_tree_rounded;
      case _CardStyle.formula:
        return Icons.functions_rounded;
      case _CardStyle.bias:
        return Icons.warning_amber_rounded;
      case _CardStyle.summary:
        return Icons.flag_rounded;
      default:
        return Icons.list_alt_rounded;
    }
  }

  Future<void> _markLessonDone() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'module1LessonDone': true});
    } catch (e) {
      // silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _bg,
        child: Column(children: [
          _header(),
          _progressBar(),
          Expanded(child: _cardArea()),
          _navigation(),
        ]),
      ),
    );
  }

  Widget _header() => Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: const BoxDecoration(
          color: _white,
          boxShadow: [
            BoxShadow(
                color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () async => await widget.onBack?.call(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider, width: 1.5),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _textDark, size: 17),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('MODULE 1',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                      letterSpacing: 1.4)),
              const SizedBox(height: 3),
              const Text('Case-Control Studies',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _textDark)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x144A90D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_current + 1} / ${_lessons.length}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _primary)),
          ),
        ]),
      );

  Widget _progressBar() {
    final pct = (_current + 1) / _lessons.length;
    return Container(
      height: 5,
      color: _divider,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: pct,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_primary, _accent]),
          ),
        ),
      ),
    );
  }

  Widget _cardArea() {
    final card = _lessons[_current];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
                  .animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(_current),
        child: _CardWidget(
          card: card,
          accent: _accentFor(card.style),
          bg: _cardBgFor(card.style),
          icon: _iconFor(card.style),
        ),
      ),
    );
  }

  Widget _navigation() {
    final isFirst = _current == 0;
    final isLast = _current == _lessons.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: _white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, -2))
        ],
      ),
      child: Row(children: [
        _NavBtn(
          label: 'Previous',
          icon: Icons.arrow_back_ios_new_rounded,
          iconFirst: true,
          enabled: !isFirst,
          filled: false,
          onTap: () => setState(() => _current--),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _lessons.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: i == _current ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _current ? _primary : _divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _NavBtn(
          label: isLast ? 'Done' : 'Next',
          icon: isLast
              ? Icons.check_circle_rounded
              : Icons.arrow_forward_ios_rounded,
          iconFirst: false,
          enabled: true,
          filled: true,
          onTap: isLast
              ? () async {
                  await _markLessonDone();
                  await widget.onDone?.call();
                }
              : () => setState(() => _current++),
        ),
      ]),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final _LessonCard card;
  final Color accent;
  final Color bg;
  final IconData icon;

  const _CardWidget({
    required this.card,
    required this.accent,
    required this.bg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: const Color(0x1A4A90D9),
                blurRadius: 24,
                offset: const Offset(0, 8))
          ],
          border: Border.all(color: _cardBorder, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            decoration: BoxDecoration(
              color: const Color(0x114A90D9),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0x224A90D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: accent, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Section ${card.sectionNumber}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accent,
                              letterSpacing: 1.3)),
                      const SizedBox(height: 5),
                      Text(card.title,
                          style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: _textDark,
                              height: 1.2)),
                    ]),
              ),
            ]),
          ),
          // Mnemonic
          if (card.mnemonic != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0x114A90D9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x334A90D9)),
                ),
                child: Row(children: [
                  const Icon(Icons.tips_and_updates_rounded,
                      size: 20, color: _primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(card.mnemonic!,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _primary)),
                  ),
                ]),
              ),
            ),
          // Bullets
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  22, card.mnemonic != null ? 18 : 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: card.style == _CardStyle.flow
                    ? _flowBullets(card.bullets)
                    : _regularBullets(card.bullets),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _regularBullets(List<String> bullets) {
    return bullets
        .map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9, right: 14),
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: _primary, shape: BoxShape.circle)),
                ),
                Expanded(
                  child: Text(b,
                      style: const TextStyle(
                          fontSize: 16, height: 1.55, color: _textMid)),
                ),
              ]),
            ))
        .toList();
  }

  List<Widget> _flowBullets(List<String> bullets) {
    return List.generate(bullets.length, (i) {
      final isLast = i == bullets.length - 1;
      return IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
              width: 38,
              height: 38,
              decoration:
                  const BoxDecoration(color: _primary, shape: BoxShape.circle),
              child: Center(
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _white))),
            ),
            if (!isLast)
              Expanded(
                  child: Container(width: 2, color: const Color(0x334A90D9))),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22, top: 7),
              child: Text(bullets[i],
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: _textMid,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ]),
      );
    });
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconFirst, enabled, filled;
  final VoidCallback onTap;

  const _NavBtn({
    required this.label,
    required this.icon,
    required this.iconFirst,
    required this.enabled,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? _white : _primary;
    final bg = filled ? _primary : Colors.transparent;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: filled ? null : Border.all(color: _divider, width: 1.5),
            boxShadow: filled
                ? [
                    const BoxShadow(
                        color: Color(0x334A90D9),
                        blurRadius: 12,
                        offset: Offset(0, 4))
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: iconFirst
                ? [
                    Icon(icon, size: 15, color: fg),
                    const SizedBox(width: 7),
                    Text(label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: fg))
                  ]
                : [
                    Text(label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: fg)),
                    const SizedBox(width: 7),
                    Icon(icon, size: 15, color: fg)
                  ],
          ),
        ),
      ),
    );
  }
}

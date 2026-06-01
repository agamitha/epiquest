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

class Module2Lessons extends StatefulWidget {
  const Module2Lessons({
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
  State<Module2Lessons> createState() => _Module2LessonsState();
}

class _LessonCardM2 {
  final int id;
  final String sectionNumber;
  final String title;
  final String? mnemonic;
  final List<String> bullets;
  final _CardStyleM2 style;

  const _LessonCardM2({
    required this.id,
    required this.sectionNumber,
    required this.title,
    this.mnemonic,
    required this.bullets,
    required this.style,
  });
}

enum _CardStyleM2 { intro, definition, list, flow, formula, bias, summary }

// ── Colors — all using #4A90D9 theme ──────────────────────
const Color _primary2 = Color(0xFF4A90D9);
const Color _accent2 = Color(0xFF2176C7);
const Color _bg2 = Color(0xFFF0F4FF);
const Color _white2 = Color(0xFFFFFFFF);
const Color _textDark2 = Color(0xFF1E293B);
const Color _textMid2 = Color(0xFF475569);
const Color _divider2 = Color(0xFFD8E4F0);
const Color _cardBorder2 = Color(0xFFBDD5EE);

const List<_LessonCardM2> _lessons2 = [
  _LessonCardM2(
    id: 1,
    sectionNumber: '01',
    title: 'Introduction to Cohort Studies',
    mnemonic: 'COHORT = Cause to Outcome',
    bullets: [
      'A type of analytical observational study used to explore associations between exposure and disease',
      'Unlike case-control studies which start with disease, cohort studies start with EXPOSURE',
      'Follow individuals forward in time to observe outcomes',
    ],
    style: _CardStyleM2.intro,
  ),
  _LessonCardM2(
    id: 2,
    sectionNumber: '02',
    title: 'What is a Cohort?',
    bullets: [
      'A group of people sharing a common characteristic or experience within a defined time period',
      'Characteristics can be age, occupation, or shared exposure',
      'Birth cohort — same birth year group',
      'Exposure cohort — e.g., radiologists exposed to X-rays',
    ],
    style: _CardStyleM2.definition,
  ),
  _LessonCardM2(
    id: 3,
    sectionNumber: '03',
    title: 'Key Features',
    bullets: [
      'Participants are disease-free at baseline',
      'Exposure is measured before disease develops',
      'Study proceeds forward in time',
      'Incidence can be directly measured',
      'Calculates Relative Risk (RR) and Attributable Risk (AR)',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 4,
    sectionNumber: '04',
    title: 'Types of Cohort Studies',
    bullets: [
      'Prospective — exposure known today, followed into future; disease has NOT yet occurred when study begins',
      'Retrospective — both exposure and outcome have occurred in the past; uses historical data; faster and more economical',
      'Ambispective (Mixed) — combines retrospective + prospective components',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 5,
    sectionNumber: '05',
    title: 'Indications for Cohort Studies',
    bullets: [
      'Strong preliminary evidence of association exists',
      'Exposure is rare but disease is more common among the exposed',
      'Follow-up is feasible over the study period',
      'Adequate funding and resources are available',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 6,
    sectionNumber: '06',
    title: 'Steps in a Cohort Study',
    bullets: [
      'Selection of Study Subjects — must be free of disease and representative of exposed and non-exposed groups',
      'Measurement of Exposure — questionnaires, interviews, medical records, environmental monitoring',
      'Selection of Comparison Groups — internal comparison, external cohorts, or general population',
      'Follow-up — medical exams, hospital records, death registries; minimize losses to less than 5%',
      'Analysis — calculate incidence, RR, and AR',
    ],
    style: _CardStyleM2.flow,
  ),
  _LessonCardM2(
    id: 7,
    sectionNumber: '07',
    title: 'Measures of Disease Frequency',
    bullets: [
      'Incidence in Exposed = New cases among exposed / Total exposed',
      'Incidence in Unexposed = New cases among unexposed / Total unexposed',
      'Relative Risk (RR) = Incidence in exposed / Incidence in unexposed',
      'RR = 1 means No association',
      'RR greater than 1 means Risk factor',
      'RR less than 1 means Protective factor',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 8,
    sectionNumber: '08',
    title: 'RR Worked Example',
    mnemonic: 'Poor oral hygiene and dental caries',
    bullets: [
      'Study: 100 children with poor oral hygiene vs 100 with good oral hygiene followed for 1 year',
      'Poor hygiene group: 50 developed caries -> Incidence = 50/100 = 0.50',
      'Good hygiene group: 20 developed caries -> Incidence = 20/100 = 0.20',
      'RR = 0.50 / 0.20 = 2.5',
      'Interpretation: Children with poor oral hygiene have 2.5x higher risk of dental caries',
    ],
    style: _CardStyleM2.formula,
  ),
  _LessonCardM2(
    id: 9,
    sectionNumber: '09',
    title: 'Attributable Risk (AR)',
    mnemonic: 'AR = Incidence Exposed minus Incidence Unexposed',
    bullets: [
      'AR = Incidence among exposed minus Incidence among unexposed',
      'From the example: AR = 0.50 minus 0.20 = 0.30',
      'Interpretation: Among children with poor oral hygiene, 30% of the risk of dental caries is attributable to poor oral hygiene itself',
    ],
    style: _CardStyleM2.formula,
  ),
  _LessonCardM2(
    id: 10,
    sectionNumber: '10',
    title: 'Bias in Cohort Studies',
    bullets: [
      '1. Selection Bias — exposed and non-exposed groups not comparable; caused by refusals, missing records, or uneven dropout',
      '2. Information Bias — exposure or outcome measured inaccurately; includes misdiagnosis, poor tools, or different testing standards',
      '3. Confounding Bias — another factor (age, smoking, SES) linked to both exposure and disease, making exposure appear responsible',
      '4. Post-hoc Bias — new hypotheses created after looking at data (data dredging), leading to false or accidental associations',
    ],
    style: _CardStyleM2.bias,
  ),
  _LessonCardM2(
    id: 11,
    sectionNumber: '11',
    title: 'Advantages',
    bullets: [
      'Can directly measure incidence',
      'Establishes clear temporality — exposure comes before disease',
      'Multiple outcomes can be studied simultaneously',
      'RR and AR can be directly calculated',
      'Reduced recall bias compared to case-control studies',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 12,
    sectionNumber: '12',
    title: 'Disadvantages',
    bullets: [
      'Long duration — can take 10 to 30 years',
      'Expensive to conduct and maintain',
      'Large sample size needed',
      'Loss to follow-up reduces study validity',
      'Not suited for rare diseases',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 13,
    sectionNumber: '13',
    title: 'Cohort vs Case-Control',
    bullets: [
      'Cohort: starts with EXPOSURE, follows forward in time, calculates Relative Risk (RR)',
      'Case-Control: starts with DISEASE, looks backward in time, calculates Odds Ratio (OR)',
      'Cohort: ideal for common diseases and establishing temporality',
      'Case-Control: ideal for rare diseases, quick and inexpensive',
    ],
    style: _CardStyleM2.list,
  ),
  _LessonCardM2(
    id: 14,
    sectionNumber: '14',
    title: 'Summary',
    mnemonic: 'Key takeaway',
    bullets: [
      'Cohort studies start with exposure and follow participants forward to observe outcomes',
      'All participants must be disease-free at baseline',
      'Key measures: Relative Risk (RR) and Attributable Risk (AR)',
      'Gold standard for establishing temporality — but costly and time-consuming',
      'Loss to follow-up must be kept under 5% to preserve validity',
    ],
    style: _CardStyleM2.summary,
  ),
];

class _Module2LessonsState extends State<Module2Lessons> {
  int _current = 0;

  Color _accentFor(_CardStyleM2 s) {
    return _primary2;
  }

  Color _cardBgFor(_CardStyleM2 s) {
    return _white2;
  }

  IconData _iconFor(_CardStyleM2 s) {
    switch (s) {
      case _CardStyleM2.intro:
        return Icons.auto_stories_rounded;
      case _CardStyleM2.definition:
        return Icons.lightbulb_outline_rounded;
      case _CardStyleM2.flow:
        return Icons.account_tree_rounded;
      case _CardStyleM2.formula:
        return Icons.functions_rounded;
      case _CardStyleM2.bias:
        return Icons.warning_amber_rounded;
      case _CardStyleM2.summary:
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
          .update({'module2LessonDone': true});
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
        color: _bg2,
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
          color: _white2,
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
                color: _bg2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider2, width: 1.5),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _textDark2, size: 17),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('MODULE 2',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _primary2,
                      letterSpacing: 1.4)),
              const SizedBox(height: 3),
              const Text('Cohort Studies',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _textDark2)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x144A90D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_current + 1} / ${_lessons2.length}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _primary2)),
          ),
        ]),
      );

  Widget _progressBar() {
    final pct = (_current + 1) / _lessons2.length;
    return Container(
      height: 5,
      color: _divider2,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: pct,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_primary2, _accent2]),
          ),
        ),
      ),
    );
  }

  Widget _cardArea() {
    final card = _lessons2[_current];
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
        child: _CardWidgetM2(
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
    final isLast = _current == _lessons2.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: _white2,
        boxShadow: [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, -2))
        ],
      ),
      child: Row(children: [
        _NavBtnM2(
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
                _lessons2.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: i == _current ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _current ? _primary2 : _divider2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _NavBtnM2(
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

class _CardWidgetM2 extends StatelessWidget {
  final _LessonCardM2 card;
  final Color accent;
  final Color bg;
  final IconData icon;

  const _CardWidgetM2({
    super.key,
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
          border: Border.all(color: _cardBorder2, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header band
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
                              color: _textDark2,
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
                      size: 20, color: _primary2),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(card.mnemonic!,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _primary2)),
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
                children: card.style == _CardStyleM2.flow
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
                          color: _primary2, shape: BoxShape.circle)),
                ),
                Expanded(
                  child: Text(b,
                      style: const TextStyle(
                          fontSize: 16, height: 1.55, color: _textMid2)),
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
                  const BoxDecoration(color: _primary2, shape: BoxShape.circle),
              child: Center(
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _white2))),
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
                      color: _textMid2,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ]),
      );
    });
  }
}

class _NavBtnM2 extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconFirst, enabled, filled;
  final VoidCallback onTap;

  const _NavBtnM2({
    super.key,
    required this.label,
    required this.icon,
    required this.iconFirst,
    required this.enabled,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? _white2 : _primary2;
    final bg = filled ? _primary2 : Colors.transparent;
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
            border: filled ? null : Border.all(color: _divider2, width: 1.5),
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

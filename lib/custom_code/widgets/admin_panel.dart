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
import 'package:flutter/services.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({
    Key? key,
    this.width,
    this.height,
    this.onLogout,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function()? onLogout;

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  static const String _adminEmail = 'anusha@igids.ac.in';

  static const Color _blue = Color(0xFF4A90D9);
  static const Color _blueLight = Color(0xFFE3F0FB);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _green = Color(0xFF2A9940);
  static const Color _greenLight = Color(0xFFE8FAEA);
  static const Color _red = Color(0xFFD94040);
  static const Color _redLight = Color(0xFFFFEAEA);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMid = Color(0xFF475569);
  static const Color _border = Color(0xFFBDD5EE);

  final _codeCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();

  String _selectedGroup = 'experimental';
  bool _creating = false;
  String? _createError;
  String? _createSuccess;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = FirebaseAuth.instance.currentUser?.email;

      if (email == null || email.toLowerCase() != _adminEmail.toLowerCase()) {
        context.goNamed('HomePage');
      }
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  String _generateCode() {
    final now = DateTime.now();
    final suffix = '${now.month}${now.day}${now.hour}${now.minute}';
    return 'EPI-$suffix';
  }

  Future<void> _copySessionCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied session code: $code'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _createSession() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    final label = _labelCtrl.text.trim();

    if (code.isEmpty) {
      setState(() => _createError = 'Please enter a session code.');
      return;
    }

    if (label.isEmpty) {
      setState(() => _createError = 'Please enter a label for this session.');
      return;
    }

    setState(() {
      _creating = true;
      _createError = null;
      _createSuccess = null;
    });

    try {
      await FirebaseFirestore.instance.collection('sessions').doc(code).set({
        'code': code,
        'label': label,
        'studyGroup': _selectedGroup,
        'isActive': false,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': FirebaseAuth.instance.currentUser?.email ?? 'admin',
        'expiresAt': null,
        'activatedAt': null,
        'endedAt': null,
      });

      setState(() {
        _creating = false;
        _createSuccess = 'Session "$code" created! Tap Activate to start it.';
        _codeCtrl.clear();
        _labelCtrl.clear();
      });
    } catch (_) {
      setState(() {
        _creating = false;
        _createError = 'Failed to create session. Please try again.';
      });
    }
  }

  Future<void> _activateSession(String code) async {
    await FirebaseFirestore.instance.collection('sessions').doc(code).update({
      'isActive': true,
      'activatedAt': FieldValue.serverTimestamp(),
      'endedAt': null,
    });
  }

  Future<void> _endSession(String code) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'End Session?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'All students using code "$code" will be automatically logged out immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'End Session',
              style: TextStyle(
                color: _red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('sessions').doc(code).update({
      'isActive': false,
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteSession(String code) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Delete Session?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'This will permanently delete session "$code". This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: _red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('sessions').doc(code).delete();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _bg,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              color: _blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onLogout?.call(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Logout',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _createSessionCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Sessions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('sessions')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _border),
                            ),
                            child: const Center(
                              child: Text(
                                'No sessions yet. Create one above.',
                                style: TextStyle(
                                  color: _textMid,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final code = data['code'] as String? ?? doc.id;
                            final label = data['label'] as String? ?? '';
                            final isActive = data['isActive'] as bool? ?? false;
                            final group = data['studyGroup'] as String? ?? '';
                            final createdAt = data['createdAt'] as Timestamp?;

                            return _sessionCard(
                              code: code,
                              label: label,
                              isActive: isActive,
                              group: group,
                              createdAt: createdAt,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSessionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4A90D9),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Create a code and share it with your students before they log in.',
            style: TextStyle(fontSize: 12, color: _textMid),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Session Code (e.g. EPI-A1)',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.key_rounded,
                      color: Color(0xFF94A3B8),
                      size: 18,
                    ),
                    filled: true,
                    fillColor: _blueLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: _blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(
                  () => _codeCtrl.text = _generateCode(),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: _blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Auto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _labelCtrl,
            style: const TextStyle(
              fontSize: 14,
              color: _textDark,
            ),
            decoration: InputDecoration(
              hintText: 'Label (e.g. Batch 1 - Morning)',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.label_outline_rounded,
                color: Color(0xFF94A3B8),
                size: 18,
              ),
              filled: true,
              fillColor: _blueLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _blue,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _blueLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGroup,
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: _textDark,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _blue,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'experimental',
                    child: Text('Experimental Group'),
                  ),
                  DropdownMenuItem(
                    value: 'control',
                    child: Text('Control Group'),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedGroup = v!),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (_createError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _createError!,
                style: const TextStyle(color: _red, fontSize: 12),
              ),
            ),
          if (_createSuccess != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _createSuccess!,
                style: const TextStyle(
                  color: _green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          GestureDetector(
            onTap: _creating ? null : _createSession,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: _creating ? _blue.withOpacity(0.6) : _blue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x334A90D9),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Center(
                child: _creating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Session',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionCard({
    required String code,
    required String label,
    required bool isActive,
    required String group,
    required Timestamp? createdAt,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? _green : _border,
          width: isActive ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (label.isNotEmpty)
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: _textMid,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive ? _greenLight : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? _green : const Color(0xFFD8D8D8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? _green : const Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? _green : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _metaChip(
                Icons.group_rounded,
                group == 'experimental' ? 'Experimental' : 'Control',
              ),
              if (createdAt != null)
                _metaChip(
                  Icons.schedule_rounded,
                  '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!isActive)
                Expanded(
                  child: _actionBtn(
                    'Activate',
                    Icons.play_arrow_rounded,
                    _green,
                    () => _activateSession(code),
                  ),
                ),
              if (isActive)
                Expanded(
                  child: _actionBtn(
                    'End Session',
                    Icons.stop_rounded,
                    _red,
                    () => _endSession(code),
                  ),
                ),
              const SizedBox(width: 8),
              _iconBtn(
                Icons.copy_rounded,
                _blue,
                () => _copySessionCode(code),
              ),
              const SizedBox(width: 8),
              _iconBtn(
                Icons.delete_outline_rounded,
                const Color(0xFF999999),
                () => _deleteSession(code),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: _textMid),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _textMid),
        ),
      ],
    );
  }

  Widget _actionBtn(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color == _green ? _greenLight : _redLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

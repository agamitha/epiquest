// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionMonitor extends StatefulWidget {
  const SessionMonitor({
    Key? key,
    this.width,
    this.height,
    required this.sessionCode,
    this.onSessionEnded,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String sessionCode;
  final Future<dynamic> Function()? onSessionEnded;

  @override
  State<SessionMonitor> createState() => _SessionMonitorState();
}

class _SessionMonitorState extends State<SessionMonitor> {
  StreamSubscription<DocumentSnapshot>? _subscription;
  bool _handledEnd = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void didUpdateWidget(SessionMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sessionCode != widget.sessionCode) {
      _startListening();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _startListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _handledEnd = false;

    final code = widget.sessionCode.trim().toUpperCase();

    if (code.isEmpty) return;

    _subscription = FirebaseFirestore.instance
        .collection('sessions')
        .doc(code)
        .snapshots()
        .listen((snapshot) async {
      if (_handledEnd) return;
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;

      final isActive = data['isActive'] as bool? ?? true;
      final expiresAt = data['expiresAt'] as Timestamp?;
      final isExpired =
          expiresAt != null && expiresAt.toDate().isBefore(DateTime.now());

      if (!isActive || isExpired) {
        _handledEnd = true;

        await _subscription?.cancel();
        _subscription = null;

        if (!mounted) return;

        await widget.onSessionEnded?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 1,
      height: widget.height ?? 1,
    );
  }
}

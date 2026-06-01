// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SessionListener — Custom Action
//
// Call this once on HomePage initState (use FlutterFlow's "On Page Load" action).
// It watches the session document in real-time.
// When admin sets isActive = false, ALL connected students are signed out
// automatically and the onSessionEnded callback fires (navigate to SessionEndedPage).
//
// Parameters:
//   sessionCode   — String — the session code stored in currentUserDocument
//   onSessionEnded — Action — what to do when session ends (navigate to ended page)
// ─────────────────────────────────────────────────────────────────────────────

StreamSubscription<DocumentSnapshot>? _activeSessionSubscription;

Future<void> startSessionListener(
  String sessionCode,
  Future<dynamic> Function() onSessionEnded,
) async {
  // Cancel any existing listener first
  await _activeSessionSubscription?.cancel();
  _activeSessionSubscription = null;

  if (sessionCode.isEmpty) return;

  _activeSessionSubscription = FirebaseFirestore.instance
      .collection('sessions')
      .doc(sessionCode)
      .snapshots()
      .listen((snapshot) async {
    if (!snapshot.exists) return;

    final data = snapshot.data();
    if (data == null) return;

    final isActive = data['isActive'] as bool? ?? true;

    // Check auto-expiry too
    final expiresAt = data['expiresAt'] as Timestamp?;
    final isExpired =
        expiresAt != null && expiresAt.toDate().isBefore(DateTime.now());

    if (!isActive || isExpired) {
      // Session ended — sign out and navigate
      await _activeSessionSubscription?.cancel();
      _activeSessionSubscription = null;
      await FirebaseAuth.instance.signOut();
      await onSessionEnded();
    }
  });
}

// Call this when user manually logs out to clean up the listener
Future<void> stopSessionListener() async {
  await _activeSessionSubscription?.cancel();
  _activeSessionSubscription = null;
}

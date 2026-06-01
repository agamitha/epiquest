// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class SessionEndedPage extends StatelessWidget {
  const SessionEndedPage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Container(
        color: const Color(0xFFF0F4FF),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFEAEA),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFD94040), width: 2)),
                    child: const Center(
                        child: Text('🔒', style: TextStyle(fontSize: 48)))),
                const SizedBox(height: 28),

                const Text('Session Ended',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B))),
                const SizedBox(height: 12),

                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBDD5EE))),
                    child: const Column(children: [
                      Text('Your supervisor has ended this session.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF475569),
                              height: 1.5)),
                      SizedBox(height: 8),
                      Text(
                          'Your progress has been saved.\nThank you for participating in the study.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                              height: 1.6)),
                    ])),
                const SizedBox(height: 32),

                // IGIDS branding
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: Color(0xFF4A90D9), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('EpiQuest · IGIDS Research Study',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: Color(0xFF4A90D9), shape: BoxShape.circle)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    Key? key,
    this.width,
    this.height,
    this.onCreateSuccess,
    this.onGoToLogin,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function()? onCreateSuccess;
  final Future<dynamic> Function()? onGoToLogin;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;
  String? _errorMsg;
  bool _isUserExistsError = false;

  static const Color _blue = Color(0xFF4A90D9);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _red = Color(0xFFD94040);
  static const Color _redLight = Color(0xFFFFEAEA);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid = Color(0xFF475569);

  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // Alternates experimental/control based on existing user count
  Future<String> _assignStudyGroup() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.length % 2 == 0 ? 'experimental' : 'control';
    } catch (_) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now % 2 == 0 ? 'experimental' : 'control';
    }
  }

  Future<void> _createAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _errorMsg = null;
      _isUserExistsError = false;
    });

    // ── Step 1: Create Firebase Auth user ────────────────────────
    UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        switch (e.code) {
          case 'email-already-in-use':
            _isUserExistsError = true;
            _errorMsg =
                'An account already exists with this email. Please sign in instead.';
            break;
          case 'invalid-email':
            _errorMsg = 'Please enter a valid email address.';
            break;
          case 'weak-password':
            _errorMsg = 'Password is too weak. Use at least 6 characters.';
            break;
          case 'operation-not-allowed':
            _errorMsg =
                'Account creation is currently disabled. Contact support.';
            break;
          case 'too-many-requests':
            _errorMsg = 'Too many attempts. Please try again later.';
            break;
          default:
            _errorMsg = 'Account creation failed. Please try again.';
        }
      });
      _shakeCtrl.forward(from: 0);
      return;
    } catch (_) {
      setState(() {
        _loading = false;
        _errorMsg = 'Something went wrong. Please try again.';
      });
      _shakeCtrl.forward(from: 0);
      return;
    }

    final user = credential.user!;

    // ── Step 2: Update display name in Auth ───────────────────────
    try {
      await user.updateDisplayName(_nameCtrl.text.trim());
    } catch (_) {}

    // ── Step 3: Assign study group ────────────────────────────────
    final studyGroup = await _assignStudyGroup();

    // ── Step 4: Write Firestore document with ALL fields ──────────
    // Field names match your Firestore schema exactly (Image 1)
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        // ── Identity fields ──
        'uid': user.uid,
        'email': _emailCtrl.text.trim().toLowerCase(),
        'display_name': _nameCtrl.text.trim(),
        'photo_url': '',
        'phone_number': '',
        'created_time': FieldValue.serverTimestamp(),

        // ── A/B study group ──
        'studyGroup': studyGroup,

        // ── Module completion flags ──
        'module1Completed': false,
        'module2Completed': false,

        // ── Lesson done flags ──
        'module1LessonDone': false,
        'module2LessonDone': false,

        // ── Module aggregate scores ──
        'module1Score': 0,
        'module2Score': 0,
        'module1AvgScore': 0,
        'module2AvgScore': 0,

        // ── Hints used ──
        'module1HintsUsed': 0,
        'module2HintsUsed': 0,

        // ── Individual game scores ──
        'module1Game1Score': 0,
        'module1Game2Score': 0,
        'module1Game3Score': 0,
        'module1Game4Score': 0,
        'module2Game1Score': 0,
        'module2Game2Score': 0,
        'module2Game3Score': 0,
        'module2Game4Score': 0,
      });
    } catch (_) {
      // Firestore write failed silently — navigate anyway
      // User can still use the app; data will be written on first action
    }

    // ── Step 5: Navigate — only reached on success ────────────────
    await widget.onCreateSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Container(
        color: _bg,
        child: Column(children: [
          // Blue header bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            color: _blue,
            child: const Text(
              'EpiQuest',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800),
            ),
          ),

          // Scrollable body
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    // Tooth image
                    Image.network(
                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.health_and_safety_rounded,
                          size: 90,
                          color: _blue),
                    ),
                    const SizedBox(height: 16),

                    const Text('Create Account',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _textDark)),
                    const SizedBox(height: 6),
                    const Text(
                        'Complete the following information to create an account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: _textMid)),
                    const SizedBox(height: 28),

                    // Error banner
                    if (_errorMsg != null) ...[
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              8 *
                                  (0.5 - _shakeAnim.value).abs() *
                                  2 *
                                  (_shakeAnim.value < 0.5 ? -1 : 1),
                              0),
                          child: child,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: _redLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _red, width: 1),
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Icon(Icons.error_outline_rounded,
                                      color: _red, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_errorMsg!,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF8B0000),
                                                fontWeight: FontWeight.w500)),
                                        if (_isUserExistsError) ...[
                                          const SizedBox(height: 6),
                                          GestureDetector(
                                            onTap: () =>
                                                widget.onGoToLogin?.call(),
                                            child: const Text(
                                                'Tap here to sign in →',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: _blue,
                                                    fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor: _blue)),
                                          ),
                                        ],
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Full Name
                    _buildField(
                      controller: _nameCtrl,
                      hint: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Full name is required';
                        if (v.trim().length < 2) return 'Enter your full name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email
                    _buildField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Email is required';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(v.trim()))
                          return 'Enter a valid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password
                    _buildField(
                      controller: _passCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password is required';
                        if (v.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        const SizedBox(width: 4),
                        Icon(Icons.info_outline_rounded,
                            size: 13, color: _blue.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        const Text('Minimum 6 characters',
                            style: TextStyle(fontSize: 12, color: _textMid)),
                      ]),
                    ),
                    const SizedBox(height: 28),

                    // Create Account button
                    GestureDetector(
                      onTap: _loading ? null : _createAccount,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _loading ? _blue.withOpacity(0.6) : _blue,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: _loading
                              ? []
                              : const [
                                  BoxShadow(
                                      color: Color(0x4D4A90D9),
                                      blurRadius: 12,
                                      offset: Offset(0, 4))
                                ],
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: Colors.white))
                              : const Text('Create Account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Have an account? ',
                          style: TextStyle(fontSize: 14, color: _textMid)),
                      GestureDetector(
                        onTap: () => widget.onGoToLogin?.call(),
                        child: const Text('Login',
                            style: TextStyle(
                                fontSize: 14,
                                color: _blue,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15, color: _textDark),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 4), child: suffixIcon)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8E4F0), width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8E4F0), width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _blue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _red, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _red, width: 1.5)),
        errorStyle: const TextStyle(fontSize: 12, color: Color(0xFF8B0000)),
      ),
    );
  }
}

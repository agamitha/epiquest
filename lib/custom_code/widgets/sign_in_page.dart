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

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key? key,
    this.width,
    this.height,
    this.onLoginSuccess,
    this.onAdminLoginSuccess,
    this.onGoToSignUp,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function()? onLoginSuccess;
  final Future<dynamic> Function()? onAdminLoginSuccess;
  final Future<dynamic> Function()? onGoToSignUp;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _sessionCodeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;
  String? _errorMsg;

  bool _showResetPanel = false;
  final _resetEmailCtrl = TextEditingController();
  bool _resetLoading = false;
  String? _resetMsg;
  bool _resetSuccess = false;

  static const String _adminEmail = 'anusha@igids.ac.in';

  static const Color _blue = Color(0xFF4A90D9);
  static const Color _blueLight = Color(0xFFE3F0FB);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _green = Color(0xFF2A9940);
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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _sessionCodeCtrl.dispose();
    _resetEmailCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<String?> _validateSessionCode(String code) async {
    if (code.isEmpty) return 'Please enter your session code.';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(code)
          .get();

      if (!doc.exists) {
        return 'Session code not found. Please check with your supervisor.';
      }

      final data = doc.data()!;
      final isActive = data['isActive'] as bool? ?? false;

      if (!isActive) {
        return 'This session is not active. Please wait for your supervisor to start it.';
      }

      final expiresAt = data['expiresAt'] as Timestamp?;

      if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
        return 'This session has expired.';
      }

      return null;
    } catch (e) {
      return 'Session check failed: $e';
    }
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    final email = _emailCtrl.text.trim();
    final isAdmin = email.toLowerCase() == _adminEmail.toLowerCase();

    UserCredential credential;

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;

        switch (e.code) {
          case 'user-not-found':
            _errorMsg = 'No account found with that email address.';
            break;
          case 'wrong-password':
          case 'invalid-credential':
            _errorMsg = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            _errorMsg = 'Please enter a valid email address.';
            break;
          case 'user-disabled':
            _errorMsg = 'This account has been disabled. Contact support.';
            break;
          case 'too-many-requests':
            _errorMsg = 'Too many failed attempts. Please try again later.';
            break;
          default:
            _errorMsg = 'Sign in failed. Please check your details.';
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

    if (!isAdmin) {
      final sessionCode = _sessionCodeCtrl.text.trim().toUpperCase();
      final codeError = await _validateSessionCode(sessionCode);

      if (codeError != null) {
        await FirebaseAuth.instance.signOut();

        setState(() {
          _loading = false;
          _errorMsg = codeError;
        });

        _shakeCtrl.forward(from: 0);
        return;
      }

      final uid = credential.user?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'sessionCode': sessionCode});
      }
    }

    if (isAdmin) {
      await Future.delayed(const Duration(milliseconds: 300));
      await widget.onAdminLoginSuccess?.call();
    } else {
      await widget.onLoginSuccess?.call();
    }
  }

  Future<void> _sendReset() async {
    final email = _resetEmailCtrl.text.trim();

    if (email.isEmpty) {
      setState(() => _resetMsg = 'Please enter your email address.');
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _resetMsg = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _resetLoading = true;
      _resetMsg = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        _resetLoading = false;
        _resetSuccess = true;
        _resetMsg = 'Reset email sent! Check your inbox (and spam folder).';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _resetLoading = false;
        _resetSuccess = false;

        switch (e.code) {
          case 'user-not-found':
            _resetMsg = 'No account found with that email address.';
            break;
          case 'invalid-email':
            _resetMsg = 'Please enter a valid email address.';
            break;
          default:
            _resetMsg = 'Could not send reset email. Please try again.';
        }
      });
    }
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              color: _blue,
              child: const Text(
                'EpiQuest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.network(
                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/epi-quest-rj85vg/assets/aee8jlk9hggb/tooth.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.health_and_safety_rounded,
                                size: 90,
                                color: _blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Enter your session code, email and password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: _textMid),
                            ),
                            const SizedBox(height: 28),
                            if (_errorMsg != null) ...[
                              AnimatedBuilder(
                                animation: _shakeAnim,
                                builder: (_, child) => Transform.translate(
                                  offset: Offset(
                                    8 *
                                        (0.5 - _shakeAnim.value).abs() *
                                        2 *
                                        (_shakeAnim.value < 0.5 ? -1 : 1),
                                    0,
                                  ),
                                  child: child,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _redLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: _red, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: _red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMsg!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF8B0000),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            _buildField(
                              controller: _sessionCodeCtrl,
                              hint: 'Session Code  (e.g. EPIQUEST-A1)',
                              icon: Icons.key_rounded,
                              textCapitalization: TextCapitalization.characters,
                              validator: (v) {
                                final email =
                                    _emailCtrl.text.trim().toLowerCase();
                                final isAdmin =
                                    email == _adminEmail.toLowerCase();

                                if (isAdmin) return null;

                                if (v == null || v.trim().isEmpty) {
                                  return 'Session code is required';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: _blueLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: _blue,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Provided by your supervisor. Required to access the study.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _textMid,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Color(0xFFD8E4F0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'your account',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _textMid.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Color(0xFFD8E4F0)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildField(
                              controller: _emailCtrl,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }

                                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(v.trim())) {
                                  return 'Enter a valid email';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildField(
                              controller: _passCtrl,
                              hint: 'Password',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscure,
                              suffixIcon: GestureDetector(
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                                child: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF94A3B8),
                                  size: 20,
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Password is required'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: _loading ? null : _signIn,
                              child: Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  color:
                                      _loading ? _blue.withOpacity(0.6) : _blue,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: _loading
                                      ? []
                                      : const [
                                          BoxShadow(
                                            color: Color(0x4D4A90D9),
                                            blurRadius: 12,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Center(
                                  child: _loading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => setState(() {
                                _showResetPanel = true;
                                _resetEmailCtrl.text = _emailCtrl.text.trim();
                                _resetMsg = null;
                                _resetSuccess = false;
                              }),
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _blue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Need to create an account? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textMid,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => widget.onGoToSignUp?.call(),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    if (_showResetPanel) ...[
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _showResetPanel = false;
                            _resetMsg = null;
                            _resetSuccess = false;
                          }),
                          child: Container(color: Colors.black45),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedPadding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD8D8D8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: _blueLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.lock_reset_rounded,
                                        color: _blue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: _textDark,
                                          ),
                                        ),
                                        Text(
                                          "We'll send a reset link to your email",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _textMid,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (_resetMsg != null) ...[
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 11,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _resetSuccess
                                          ? const Color(0xFFE8FAEA)
                                          : _redLight,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: _resetSuccess ? _green : _red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _resetSuccess
                                              ? Icons.check_circle_rounded
                                              : Icons.error_outline_rounded,
                                          color: _resetSuccess ? _green : _red,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _resetMsg!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: _resetSuccess
                                                  ? const Color(0xFF1A5E2A)
                                                  : const Color(0xFF8B0000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                ],
                                if (!_resetSuccess) ...[
                                  TextField(
                                    controller: _resetEmailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: _textDark,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Email address',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 15,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Color(0xFF94A3B8),
                                        size: 20,
                                      ),
                                      filled: true,
                                      fillColor: _blueLight,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: _blue,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: _resetLoading ? null : _sendReset,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _resetLoading
                                            ? _blue.withOpacity(0.6)
                                            : _blue,
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x334A90D9),
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: _resetLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Send Reset Link',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _showResetPanel = false;
                                      _resetMsg = null;
                                      _resetSuccess = false;
                                    }),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: _blue,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Back to Sign In',
                                          style: TextStyle(
                                            color: _blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
                padding: const EdgeInsets.only(right: 4),
                child: suffixIcon,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E4F0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E4F0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _red, width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFF8B0000),
        ),
      ),
    );
  }
}

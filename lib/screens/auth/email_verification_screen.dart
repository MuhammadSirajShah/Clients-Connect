import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends State<EmailVerificationScreen> {
  bool _isChecking = false;

  Future<void> _checkVerification() async {
    setState(() {
      _isChecking = true;
    });

    final authProvider = context.read<AuthProvider>();

    final isVerified =
    await authProvider.checkEmailVerification();

    if (!mounted) return;

    setState(() {
      _isChecking = false;
    });

    if (isVerified) {
      _showSnackBar(
        "Email verified successfully.",
      );

      // Home Screen banne ke baad yahan navigation add karenge.
    } else {
      _showSnackBar(
        "Email is not verified yet. Please check your inbox.",
        isError: true,
      );
    }
  }

  Future<void> _resendVerification() async {
    final authProvider = context.read<AuthProvider>();

    final error =
    await authProvider.resendVerificationEmail();

    if (!mounted) return;

    if (error == null) {
      _showSnackBar(
        "Verification email sent again.",
      );
    } else {
      _showSnackBar(
        error,
        isError: true,
      );
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _showSnackBar(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 90,
                color: Color(0xff7B61FF),
              ),

              const SizedBox(height: 30),

              const Text(
                "Verify Your Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "We've sent a verification link to your email address. "
                    "Please verify your email before continuing.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              if (_isChecking)
                const SizedBox(
                  height: 55,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                PrimaryButton(
                  title: "I Have Verified My Email",
                  onPressed: _checkVerification,
                ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: _resendVerification,
                child: const Text(
                  "Resend Verification Email",
                  style: TextStyle(
                    color: Color(0xff7B61FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: _logout,
                child: const Text(
                  "Use Another Account",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
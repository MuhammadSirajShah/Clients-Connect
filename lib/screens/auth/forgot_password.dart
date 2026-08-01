import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/utils/validators.dart';
import 'package:client_connect/widgets/app_text_field.dart';
import 'package:client_connect/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final error = await authProvider.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      _showSnackBar(
        "Password reset link has been sent to your email.",
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } else {
      _showSnackBar(
        _getReadableError(error),
        isError: true,
      );
    }
  }

  String _getReadableError(String error) {
    if (error.contains("user-not-found")) {
      return "No account found with this email.";
    }

    if (error.contains("invalid-email")) {
      return "Please enter a valid email address.";
    }

    if (error.contains("network-request-failed")) {
      return "No internet connection.";
    }

    return "Unable to send reset link. Please try again.";
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Center(
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 80,
                    color: Color(0xff7B61FF),
                  ),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    "Enter your email address and we will "
                        "send you a link to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType:
                  TextInputType.emailAddress,
                  validator: (value) {
                    return Validators.email(
                      value ?? "",
                    );
                  },
                ),

                const SizedBox(height: 30),

                Consumer<AuthProvider>(
                  builder: (
                      context,
                      authProvider,
                      child,
                      ) {
                    if (authProvider.isLoading) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return PrimaryButton(
                      title: "Send Reset Link",
                      onPressed: _sendResetLink,
                    );
                  },
                ),

                const SizedBox(height: 25),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Color(0xff7B61FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
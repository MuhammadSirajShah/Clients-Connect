import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/screens/auth/forgot_password.dart';
import 'package:client_connect/screens/auth/signup_screen.dart';
import 'package:client_connect/screens/home/home_screen.dart';
import 'package:client_connect/screens/navigation/bottom_nav_screen.dart';
import 'package:client_connect/utils/validators.dart';
import 'package:client_connect/widgets/app_text_field.dart';
import 'package:client_connect/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final error = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error == null) {
      _showSnackBar("Login successful.");

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNavScreen(),
        ),
      );

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

    if (error.contains("wrong-password")) {
      return "Incorrect email or password.";
    }

    if (error.contains("invalid-credential")) {
      return "Incorrect email or password.";
    }

    if (error.contains("invalid-email")) {
      return "Please enter a valid email address.";
    }

    if (error.contains("user-disabled")) {
      return "This account has been disabled.";
    }

    if (error.contains("network-request-failed")) {
      return "No internet connection.";
    }

    return "Something went wrong. Please try again.";
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

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                const Text("Welcome Back", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
                const SizedBox(height: 8),
                const Text("Login to continue to Client Connect", style: TextStyle(color: Colors.grey, fontSize: 16,),),

                const SizedBox(height: 40),
                const Text("Email", style: TextStyle(fontWeight: FontWeight.w600,),),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return Validators.email(
                      value ?? "",
                    );
                  },
                ),
                const SizedBox(height: 25),
                const Text("Password", style: TextStyle(fontWeight: FontWeight.w600),),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  obscureText: _isPasswordObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordObscure =
                        !_isPasswordObscure;
                      });
                    },
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text("Forgot Password?", style: TextStyle(color: Color(0xff7B61FF), fontWeight: FontWeight.w600,),),
                  ),
                ),

                const SizedBox(height: 20),

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
                      title: "Login",
                      onPressed: _login,
                    );
                  },
                ),

                const SizedBox(height: 100),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Color(0xff7B61FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
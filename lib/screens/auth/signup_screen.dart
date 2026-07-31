import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/screens/auth/login_screen.dart';
import 'package:client_connect/utils/validators.dart';
import 'package:client_connect/widgets/app_text_field.dart';
import 'package:client_connect/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isTermsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isTermsAccepted) {
      _showSnackBar(
        "Please accept Terms & Conditions.",
        isError: true,
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final error = await authProvider.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error == null) {
      _showSnackBar(
        "Account created successfully. Please verify your email.",
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      _showSnackBar(
        _getReadableError(error),
        isError: true,
      );
    }
  }

  String _getReadableError(String error) {
    if (error.contains("email-already-in-use")) {
      return "This email is already registered.";
    }

    if (error.contains("invalid-email")) {
      return "Please enter a valid email address.";
    }

    if (error.contains("weak-password")) {
      return "Password is too weak.";
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
          backgroundColor: isError ? Colors.red : Colors.green,
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

                const SizedBox(height: 20),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text("Sign up to get started", style: TextStyle(color: Colors.grey, fontSize: 16,),
                ),

                const SizedBox(height: 40),

                const Text("Full Name", style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _nameController,
                  hintText: "Enter your name",
                  validator: (value){
                    return Validators.name(value ?? "");
                  }
                ),

                const SizedBox(height: 25),

                const Text("Email", style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    return Validators.email(value ?? "");
                  },
                ),

                const SizedBox(height: 25),

                const Text("Password", style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  obscureText: _isPasswordObscure,
                  validator: (value){
                    return Validators.password(value ?? "");
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

                const SizedBox(height: 25),

                const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w600,),
                ),

                const SizedBox(height: 10),

                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm your password",
                  obscureText: _isConfirmPasswordObscure,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Please confirm your password";
                    }
                    if(value != _passwordController.text){
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscure =
                        !_isConfirmPasswordObscure;
                      });
                    },

                    icon: Icon(
                      _isConfirmPasswordObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: _isTermsAccepted,

                      onChanged: (value) {
                        setState(() {
                          _isTermsAccepted =
                              value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        "I agree to the Terms & Conditions",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

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
                      title: "Sign Up",
                      onPressed: _signup,
                    );
                  },
                ),

                const SizedBox(height: 100),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",

                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),

                        children: [
                          TextSpan(
                            text: "Login",
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
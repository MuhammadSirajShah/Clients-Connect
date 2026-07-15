import 'dart:math';

import 'package:client_connect/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text("Forgot Password", style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Reset Password", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10,),
            const Text("Enter your email address and we'll send you a password reset link.",
              style: TextStyle(color: Colors.grey, height: 1.5,),
            ),
            const SizedBox(height: 40,),
            const Text("Email", style: TextStyle(fontWeight: FontWeight.w600,),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 35,),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(onPressed: () async{
                final email = _emailController.text.trim();

                if(email.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Enter email"),
                    )
                  );
                  return;
                }
                if(email.contains("@")){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Invalid email"),
                    )
                  );
                  return;
                }
                final provider = context.read<AuthProvider>();
                final error = await provider.forgotPassword(email);

                if(!mounted) return;
                if(error == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Reset link sent successfully"),
                    ),
                  );
                  Navigator.pop(context);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(error))
                  );
                }

                }, style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5B5FFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(14)
                )
                ),
                child: context.watch<AuthProvider>().isLoading ? CircularProgressIndicator(color: Colors.white,)
                : Text("Send Reset Link", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
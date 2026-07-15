import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/screens/auth/login_screen.dart';
import 'package:client_connect/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(onPressed: (){
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                // }, icon: Icon(Icons.arrow_back_ios)),
          
                SizedBox(height: 20,),
                Text("Create Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Text("Sign up to get started",style: TextStyle(fontSize: 16,color: Colors.grey),),
                SizedBox(height: 45,),
                Text("Full Name",style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(height: 10,),
                AppTextField(
                  controller: _fullNameController,
                  hintText: "Enter your Full Name",
                ),
                SizedBox(height: 25,),
                Text("Email",style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(height: 10,),
                AppTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                ),
                SizedBox(height: 25,),
                Text("Password",style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(height: 10,),
                AppTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  obscureText: isObscure,
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isObscure = !isObscure;
                    });
                  }, icon: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined
                  )
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (value){
                          setState(() {
                            isChecked = value!;
                          });
                        }),
          
                    Text("I agree to the",style: TextStyle(color: Colors.black87),),
                    TextButton(onPressed: (){
          
                    }, child: Text("Terms & Conditions")),
                  ],
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(onPressed: ()async{

                      final email = _emailController.text.trim();

                      final password = _passwordController.text.trim();

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter email"),
                          ),
                        );
                        return;
                      }

                      if (!email.contains("@")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid email"),
                          ),
                        );
                        return;
                      }

                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password must be at least 6 characters",
                            ),
                          ),
                        );
                        return;
                      }

                      final provider = context.read<AuthProvider>();

                      final error = await provider.signup(
                        email: email,
                        password: password,
                      );
                      if (!mounted) return;
                      if (error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account Created Successfully.\nVerification email sent.",
                            ),
                          ),
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                          ),
                        );
                      }
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff5B5FFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16)
                        )
                      ),
                      child: Text("Sign Up",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
                ),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: TextStyle(fontSize: 15,color: Colors.grey),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    }, child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff7B61FF)),)),
                    SizedBox(height: 12,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

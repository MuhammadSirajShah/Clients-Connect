import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/screens/auth/forgot_password.dart';
import 'package:client_connect/screens/auth/signup_screen.dart';
import 'package:client_connect/screens/home/home_screen.dart';
import 'package:client_connect/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;

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
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("Welcome back",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Text("Login to continue using\nClient Connect",textAlign: TextAlign.center, style: TextStyle(fontSize: 16,height: 1.5,color: Colors.grey),),
                SizedBox(height: 45,),
                Text("Email",style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(height: 10,),
                AppTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
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
                        : Icons.visibility_outlined,
                  )),
                ),
                SizedBox(height: 15,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  }, child: Text("Forgot Password?")
                  ),
                ),
                SizedBox(height: 15,),
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

                      if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter password"),
                          ),
                        );
                        return;
                      }

                      final provider = context.read<AuthProvider>();

                      final error = await provider.login(email: email, password: password,
                      );

                      if (!mounted) return;

                      if (error == null) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Successful"),
                          ),
                        );

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen(),
                          ),
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error),
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
                      child: Text("Login",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                      )
                  ),
                ),
                SizedBox(height: 36,),
                Center(child: Text("or continue with",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(14)
                        ),
                        child: Center(child:
                        Image.asset("assets/icons/Google.png",height: 30,width: 30,)
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Icon(Icons.apple,size: 30,)
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50,),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",style: TextStyle(color: Colors.grey,fontSize: 15),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                    }, child: Text("Sign Up"))
                  ],
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

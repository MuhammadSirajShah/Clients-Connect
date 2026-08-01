import 'dart:async';

import 'package:client_connect/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1),(){
      if(!mounted) return;

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2563EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_rounded,color: Colors.white,size: 90),
            SizedBox(height: 25,),
            Text("Clients Connect",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 12,),
            Text("Connect • Discuss • Grow" ,style: TextStyle(fontSize: 16,color: Colors.white70),),
            SizedBox(height: 50,),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      )



    );
  }
}

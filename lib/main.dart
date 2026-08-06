import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/Provider/profile_provider.dart';
import 'package:client_connect/firebase_options.dart';
import 'package:client_connect/screens/auth/auth_checker.dart';
import 'package:client_connect/screens/auth/email_verification_screen.dart';
import 'package:client_connect/screens/home/home_screen.dart';
import 'package:client_connect/screens/navigation/bottom_nav_screen.dart';
import 'package:client_connect/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider(),
        ),
      ],
        child: ClientConnectApp()
      ),
      );
}

class ClientConnectApp extends StatelessWidget {
  const ClientConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Connect',
      // home: const SplashScreen(),
      home: const SplashScreen(),

    );
  }
}
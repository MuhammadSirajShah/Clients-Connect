import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xffE8F1FF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 120, color: const Color(0xff2563EB),),
          ),
          const SizedBox(height: 50),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(
            fontSize: 17, color: Colors.grey, height: 1.5,)),
        ],
      ),
    );
  }
}
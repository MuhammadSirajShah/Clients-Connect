import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
              colors: [
                Color(0xff5B5FFF),
                Color(0xff7B61FF),
              ],
          ),
        ),
        child: ElevatedButton(
            onPressed: onPressed,

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
      ),
    );
  }
}

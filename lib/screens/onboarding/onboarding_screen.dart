import 'package:client_connect/screens/auth/login_screen.dart';
import 'package:client_connect/screens/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }


  void nextPage(){
    if(currentPage < 2){
      _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
      );
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child:  Column(
            children: [

              currentPage == 2
                  ? SizedBox()
                  : Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }, child: Text("Skip",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),)
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index){
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    OnboardingPage(
                      icon: Icons.groups_rounded,
                      title: "Find Trusted Clients",
                      description:
                      "Connect with genuine clients and discuss projects professionally.",
                    ),

                    OnboardingPage(
                      icon: Icons.chat_bubble_outline,
                      title: "Discuss Project Budgets",
                      description:
                      "Know the market rates before starting your next project.",
                    ),

                    OnboardingPage(
                      icon: Icons.rocket_launch,
                      title: "Build Strong Connections",
                      description:
                      "Share experiences, learn from others and grow your network.",
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Color(0xff2563EB)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                )
              ),
              SizedBox(height: 50,),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(onPressed: nextPage,


                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16)
                      )
                    ),
                    child: Text(currentPage == 2 ? "Get Started" : "Next",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                    )),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

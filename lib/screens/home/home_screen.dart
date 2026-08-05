import 'package:client_connect/widgets/home/developer_card.dart';
import 'package:client_connect/widgets/home/home_header.dart';
import 'package:client_connect/widgets/home/post_card.dart';
import 'package:client_connect/widgets/home/project_card.dart';
import 'package:client_connect/widgets/home/search_bar_widget.dart';
import 'package:client_connect/widgets/home/stats_card.dart';
import 'package:client_connect/widgets/home/section_title.dart';
import 'package:client_connect/widgets/home/trending_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              HomeHeader(),
              SizedBox(height: 25,),
              SearchBarWidget(),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      icon: Icons.people,
                      title: "Developers",
                      value: "1,245",
                    ),
                  ),
                  SizedBox(height: 10,),

                  Expanded(
                    child: StatsCard(
                      icon: Icons.work_outline,
                      title: "Projects",
                      value: "328",
                    ),
                  ),
                  SizedBox(height: 10,),

                  Expanded(
                    child: StatsCard(
                      icon: Icons.forum_outlined,
                      title: "Discussion",
                      value: "892",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35,),
              SectionTitle(
                title: "Trending Discussions",
              ),

              SizedBox(height: 15),

              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [

                    TrendingCard(
                      title: "How much should a Flutter developer charge for an e-commerce app?",
                      author: "Ali Khan",
                      comments: 24,
                    ),

                    TrendingCard(
                      title: "Client is asking for unlimited revisions. What should I do?",
                      author: "Ahmed Ali",
                      comments: 17,
                    ),

                    TrendingCard(
                      title: "Is \$500 a fair budget for a Firebase + Flutter project?",
                      author: "Usman",
                      comments: 31,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35,),
              SectionTitle(
                title: "Latest Projects",
              ),
              const SizedBox(height: 35),

              SectionTitle(
                title: "Top Rated Developers",
              ),
              const SizedBox(height: 35),

              SectionTitle(
                title: "Recent Community Posts",
              ),

              const SizedBox(height: 15),

              PostCard(
                userName: "Ali Khan",
                time: "2 hours ago",
                post:
                "A client offered me \$600 for a complete Flutter app with Firebase. Do you think this budget is fair?",

                likes: 32,
                comments: 18,
              ),

              PostCard(
                userName: "Ahmed Raza",
                time: "5 hours ago",
                post:
                "How much should I charge for adding push notifications and payment gateway in an existing Flutter application?",

                likes: 21,
                comments: 11,
              ),

              PostCard(
                userName: "Usman Ali",
                time: "Yesterday",
                post:
                "What is the average market rate for building an admin panel using Flutter Web?",

                likes: 45,
                comments: 27,
              ),

              const SizedBox(height: 30),

              const SizedBox(height: 15),

              SizedBox(
                height: 270,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [

                    DeveloperCard(
                      name: "Muhammad Ali",
                      skill: "Flutter Developer",
                      rating: 4.9,
                      experience: "3 Years Experience",
                    ),

                    DeveloperCard(
                      name: "Ahmed Raza",
                      skill: "Firebase Expert",
                      rating: 4.8,
                      experience: "5 Years Experience",
                    ),

                    DeveloperCard(
                      name: "Usman Khan",
                      skill: "UI/UX Designer",
                      rating: 4.7,
                      experience: "4 Years Experience",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              ProjectCard(
                title: "Flutter E-Commerce App",
                clientName: "John Smith",
                budget: "\$800",
                category: "Flutter",
              ),
              SizedBox(height: 15,),

              ProjectCard(
                title: "Firebase Chat Application",
                clientName: "Sarah Johnson",
                budget: "\$450",
                category: "Firebase",
              ),
              SizedBox(height: 15,),

              ProjectCard(
                title: "Flutter Admin Dashboard",
                clientName: "Michael Brown",
                budget: "\$1200",
                category: "Flutter",
              ),

            ],
          ),
        ),
      ),
    );
  }
}
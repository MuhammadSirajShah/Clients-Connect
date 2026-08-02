import 'package:client_connect/widgets/home/home_header.dart';
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
                  StatsCard(
                    icon: Icons.people,
                    title: "Developers",
                    value: "1,245",
                  ),

                  StatsCard(
                    icon: Icons.work_outline,
                    title: "Projects",
                    value: "328",
                  ),

                  StatsCard(
                    icon: Icons.forum_outlined,
                    title: "Discussion",
                    value: "892",
                  ),
                  const SizedBox(height: 35),



                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
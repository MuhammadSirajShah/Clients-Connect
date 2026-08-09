import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/models/post_model.dart';
import 'package:client_connect/widgets/home/discussion_card.dart';
import 'package:client_connect/widgets/home/home_app_bar.dart';
import 'package:client_connect/widgets/home/post_card.dart';
import 'package:client_connect/widgets/home/welcome_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),

              const SizedBox(height: 20),

              const WelcomeBanner(),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Trending Discussions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextStyle(
                      color:
                      Color(0xff2563EB),
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const DiscussionCard(
                name: "Ahmed Khan",
                question:
                "Is \$1500 reasonable for an e-commerce website?",
                comments: 24,
                likes: 15,
              ),

              const DiscussionCard(
                name: "Sara Ali",
                question:
                "How much does a Flutter app cost in 2024?",
                comments: 18,
                likes: 9,
              ),

              const DiscussionCard(
                name: "Usman Javed",
                question:
                "Best tech stack for Marketplace App?",
                comments: 12,
                likes: 6,
              ),

              const SizedBox(height: 30),

              const Text(
                "Recent Discussions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================
              // FIREBASE POSTS
              // ==================================

              StreamBuilder<List<PostModel>>(
                stream: context
                    .read<PostProvider>()
                    .postsStream,

                builder:
                    (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                      Padding(
                        padding:
                        EdgeInsets.all(
                          30,
                        ),
                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.all(
                          20,
                        ),
                        child: Text(
                          "Unable to load posts.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final posts =
                      snapshot.data ?? [];

                  if (posts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.all(
                          30,
                        ),
                        child: Text(
                          "No discussions yet.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: posts
                        .map(
                          (post) => PostCard(
                        post: post,
                      ),
                    )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
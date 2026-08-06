import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/models/post_model.dart';
import 'package:client_connect/screens/community/create_post_screen.dart';
import 'package:client_connect/widgets/community/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        centerTitle: true,
      ),

      body: StreamBuilder<List<PostModel>>(
        stream: provider.postsStream,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text(
                "No Posts Yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostTile(
                post: posts[index],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        backgroundColor: const Color(0xff2563EB),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
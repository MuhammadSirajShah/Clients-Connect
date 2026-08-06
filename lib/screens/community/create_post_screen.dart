import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final postProvider = context.read<PostProvider>();

    final user = authProvider.currentUser;

    if (user == null) return;

    final post = PostModel(
      postId: const Uuid().v4(),
      userId: user.uid,
      userName: user.displayName ?? "Anonymous",
      userImage: user.photoURL,
      description: _postController.text.trim(),
      likesCount: 0,
      commentsCount: 0,
      createdAt: DateTime.now(),
    );

    final error = await postProvider.createPost(post);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Post created successfully."),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _postController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Share your thoughts...",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Post cannot be empty";
                  }

                  if (value.trim().length < 10) {
                    return "Post must contain at least 10 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                  provider.isLoading ? null : _createPost,
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Publish Post"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
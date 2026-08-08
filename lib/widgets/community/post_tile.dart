import 'package:client_connect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostTile extends StatelessWidget {
  final PostModel post;

  const PostTile({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd MMM yyyy • hh:mm a',
                        ).format(post.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              post.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                const Icon(
                  Icons.favorite_border,
                  size: 20,
                ),

                const SizedBox(width: 5),

                Text("${post.likesCount}"),

                const SizedBox(width: 20),

                const Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                ),

                const SizedBox(width: 5),

                Text("${post.commentsCount}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
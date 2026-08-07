import 'package:flutter/material.dart';

class DiscussionCard extends StatelessWidget {
  final String name;
  final String question;
  final int comments;
  final int likes;

  const DiscussionCard({
    super.key,
    required this.name,
    required this.question,
    required this.comments,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 24,
              child: Icon(Icons.person),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 18),
                      const SizedBox(width: 4),
                      Text("$comments"),

                      const SizedBox(width: 20),

                      const Icon(Icons.favorite_border, size: 18),
                      const SizedBox(width: 4),
                      Text("$likes"),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
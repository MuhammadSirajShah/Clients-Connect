import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String post;
  final String time;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.userName,
    required this.post,
    required this.time,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const CircleAvatar(
                backgroundColor: Color(0xff2563EB),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            post,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [

              const Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.red,
              ),

              const SizedBox(width: 6),

              Text("$likes"),

              const SizedBox(width: 20),

              const Icon(
                Icons.chat_bubble_outline,
                size: 20,
              ),

              const SizedBox(width: 6),

              Text("$comments"),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class TrendingCard extends StatelessWidget {
  final String title;
  final String author;
  final int comments;

  const TrendingCard({
    super.key,
    required this.title,
    required this.author,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin:  EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: Icon(Icons.person, size: 18),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  author,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: Colors.grey,
              ),

              SizedBox(width: 4),

              Text("$comments"),
            ],
          ),
        ],
      ),
    );
  }
}
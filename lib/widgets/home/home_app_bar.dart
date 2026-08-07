import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 28),
        ),

        const Spacer(),

        const Text(
          "Home",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, size: 26),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 26),
        ),
      ],
    );
  }
}
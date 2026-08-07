import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),

            child: TextField(
              decoration: InputDecoration(
                hintText: "Search chats...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,

              itemBuilder: (context, index) {
                return ListTile(

                  leading: const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),

                  title: const Text(
                    "Muhammad Ali", style: TextStyle(fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: const Text(
                    "Hello Sir 👋",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text("10:30 AM", style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        height: 20,
                        width: 20,

                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),

                        child: const Center(
                          child: Text("2", style: TextStyle(color: Colors.white, fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
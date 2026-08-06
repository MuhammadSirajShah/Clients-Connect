import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/profile_provider.dart';
import 'package:client_connect/screens/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not found"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: profileProvider.profileStream(user.uid),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("Profile not found"),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                CircleAvatar(
                  radius: 55,
                  backgroundImage: profile.profileImage != null
                      ? NetworkImage(profile.profileImage!)
                      : null,

                  child: profile.profileImage == null
                      ? const Icon(
                    Icons.person,
                    size: 60,
                  )
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  profile.email,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bio",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),

                const SizedBox(height: 8),

                Text(profile.bio),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Skills",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills
                      .map(
                        (skill) => Chip(
                      label: Text(skill),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const EditProfileScreen(),
                        ),
                      );

                    },

                    child: const Text(
                      "Edit Profile",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
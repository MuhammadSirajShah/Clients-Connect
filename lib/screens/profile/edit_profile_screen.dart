import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/profile_provider.dart';
import 'package:client_connect/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:client_connect/models/user_profile_model.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController skillsController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    final user = authProvider.currentUser;

    if (user == null) return;

    String? imageUrl;

    // Upload Image (if selected)
    if (_selectedImage != null) {
      imageUrl = await profileProvider.uploadProfileImage(
        user.uid,
        _selectedImage!,
      );

      if (imageUrl == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload image."),
          ),
        );
        return;
      }
    }

    final profile = UserProfileModel(
      uid: user.uid,
      name: nameController.text.trim(),
      email: user.email ?? "",
      profileImage: imageUrl,
      bio: bioController.text.trim(),
      skills: skillsController.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      createdAt: DateTime.now(),
    );

    final error = await profileProvider.updateProfile(profile);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully."),
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
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Form(

            key: _formKey,

            child: Column(

              children: [

                Stack(

                  alignment: Alignment.bottomRight,

                  children: [

                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                      _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                      )
                          : null,
                    ),

                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xff2563EB),

                      child: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: bioController,
                  maxLines: 3,

                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: skillsController,

                  decoration: const InputDecoration(
                    labelText: "Skills",
                    hintText:
                    "Flutter, Firebase, Provider",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                PrimaryButton(
                  title: "Save Changes",
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
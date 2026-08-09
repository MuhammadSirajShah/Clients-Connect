import 'dart:io';

import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/models/post_model.dart';
import 'package:client_connect/screens/navigation/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedImages = [];

  String? _selectedTechnology;

  bool _isAnonymous = false;

  final List<String> _technologies = [
    "Flutter",
    "Firebase",
    "UI/UX Design",
    "Backend",
    "Full Stack",
    "Other",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  // ==========================================
  // PICK MULTIPLE IMAGES
  // ==========================================

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedImages =
      await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedImages.isEmpty) {
        return;
      }

      setState(() {
        for (final image in pickedImages) {
          final file = File(image.path);

          if (!_selectedImages.any(
                (existing) => existing.path == file.path,
          )) {
            _selectedImages.add(file);
          }
        }
      });
    } catch (e) {
      _showMessage(
        "Unable to select images.",
        isError: true,
      );
    }
  }

  // ==========================================
  // REMOVE IMAGE
  // ==========================================

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // ==========================================
  // CREATE POST
  // ==========================================

  Future<void> _postDiscussion() async {
    FocusScope.of(context).unfocus();
    if (_titleController.text.trim().isEmpty) {
      _showMessage(
        "Please enter discussion title.",
        isError: true,
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showMessage(
        "Please enter description.",
        isError: true,
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final postProvider = context.read<PostProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      _showMessage(
        "Please login first.",
        isError: true,
      );
      return;
    }

    final postId = const Uuid().v4();

    final post = PostModel(
      postId: postId,
      userId: user.uid,
      userName: _isAnonymous
          ? "Anonymous"
          : (user.displayName ?? "User"),
      userImage: _isAnonymous ? null : user.photoURL,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      budget: _budgetController.text.trim().isEmpty
          ? null
          : _budgetController.text.trim(),
      technology: _selectedTechnology,
      images: const [],
      isAnonymous: _isAnonymous,
      likesCount: 0,
      commentsCount: 0,
      createdAt: DateTime.now(),
    );

    final error = await postProvider.createPost(
      post: post,
      images: _selectedImages,
    );

    if (!mounted) return;

    if (error == null) {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
          const BottomNavScreen(),
        ),
            (route) => false,
      );
    } else {
      _showMessage(
        error,
        isError: true,
      );
    }
  }

  // ==========================================
  // MESSAGE
  // ==========================================

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
          isError ? Colors.red : Colors.green,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================
            // APP BAR
            // ==================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, size: 24, color: Color(0xff1E293B),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text("Create Discussion", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xff111827),
                        ),
                      ),
                    ),
                  ),

                  Consumer<PostProvider>(
                    builder: (context, provider, child,) {
                      return GestureDetector(
                        onTap: provider.isLoading
                            ? null
                            : _postDiscussion,
                        child: Text(provider.isLoading ? "Posting..." : "Post", style: TextStyle(
                          color: provider.isLoading
                                ? Colors.grey
                                : const Color(0xff6D5DF6), fontSize: 15, fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ==================================
            // CONTENT
            // ==================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 30,),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel(
                      title: "Title",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        hintText: "Enter discussion title",
                      ),
                    ),

                    const SizedBox(height: 20),

                    const _FieldLabel(
                      title: "Description",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: _inputDecoration(
                        hintText: "Write your question or details...",
                      ),
                    ),

                    const SizedBox(height: 20),

                    const _FieldLabel(
                      title:
                      "Budget (Optional)",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _budgetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _inputDecoration(
                        hintText: "Enter budget amount",
                      ),
                    ),

                    const SizedBox(height: 20),

                    const _FieldLabel(
                      title: "Technology",
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _selectedTechnology,
                      decoration: _inputDecoration(
                        hintText: "Select technology"),
                      items: _technologies
                          .map((technology) {
                          return DropdownMenuItem<String>(
                            value: technology,
                            child: Text(technology),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTechnology =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const _FieldLabel(
                      title:
                      "Add Images (Optional)",
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xffA5B4FC),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xff6D5DF6),
                        ),
                      ),
                    ),

                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (context, index,) =>
                          const SizedBox(width: 10,),
                          itemBuilder: (context, index){
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index);
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close, color: Colors.white, size: 15),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text("${_selectedImages.length}/10 images selected", style: TextStyle(
                          color: Color(0xff64748B),fontSize: 12,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Anonymous Post", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                            color: Color(0xff334155),
                          ),
                        ),

                        Switch(value: _isAnonymous,
                          onChanged: (value) {
                            setState(() {_isAnonymous = value;
                            });
                          },
                          activeTrackColor: const Color(0xff6D5DF6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xff94A3B8),
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xffE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xffE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xff6D5DF6),
        ),
      ),
    );
  }
}

// ==========================================
// FIELD LABEL
// ==========================================

class _FieldLabel extends StatelessWidget {
  final String title;

  const _FieldLabel({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xff334155),
      ),
    );
  }
}
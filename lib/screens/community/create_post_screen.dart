import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  final TextEditingController _budgetController =
  TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final List<File> _selectedImages = [];

  String? _selectedTechnology;

  bool _isAnonymous = false;

  bool _isLoading = false;

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
          if (_selectedImages.length >= 10) {
            break;
          }

          final File file = File(image.path);

          if (!_selectedImages.any(
                (existingImage) =>
            existingImage.path == file.path,
          )) {
            _selectedImages.add(file);
          }
        }
      });

      if (pickedImages.length + _selectedImages.length > 10) {
        _showMessage(
          "You can upload maximum 10 images.",
        );
      }
    } catch (e) {
      _showMessage(
        "Unable to select images.",
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
  // POST
  // ==========================================

  Future<void> _postDiscussion() async {
    FocusScope.of(context).unfocus();

    if (_titleController.text.trim().isEmpty) {
      _showMessage(
        "Please enter discussion title.",
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showMessage(
        "Please enter description.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    /*
      Firebase Post functionality
      next step me yahan connect hogi.

      Currently only UI testing.
    */

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showMessage(
      "Discussion is ready to post.",
    );
  }

  // ==========================================
  // SNACKBAR
  // ==========================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    constraints:
                    const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                      color: Color(0xff1E293B),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Create Discussion",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff111827),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap:
                    _isLoading
                        ? null
                        : _postDiscussion,
                    child: Text(
                      _isLoading
                          ? "Posting..."
                          : "Post",
                      style: TextStyle(
                        color: _isLoading
                            ? Colors.grey
                            : const Color(
                          0xff6D5DF6,
                        ),
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================
            // CONTENT
            // ==================================

            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ==========================
                    // TITLE
                    // ==========================

                    const _FieldLabel(
                      title: "Title",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                      _titleController,
                      textInputAction:
                      TextInputAction.next,
                      decoration:
                      _inputDecoration(
                        hintText:
                        "Enter discussion title",
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================
                    // DESCRIPTION
                    // ==========================

                    const _FieldLabel(
                      title: "Description",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                      _descriptionController,
                      maxLines: 5,
                      textInputAction:
                      TextInputAction.newline,
                      decoration:
                      _inputDecoration(
                        hintText:
                        "Write your question or details...",
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================
                    // BUDGET
                    // ==========================

                    const _FieldLabel(
                      title: "Budget (Optional)",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                      _budgetController,
                      keyboardType:
                      const TextInputType
                          .numberWithOptions(
                        decimal: true,
                      ),
                      decoration:
                      _inputDecoration(
                        hintText:
                        "Enter budget amount (e.g. \$1500)",
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================
                    // TECHNOLOGY
                    // ==========================

                    const _FieldLabel(
                      title: "Technology",
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value:
                      _selectedTechnology,
                      decoration:
                      _inputDecoration(
                        hintText:
                        "Select technology",
                      ),
                      icon: const Icon(
                        Icons
                            .keyboard_arrow_down,
                        color:
                        Color(0xff64748B),
                      ),
                      items:
                      _technologies
                          .map(
                            (
                            technology,
                            ) {
                          return DropdownMenuItem<
                              String>(
                            value:
                            technology,
                            child: Text(
                              technology,
                              style:
                              const TextStyle(
                                fontSize: 14,
                              ),
                            ),
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

                    // ==========================
                    // ADD IMAGES
                    // ==========================

                    const _FieldLabel(
                      title:
                      "Add Images (Optional)",
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _selectedImages.length >=
                          10
                          ? null
                          : _pickImages,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(
                            color: const Color(
                              0xffA5B4FC,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color:
                          Color(0xff6D5DF6),
                          size: 25,
                        ),
                      ),
                    ),

                    // ==========================
                    // IMAGE PREVIEW
                    // ==========================

                    if (_selectedImages
                        .isNotEmpty) ...[
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection:
                          Axis.horizontal,
                          itemCount:
                          _selectedImages
                              .length,
                          separatorBuilder:
                              (
                              context,
                              index,
                              ) =>
                          const SizedBox(
                            width: 10,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                  child:
                                  Image.file(
                                    _selectedImages[
                                    index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child:
                                  GestureDetector(
                                    onTap: () {
                                      _removeImage(
                                        index,
                                      );
                                    },
                                    child:
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration:
                                      const BoxDecoration(
                                        color:
                                        Colors.black54,
                                        shape:
                                        BoxShape
                                            .circle,
                                      ),
                                      child:
                                      const Icon(
                                        Icons.close,
                                        color:
                                        Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${_selectedImages.length}/10 images selected",
                        style: const TextStyle(
                          color:
                          Color(0xff64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ==========================
                    // ANONYMOUS POST
                    // ==========================

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        const Text(
                          "Anonymous Post",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w500,
                            color:
                            Color(0xff334155),
                          ),
                        ),

                        Switch(
                          value: _isAnonymous,
                          onChanged: (value) {
                            setState(() {
                              _isAnonymous =
                                  value;
                            });
                          },
                          activeColor:
                          Colors.white,
                          activeTrackColor:
                          Color(0xff6D5DF6),
                          inactiveThumbColor:
                          Colors.white,
                          inactiveTrackColor:
                          Color(0xffCBD5E1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // INPUT DECORATION
  // ==========================================

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
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(9),
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
        borderRadius:
        BorderRadius.circular(9),
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
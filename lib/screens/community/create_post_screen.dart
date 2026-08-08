import 'package:flutter/material.dart';

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

  void _postDiscussion() {
    FocusScope.of(context).unfocus();

    if (_titleController.text.trim().isEmpty) {
      _showMessage("Please enter a discussion title.");
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showMessage("Please enter a description.");
      return;
    }

    _showMessage("Discussion is ready to post.");
  }

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
            // =========================
            // TOP BAR
            // =========================

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
                    constraints: const BoxConstraints(),
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
                    onTap: _postDiscussion,
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        color: Color(0xff6D5DF6),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // CONTENT
            // =========================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // TITLE
                    // =========================

                    const _FieldLabel(
                      title: "Title",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "Enter discussion title",
                        hintStyle: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xff6D5DF6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // DESCRIPTION
                    // =========================

                    const _FieldLabel(
                      title: "Description",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText:
                        "Write your question or details...",
                        hintStyle: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xff6D5DF6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // BUDGET
                    // =========================

                    const _FieldLabel(
                      title: "Budget (Optional)",
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _budgetController,
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText:
                        "Enter budget amount (e.g. \$1500)",
                        hintStyle: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xff6D5DF6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // TECHNOLOGY
                    // =========================

                    const _FieldLabel(
                      title: "Technology",
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _selectedTechnology,
                      decoration: const InputDecoration(
                        hintText: "Select technology",
                        hintStyle: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xff6D5DF6),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xff64748B),
                      ),
                      items: _technologies.map(
                            (technology) {
                          return DropdownMenuItem<String>(
                            value: technology,
                            child: Text(
                              technology,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTechnology = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // IMAGES
                    // =========================

                    const _FieldLabel(
                      title: "Add Images (Optional)",
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        _showMessage(
                          "Image picker will be added next.",
                        );
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: const Color(0xffA5B4FC),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xff6D5DF6),
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // ANONYMOUS POST
                    // =========================

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Anonymous Post",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff334155),
                          ),
                        ),

                        Switch(
                          value: _isAnonymous,
                          onChanged: (value) {
                            setState(() {
                              _isAnonymous = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor:
                          const Color(0xff6D5DF6),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor:
                          const Color(0xffCBD5E1),
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
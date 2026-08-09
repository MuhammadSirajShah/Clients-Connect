import 'package:client_connect/Provider/auth_provider.dart';
import 'package:client_connect/Provider/post_provider.dart';
import 'package:client_connect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _checkingLike = true;

  @override
  void initState() {
    super.initState();
    _checkLike();
  }

  Future<void> _checkLike() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _checkingLike = false;
        });
      }
      return;
    }

    final liked = await context
        .read<PostProvider>()
        .hasUserLikedPost(
      postId: widget.post.postId,
      userId: user.uid,
    );

    if (!mounted) return;

    setState(() {
      _isLiked = liked;
      _checkingLike = false;
    });
  }

  Future<void> _toggleLike() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return;
    }

    final provider = context.read<PostProvider>();

    if (_isLiked) {
      final error = await provider.unlikePost(
        postId: widget.post.postId,
        userId: user.uid,
      );

      if (error != null && mounted) {
        _showMessage(error);
        return;
      }

      if (mounted) {
        setState(() {
          _isLiked = false;
        });
      }
    } else {
      final error = await provider.likePost(
        postId: widget.post.postId,
        userId: user.uid,
      );

      if (error != null && mounted) {
        _showMessage(error);
        return;
      }

      if (mounted) {
        setState(() {
          _isLiked = true;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  String _formatDate(DateTime date) {
    return DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

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
          // ==================================
          // USER INFO
          // ==================================

          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                const Color(0xff2563EB),
                backgroundImage:
                post.userImage != null &&
                    post.userImage!.isNotEmpty
                    ? NetworkImage(
                  post.userImage!,
                )
                    : null,
                child:
                post.userImage == null ||
                    post.userImage!.isEmpty
                    ? const Icon(
                  Icons.person,
                  color: Colors.white,
                )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.isAnonymous
                          ? "Anonymous"
                          : post.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _formatDate(
                        post.createdAt,
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==================================
          // TITLE
          // ==================================

          if (post.title.isNotEmpty)
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (post.title.isNotEmpty)
            const SizedBox(height: 8),

          // ==================================
          // DESCRIPTION
          // ==================================

          Text(
            post.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xff334155),
            ),
          ),

          // ==================================
          // BUDGET
          // ==================================

          if (post.budget != null &&
              post.budget!.isNotEmpty) ...[
            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0xffEFF6FF,
                ),
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: Text(
                "Budget: ${post.budget}",
                style: const TextStyle(
                  color: Color(0xff2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          // ==================================
          // TECHNOLOGY
          // ==================================

          if (post.technology != null &&
              post.technology!.isNotEmpty) ...[
            const SizedBox(height: 10),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0xffF1F5F9,
                ),
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: Text(
                post.technology!,
                style: const TextStyle(
                  color: Color(0xff475569),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // ==================================
          // IMAGES
          // ==================================

          if (post.images.isNotEmpty) ...[
            const SizedBox(height: 16),

            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection:
                Axis.horizontal,
                itemCount: post.images.length,
                itemBuilder:
                    (context, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      right: 10,
                    ),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                      child: Image.network(
                        post.images[index],
                        width: 280,
                        height: 220,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (
                            context,
                            child,
                            loadingProgress,
                            ) {
                          if (loadingProgress ==
                              null) {
                            return child;
                          }

                          return Container(
                            width: 280,
                            height: 220,
                            color:
                            const Color(
                              0xffF1F5F9,
                            ),
                            child:
                            const Center(
                              child:
                              CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder:
                            (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            width: 280,
                            height: 220,
                            color:
                            const Color(
                              0xffF1F5F9,
                            ),
                            child:
                            const Icon(
                              Icons
                                  .broken_image_outlined,
                              size: 40,
                              color:
                              Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 18),

          // ==================================
          // COUNTS
          // ==================================

          Row(
            children: [
              Icon(
                _isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 19,
                color: _isLiked
                    ? Colors.red
                    : Colors.grey,
              ),

              const SizedBox(width: 6),

              Text(
                "${post.likesCount}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(width: 20),

              const Icon(
                Icons.chat_bubble_outline,
                size: 19,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Text(
                "${post.commentsCount}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const Divider(
            height: 25,
          ),

          // ==================================
          // ACTION BUTTONS
          // ==================================

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _checkingLike
                      ? null
                      : _toggleLike,
                  borderRadius:
                  BorderRadius.circular(
                    8,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: [
                        Icon(
                          _isLiked
                              ? Icons.favorite
                              : Icons
                              .favorite_border,
                          size: 20,
                          color: _isLiked
                              ? Colors.red
                              : Colors.grey,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Like",
                          style:
                          TextStyle(
                            color: _isLiked
                                ? Colors.red
                                : Colors.grey,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: () {
                    // Comments screen
                    // next step
                  },
                  borderRadius:
                  BorderRadius.circular(
                    8,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: const [
                        Icon(
                          Icons
                              .chat_bubble_outline,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Comment",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: () {
                    // Share
                    // next step
                  },
                  borderRadius:
                  BorderRadius.circular(
                    8,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: const [
                        Icon(
                          Icons
                              .share_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
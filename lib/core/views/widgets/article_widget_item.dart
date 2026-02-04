// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/models/bookmark_article.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/home/cubit/bookmark/bookmark_cubit.dart';

class ArticleWidgetItem extends StatelessWidget {
  final Article article;
  final bool isSmaller;

  const ArticleWidgetItem({
    super.key,
    required this.article,
    this.isSmaller = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final publishedDate = DateFormat.yMMMEd().format(
      DateTime.parse(article.publishedAt ?? DateTime.now().toString()),
    );

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/articleDetailsPage',
        arguments: article,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl:
                        article.urlToImage ??
                        'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                    height: isSmaller ? size.height * 0.15 : size.height * 0.17,
                    width: isSmaller ? size.width * 0.3 : size.width * 0.37,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),

                /// 🔖 Bookmark Button
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: BlocBuilder<BookmarkCubit, BookmarkState>(
                        builder: (context, state) {
                          final cubit = context.read<BookmarkCubit>();
                          final bookmarks = state is BookmarkLoaded
                              ? state.bookmarks
                              : <BookmarkArticle>[];

                          // استخدم الـ Cubit cache بالإضافة إلى الحالة لضمان التزامن
                          final isBookmarked = cubit.isBookmarked(
                                article.url ?? '',
                              ) ||
                              bookmarks.any(
                                (b) => b.url == article.url,
                              );

                          return IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked ? Colors.blue : Colors.grey,
                            ),
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                               if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please log in to manage bookmarks',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              try {
                                final messenger = ScaffoldMessenger.of(context);
                                await context
                                    .read<BookmarkCubit>()
                                    .toggleBookmark(article);

                                final nowBookmarked = context
                                    .read<BookmarkCubit>()
                                    .isBookmarked(article.url ?? '');

                                // أظهر سناك بار واحد في كل مرة
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      nowBookmarked
                                          ? 'Added to bookmarks'
                                          : 'Removed from bookmarks',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } catch (e) {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Bookmark failed: ${e.toString()}',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: size.width * 0.01),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.source?.name ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  article.title ?? '',
                  maxLines: isSmaller ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  publishedDate,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

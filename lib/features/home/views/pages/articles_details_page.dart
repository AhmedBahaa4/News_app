// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button_widget.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/home/cubit/bookmark/bookmark_cubit.dart';

import 'package:share_plus/share_plus.dart';
import 'reader_mode_page.dart';

class ArticlesDetailsPage extends StatelessWidget {
  final Article articles;
  const ArticlesDetailsPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final publishedDate = DateFormat.yMMMEd().format(
      DateTime.parse(articles.publishedAt ?? DateTime.now().toString()),
    );
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,

        body: Stack(
          children: [
            // ===== BACKGROUND IMAGE =====
            CachedNetworkImage(
              imageUrl:
                  articles.urlToImage ??
                  'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
              height: size.height * 0.45,
              width: size.width,
              fit: BoxFit.cover,
            ),
            // ===== Container =====
            Container(
              height: size.height * 0.45,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  begin: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.8),
                    AppColors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),

            // ===== AppBar  =====
            Positioned(
              height: size.height * 0.05,
              left: 8,
              right: 8,
              child: SizedBox(
                width: size.width,
                height: size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBarButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icons.arrow_back,
                      hasPaddingBetween: true,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppBarButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReaderModePage(article: articles),
                              ),
                            );
                          },
                          icon: Icons.chrome_reader_mode_outlined,
                          hasPaddingBetween: true,
                        ),
                        BlocBuilder<BookmarkCubit, BookmarkState>(
                          builder: (context, state) {
                            final cubit = context.read<BookmarkCubit>();
                            final isBookmarked =
                                cubit.isBookmarked(articles.url ?? '');

                            return AppBarButton(
                              onTap: () async {
                                try {
                                  await cubit.toggleBookmark(articles);
                                  final nowBookmarked =
                                      cubit.isBookmarked(articles.url ?? '');
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Bookmark failed: $e'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              icon: isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              hasPaddingBetween: true,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        AppBarButton(
                          onTap: () => _showSummary(context),
                          icon: Icons.summarize_outlined,
                          hasPaddingBetween: true,
                        ),
                        const SizedBox(width: 8),
                        AppBarButton(
                          onTap: () {
                            final shareText = [
                              if (articles.title?.isNotEmpty ?? false)
                                articles.title!,
                              if (articles.url?.isNotEmpty ?? false)
                                articles.url!,
                            ].join('\n');
                            if (shareText.isNotEmpty) {
                              Share.share(shareText);
                            }
                          },
                          icon: Icons.share,
                          hasPaddingBetween: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ===== CONTENT column =====
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.height * 0.01),

                            child: Text(
                              'Busniess',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          articles.title ?? '',
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: size.height * 0.001),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Trending",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color:
                                          AppColors.red, // اللون اللي انت عايزه
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: " . $publishedDate",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== AUTHOR SECTION =====
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: CachedNetworkImageProvider(
                                    articles.urlToImage ??
                                        'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                  ),
                                ),

                                SizedBox(width: size.width * 0.03),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      articles.source?.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),

                                    Text(
                                      publishedDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ===== ARTICLE CONTENT =====
                            Text(
                              [articles.description, articles.content]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join("\n\n"),
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    color: AppColors.black,
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _showSummary(context),
                                icon: const Icon(Icons.summarize_outlined),
                                label: const Text('TL;DR Summary'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ReaderModePage(article: articles),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.chrome_reader_mode_outlined),
                                label: const Text('Reader Mode'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSummary(BuildContext context) {
    final summary = _buildSummaryText();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TL;DR',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...summary
                .map(
                  (line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(
                          child: Text(
                            line,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                // ignore: unnecessary_to_list_in_spreads
                .toList(),
          ],
        ),
      ),
    );
  }

  List<String> _buildSummaryText() {
    final text = [
      articles.description,
      articles.content,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' ');

    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    if (sentences.isEmpty || sentences.first.isEmpty) {
      return ['No summary available for this article.'];
    }
    return sentences.take(5).toList();
  }
}
// fontamily is Inter

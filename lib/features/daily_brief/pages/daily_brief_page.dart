// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/daily_brief/cubit/daily_brief_cubit.dart';
import 'package:news_app/features/daily_brief/models/daily_brief_item.dart';
import 'package:news_app/features/daily_brief/daily_brief_service.dart';
import 'package:news_app/features/home/views/pages/articles_details_page.dart';

class DailyBriefPage extends StatefulWidget {
  const DailyBriefPage({super.key});

  @override
  State<DailyBriefPage> createState() => _DailyBriefPageState();
}

class _DailyBriefPageState extends State<DailyBriefPage> {
  late final DailyBriefCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DailyBriefCubit(DailyBriefService())..loadBrief();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _cubit.loadBrief(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  title: const Text('Daily Brief'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _cubit.loadBrief(),
                    ),
                  ],
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFeef2ff), Color(0xFFe0f4ff)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Your quick news digest",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Top headlines + smart summaries in seconds.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<DailyBriefCubit, DailyBriefState>(
                  builder: (context, state) {
                    if (state is DailyBriefLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is DailyBriefError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: AppColors.red),
                          ),
                        ),
                      );
                    }
                    if (state is DailyBriefLoaded) {
                      final items = state.items;
                      if (items.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: Text('No brief available yet')),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverList.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => _BriefCard(item: items[i]),
                        ),
                      );
                    }
                    return const SliverFillRemaining(child: SizedBox());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  final DailyBriefItem item;
  const _BriefCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final article = item.article;
    final date = article.publishedAt != null
        ? DateFormat.yMMMEd().format(DateTime.tryParse(article.publishedAt!) ?? DateTime.now())
        : '';
    final image = article.urlToImage ?? article.url?? '';
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticlesDetailsPage(articles: article),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: image,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 170,
                        color: Colors.grey.shade300,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 170,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    )
                  : Container(height: 10, color: Colors.transparent),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          article.source?.name ?? 'Unknown source',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Spacer(),
                      if (date.isNotEmpty)
                        Text(
                          date,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.title ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800, height: 1.2),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticlesDetailsPage(articles: article),
                          ),
                        ),
                        icon: const Icon(Icons.chrome_reader_mode_outlined),
                        label: const Text('Open'),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor: Colors.green.shade50,
                        label: Text(
                          '${(item.summary.split(' ').length / 200 * 60).clamp(0, 6).ceil()} min read',
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


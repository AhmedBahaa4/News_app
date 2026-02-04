// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/world/presentation/pages/world_details_page.dart';
import '../cubit/world_cubit.dart';
import '../cubit/world_state.dart';
import '../../domain/entities/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class WorldPage extends StatefulWidget {
  const WorldPage({super.key});

  @override
  State<WorldPage> createState() => _WorldPageState();
}

class _WorldPageState extends State<WorldPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<WorldCubit>().fetchWorldNews();

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        context.read<WorldCubit>().fetchWorldNews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('World'),
        centerTitle: true,
        // backgroundColor: Colors.black,
      ),
      body: BlocBuilder<WorldCubit, WorldState>(
        builder: (context, state) {
          if (state is WorldLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorldLoaded) {
            if (state.articles.isEmpty) {
              return _EmptyState(
                onRetry: () =>
                    context.read<WorldCubit>().fetchWorldNews(refresh: true),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<WorldCubit>().fetchWorldNews(refresh: true),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 720;
                      final itemWidth =
                          isWide ? constraints.maxWidth / 2 : constraints.maxWidth;
                      return ListView.builder(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          final article = state.articles[index];
                          return _WorldCard(
                            article: article,
                            width: itemWidth,
                            isWide: isWide,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }

          if (state is WorldError) {
            return _EmptyState(
              message: state.message,
              onRetry: () =>
                  context.read<WorldCubit>().fetchWorldNews(refresh: true),
            );
          }

          // Initial fallback
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final Article article;
  final double width;
  final bool isWide;

  const _WorldCard({
    required this.article,
    required this.width,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final date = article.publishedAt != null
        ? DateFormat.yMMMEd().format(
            DateTime.tryParse(article.publishedAt!) ?? DateTime.now(),
          )
        : null;

    String? asString(dynamic v) {
      if (v == null) {
        return null;
      }
      if (v is String) {
        return v;
      }
      return v.toString();
    }

    final imageUrl = asString(article.image)?.isNotEmpty == true
        ? asString(article.image)!
        : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

    final src = article.source;
    String? sourceName;
    sourceName = asString(src?['name']) ?? asString(src?['title']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorldDetailsPage(article: article),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        height: isWide ? 220 : 260,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade400,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.black.withOpacity(0.15),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (sourceName?.isNotEmpty ?? false)
                        ? Text(
                            sourceName!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: Colors.white70, letterSpacing: 0.4),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 6),
                    Text(
                      article.title ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (date != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _EmptyState({
    this.message = 'No articles available right now.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_off, size: 52, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }
}

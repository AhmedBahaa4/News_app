import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/article.dart';

class WorldDetailsPage extends StatelessWidget {
  final Article article;

  const WorldDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final publishedDate = article.publishedAt != null
        ? DateFormat.yMMMEd()
            .format(DateTime.tryParse(article.publishedAt!) ?? DateTime.now())
        : null;
    final content = article.content?.trim();
    final description = article.description?.trim();
    final bodyText = (content?.isNotEmpty ?? false)
        ? content!
        : (description?.isNotEmpty ?? false)
            ? description!
            : 'No content available for this article.';

    final imageUrl = (article.image != null && article.image!.isNotEmpty)
        ? article.image!
        : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                article.title ?? 'Untitled',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (article.source?['name'] != null || publishedDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (article.source?['name'] != null)
                      Text(
                        article.source?['name'] ?? '',
                        style: textTheme.labelLarge
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    if (article.source?['name'] != null && publishedDate != null)
                      const SizedBox(width: 12),
                    if (publishedDate != null)
                      Text(
                        publishedDate,
                        style: textTheme.labelLarge
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                bodyText,
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/home/models/top_hedlines_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List<Article> articles;
  final TopHedlinesBody? request;

  const CustomCarouselSlider({super.key, required this.articles, this.request});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _current = 0;
  final CarouselSliderController _controller =
      CarouselSliderController(); // صح ✅

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (widget.articles.isEmpty) {
      return const SizedBox.shrink(); // أمان
    }

    return Column(
      children: [
        CarouselSlider(
          items: widget.articles.map((article) {
            final publishedDate = DateFormat.yMMMEd().format(
              DateTime.parse(article.publishedAt ?? DateTime.now().toString()),
            );

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.articleDetails,
                arguments: article,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          article.urlToImage ??
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Gradient + Title
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${article.source?.name ?? 'Unknown'} • $publishedDate",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.title ?? 'No Title Available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: AppColors.primary,
                        child: Text(
                          widget.request?.category ?? "No Category",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            height: size.height * 0.25,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _current,
          count: widget.articles.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 3,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.grey,
            spacing: 8,
            radius: 12,
          ),
          onDotClicked: (index) => _controller.jumpToPage(index),
        ),
      ],
    );
  }
}

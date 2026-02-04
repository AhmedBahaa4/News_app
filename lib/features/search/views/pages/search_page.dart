// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';
import 'package:news_app/features/search/views/widgets/categories_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchcController = TextEditingController();
  final List<String> _categories = const [
    "All",
    "Sport",
    "Business",
    "Health",
    "Technology",
    "Science",
    "Entertainment",
  ];
  final List<String> _categoryKeys = const [
    "all",
    "sports",
    "business",
    "health",
    "technology",
    "science",
    "entertainment",
  ];
  int _selectedCategory = 0;

  void _triggerSearch(SearchCubit cubit) {
    cubit.search(
      _searchcController.text,
      category: _categoryKeys[_selectedCategory],
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchCubit>(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find news by keyword or category",
                style:
                    theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchcController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) => _triggerSearch(searchCubit),
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                      bloc: searchCubit,
                      buildWhen: (previous, current) =>
                          current is Searching ||
                          current is SearchResultEror ||
                          current is SearchResultLoaded,
                      builder: (context, state) {
                        if (state is Searching) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return TextButton(
                          onPressed: () => _triggerSearch(searchCubit),
                          child: const Text('Search'),
                        );
                      },
                    ),
                    suffixIconColor: AppColors.grey2,
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CategoriesBar(
                categories: _categories,
                selectedIndex: _selectedCategory,
                onSelected: (index) {
                  setState(() => _selectedCategory = index);
                  _triggerSearch(searchCubit);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: searchCubit,
                  buildWhen: (previous, current) =>
                      current is Searching ||
                      current is SearchResultEror ||
                      current is SearchResultLoaded,
                  builder: (context, state) {
                    if (state is Searching) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is SearchResultEror) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: AppColors.red),
                        ),
                      );
                    } else if (state is SearchResultLoaded) {
                      final articles = state.articles;

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: articles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final article = articles[index];
                          return ArticleWidgetItem(
                            article: article,
                            isSmaller: false,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Search for articles or pick a category',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//use pagination


/*
import 'package:flutter/material.dart';

class CnnSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CnnSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // 🔍 Search Icon
          const Icon(Icons.search, color: Colors.black54),

          const SizedBox(width: 10),

          // ✏️ Text Input
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search for articles...",
                border: InputBorder.none,
              ),
            ),
          ),

          // ========== FILTER (3 special lines) ==========
          GestureDetector(
            onTap: () {
              // Action of filter
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Line 1 (right)
                Container(
                  width: 22,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Line 2 (left)
                Container(
                  width: 14,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Line 3 (right again)
                Container(
                  width: 22,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/offline_mode/cubit/offline_cubit.dart';
import 'package:news_app/core/offline_mode/views/no_internet_view.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button_widget.dart';
import 'package:news_app/core/views/widgets/app_drawer_widget.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/home/cubit/home_cubit_cubit.dart';
import 'package:news_app/features/home/models/top_hedlines_body.dart';
import 'package:news_app/features/home/views/pages/all_articles_page.dart';
import 'package:news_app/features/home/views/widgets/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widgets/recommendation_list_widget.dart';
import 'package:news_app/features/home/views/widgets/title_headline.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return BlocProvider(
//       create: (context) {
//         final homeCubit = HomeCubit();
//         homeCubit.getTopHeadlines();
//         homeCubit.getRecommendationItems();
//         return homeCubit;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             elevation: 0,
//             leading: Padding(
//               padding: EdgeInsets.all(size.height * 0.01),
//               child: AppBarButton(
//                 onTap: () {
//                   _scaffoldKey.currentState!.openDrawer();
//                 },
//                 icon: Icons.menu,
//               ),
//             ),
//             actions: [
//               SizedBox(width: size.width * 0.02),
//               AppBarButton(
//                 onTap: () => Navigator.pushNamed(context, AppRoutes.search),
//                 icon: Icons.search,
//                 hasPaddingBetween: true,
//               ),

//               SizedBox(width: size.width * 0.04),
//               AppBarButton(
//                 onTap: () {},
//                 icon: Icons.notifications_outlined,
//                 hasPaddingBetween: true,
//               ),
//             ],
//           ),
//           drawer: const AppDrawer(),
//           body: Builder(
//             builder: (context) {
//               final homeCubit = BlocProvider.of<HomeCubit>(context);

//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(height: size.height * 0.02),
//                     TitleHeadLineWidget(title: 'Breaking News', onTap: () {}),
//                     SizedBox(height: size.height * 0.01),
//                     BlocBuilder<HomeCubit, HomeState>(
//                       bloc: homeCubit,
//                       buildWhen: (previous, current) =>
//                           current is TopHeadlinesLoading ||
//                           current is TopHeadlinesLoaded ||
//                           current is TopHeadlinesError,
//                       builder: (context, state) {
//                         if (state is TopHeadlinesLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator.adaptive(),
//                           );
//                         } else if (state is TopHeadlinesError) {
//                           return Center(
//                             child: Text(
//                               'Error: ${state.message}',
//                               style: const TextStyle(color: AppColors.red),
//                             ),
//                           );
//                         } else if (state is TopHeadlinesLoaded) {
//                           final articles = state.articles;
//                           return CustomCarouselSlider(
//                             articles: articles ?? [],
//                             request: const TopHedlinesBody(
//                               category: "business",
//                               page: 1,
//                               pageSize: 8,
//                             ),
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//                     SizedBox(height: size.height * 0.02),
//                     TitleHeadLineWidget(title: 'Recommendation', onTap: () {}),
//                     BlocBuilder<HomeCubit, HomeState>(
//                       bloc: homeCubit,
//                       buildWhen: (previous, current) =>
//                           current is RecommendedNewsLoading ||
//                           current is RecommendedNewsLoaded ||
//                           current is RecommendedNewsError,
//                       builder: (context, state) {
//                         if (state is RecommendedNewsLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator.adaptive(),
//                           );
//                         } else if (state is RecommendedNewsError) {
//                           return Center(
//                             child: Text(
//                               'Error: ${state.message}',
//                               style: const TextStyle(color: AppColors.red),
//                             ),
//                           );
//                         } else if (state is RecommendedNewsLoaded) {
//                           final articles = state.articles;
//                           return RecommendationListWidget(
//                             articles: articles ?? [],
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final HomeCubit _homeCubit;
  List<Article> _topHeadlines = [];
  List<Article> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit()
      ..getTopHeadlines()
      ..getRecommendationItems();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: _homeCubit,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: AppBarButton(
                onTap: () => _scaffoldKey.currentState!.openDrawer(),
                icon: Icons.menu,
              ),
            ),
            actions: [
              AppBarButton(
                onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                icon: Icons.search,
                hasPaddingBetween: true,
              ),
              AppBarButton(
                onTap: () {},
                icon: Icons.notifications_outlined,
                hasPaddingBetween: true,
              ),
            ],
          ),
          drawer: const AppDrawer(),

          // 🌐 هنا السحر
          body: BlocBuilder<NetworkCubit, NetworkState>(
            builder: (context, networkState) {
              if (networkState == NetworkState.disconnected) {
                return NoInternetView(
                  onRetry: () {
                    _homeCubit.getTopHeadlines();
                    _homeCubit.getRecommendationItems();
                  },
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildHomeContent(size),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          TitleHeadLineWidget(
            title: 'Breaking News',
            onTap: () {
              if (_topHeadlines.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No articles to show yet'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllArticlesPage(
                    title: 'Breaking News',
                    articles: _topHeadlines,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: size.height * 0.01),

          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (p, c) =>
                c is TopHeadlinesLoading ||
                c is TopHeadlinesLoaded ||
                c is TopHeadlinesError,
            builder: (context, state) {
              if (state is TopHeadlinesLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is TopHeadlinesError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppColors.red),
                  ),
                );
              } else if (state is TopHeadlinesLoaded) {
                _topHeadlines = state.articles ?? [];
                return CustomCarouselSlider(
                  articles: state.articles ?? [],
                  request: const TopHedlinesBody(
                    category: "business",
                    page: 1,
                    pageSize: 8,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          SizedBox(height: size.height * 0.02),
          TitleHeadLineWidget(
            title: 'Recommendation',
            onTap: () {
              if (_recommendations.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No articles to show yet'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllArticlesPage(
                    title: 'Recommendation',
                    articles: _recommendations,
                  ),
                ),
              );
            },
          ),

          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (p, c) =>
                c is RecommendedNewsLoading ||
                c is RecommendedNewsLoaded ||
                c is RecommendedNewsError,
            builder: (context, state) {
              if (state is RecommendedNewsLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is RecommendedNewsError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppColors.red),
                  ),
                );
              } else if (state is RecommendedNewsLoaded) {
                _recommendations = state.articles ?? [];
                return RecommendationListWidget(
                  articles: state.articles ?? [],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

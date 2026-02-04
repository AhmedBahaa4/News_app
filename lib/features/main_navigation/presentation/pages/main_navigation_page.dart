import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/bookmarks/pages/bookmark_page.dart';
import 'package:news_app/features/daily_brief/pages/daily_brief_page.dart';
import 'package:news_app/features/home/views/pages/home_page.dart';
import 'package:news_app/features/main_navigation/cubit/navigation_cubit.dart';
import 'package:news_app/features/main_navigation/presentation/widgets/bottom_nav_item.dart';
import 'package:news_app/features/profile/page/profile_page.dart';
import 'package:news_app/features/world/presentation/pages/world_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainNavigationCubit(),
      child: BottomNavBar(
        tabs: [
          PersistentTabConfig(
            screen: const HomePage(),
            item: ItemConfig(
              icon: const Icon(Icons.home_rounded),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: const DailyBriefPage(),
            item: ItemConfig(
              icon: const Icon(Icons.bolt_rounded),
              title: "Brief",
            ),
          ),
          PersistentTabConfig(
            screen: const WorldPage(),
            item: ItemConfig(
              icon: const Icon(Icons.public),
              title: "World",
            ),
          ),
          PersistentTabConfig(
            screen: const BookmarksPage(),
            item: ItemConfig(
              icon: const Icon(Icons.bookmark_rounded),
              title: "Bookmarks",
            ),
          ),
          PersistentTabConfig(
            screen: const ProfilePage(),
            item: ItemConfig(
              icon: const Icon(Icons.person_rounded),
              title: "Profile",
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/bookmarks/pages/bookmark_page.dart';
import 'package:news_app/features/home/views/pages/home_page.dart';
import 'package:news_app/features/profile/page/profile_page.dart';
import 'package:news_app/features/world/presentation/pages/world_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomePage(),
    BookmarksPage(),
    WorldPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      body: screens[currentIndex],

      bottomNavigationBar: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navItem(Icons.home_filled, 0, "Home"),
            navItem(Icons.public, 1, "Explore"),
            navItem(Icons.language, 2, "World"),
            navItem(Icons.person_outline, 3, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index, String label) {
    final bool selected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 18 : 0,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffe6f3ff) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: selected ? AppColors.primary : Colors.grey,
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

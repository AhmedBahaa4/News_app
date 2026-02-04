import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/main_navigation/cubit/navigation_cubit.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';



class BottomNavBar extends StatelessWidget {
  final List<PersistentTabConfig> tabs;

  const BottomNavBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigationCubit, int>(
      builder: (context, index) {
        return PersistentTabView(
          controller: PersistentTabController(initialIndex: index),
          tabs: tabs,
          navBarBuilder: (navBarConfig) => Style8BottomNavBar(
            navBarConfig: navBarConfig,
          ),
        );
      },
    );
  }
}

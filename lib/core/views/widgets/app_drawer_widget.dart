import 'package:flutter/material.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
// import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/drawerItemWidget.dart';
import 'package:news_app/core/views/widgets/drawer_item_widget.dart';
import 'package:news_app/core/views/widgets/drawer_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor:
          theme.drawerTheme.backgroundColor ?? colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppDrawerHeader(),
          const SizedBox(height: 30),

          DrawerItemWidget(
            title: 'Home',
            icon: Icons.home,
            isActive: true,
            onTap: () => Navigator.pop(context),
          ),

          DrawerItemWidget(
            title: 'World',
            icon: Icons.category,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.worldNews);
            },
          ),

          DrawerItemWidget(
            title: 'Bookmarks',
            icon: Icons.bookmark,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.bookmarks);
            },
          ),

          DrawerItemWidget(
            title: 'Profile',
            icon: Icons.person,
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),

          const SizedBox(height: 20),
          const DrawerThemeToggle(),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/cubit/them_cubit.dart';

class DrawerThemeToggle extends StatelessWidget {
  const DrawerThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                key: ValueKey(isDark),
                color: isDark
                    ? colorScheme.primary
                    : colorScheme.onSurface,
                size: size.width * 0.06,
              ),
            ),
            title: Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: colorScheme.primary,
              onChanged: (_) {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ),
        );
      },
    );
  }
}

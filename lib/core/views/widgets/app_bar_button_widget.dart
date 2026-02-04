import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool hasPaddingBetween;
  const AppBarButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.hasPaddingBetween = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white2,
        ),
        child: Padding(
          padding: EdgeInsets.all(hasPaddingBetween ? size.height * 0.01 : 0),
          child: Icon(icon, color: AppColors.black, size: 25),
        ),
      ),
    );
  }
}

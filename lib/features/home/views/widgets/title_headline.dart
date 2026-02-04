import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class TitleHeadLineWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const TitleHeadLineWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),),
        ),
        TextButton(
          onPressed: onTap,
          child: Text('View All', style: Theme.of(context).textTheme.bodyLarge ?.copyWith(color: AppColors.primary , fontWeight: FontWeight.w600) ),
        ),
      ],
    );
  }
}

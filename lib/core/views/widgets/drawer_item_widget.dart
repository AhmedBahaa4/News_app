// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';


class DrawerItemWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const DrawerItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<DrawerItemWidget> createState() => _DrawerItemWidgetState();
}

class _DrawerItemWidgetState extends State<DrawerItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final textColor = colorScheme.onSurface;
    final iconBg = widget.isActive
        ? colorScheme.primary.withOpacity(0.12)
        : colorScheme.surfaceVariant.withOpacity(0.08);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              color: widget.isActive ? activeColor : textColor,
              size: size.width * 0.05,
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: widget.isActive ? activeColor : textColor,
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w500,
            ),
          ),
          tileColor: widget.isActive
              ? colorScheme.primary.withOpacity(0.08)
              : colorScheme.surfaceVariant.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

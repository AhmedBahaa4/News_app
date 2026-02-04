// ignore_for_file: deprecated_member_use, always_put_control_body_on_new_line

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:news_app/core/utils/theme/app_colors.dart';

class AppDrawerHeader extends StatefulWidget {
  const AppDrawerHeader({super.key});

  @override
  State<AppDrawerHeader> createState() => _AppDrawerHeaderState();
}

class _AppDrawerHeaderState extends State<AppDrawerHeader> {
  late Future<Map<String, String?>> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _loadUser();
  }

  Future<Map<String, String?>> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final refreshed = FirebaseAuth.instance.currentUser;

    final prefs = await SharedPreferences.getInstance();
    final cachedAvatar = prefs.getString('last_avatar');
    final cachedName = prefs.getString('last_name');

    return {
      'name': cachedName ?? refreshed?.displayName,
      'email': refreshed?.email,
      'photo': cachedAvatar ?? refreshed?.photoURL,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<Map<String, String?>>(
      future: _futureUser,
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final fallbackUser = FirebaseAuth.instance.currentUser;
        final String userName = data['name'] ??
            (fallbackUser?.displayName ??
                (fallbackUser?.email != null
                    ? fallbackUser!.email!.split('@').first
                    : 'Guest'));
        final String? userEmail = data['email'] ?? fallbackUser?.email;
        final String? photoUrl = (data['photo'] ?? fallbackUser?.photoURL);

        final isDataImage =
            photoUrl != null && photoUrl.startsWith('data:image');

        return SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Background Image
              if (!isDataImage)
                CachedNetworkImage(
                  imageUrl: photoUrl ??
                      'https://images.unsplash.com/photo-1495020689067-958852a7765e',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: colorScheme.surface),
                  errorWidget: (_, __, ___) =>
                      Container(color: colorScheme.surface),
                )
              else
                Container(color: colorScheme.surface),

              /// Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              /// Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final avatarProvider = _drawerAvatar(photoUrl);
                        return CircleAvatar(
                          radius: 32,
                          backgroundColor: colorScheme.surface.withOpacity(0.7),
                          backgroundImage: avatarProvider,
                          child: avatarProvider == null
                              ? Icon(
                                  Icons.person,
                                  size: 32,
                                  color: colorScheme.onSurface,
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (userEmail != null)
                      Text(
                        userEmail,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                ),
                      ),
                  ],
                ),
              ),

              /// Logout Button
              Positioned(
                top: 16,
                right: 16,
                child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.9, end: 1),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              '/login',
                              (_) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

ImageProvider? _drawerAvatar(String? url) {
  if (url == null || url.isEmpty) return null;
  try {
    if (url.startsWith('data:image')) {
      final b64 = url.split(',').last;
      return MemoryImage(base64Decode(b64));
    }
    return NetworkImage(url);
  } catch (_) {
    return null;
  }
}

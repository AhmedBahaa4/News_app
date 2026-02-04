// ignore_for_file: deprecated_member_use, always_put_control_body_on_new_line

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/cubit/them_cubit.dart';

import '../../../core/services/user_service.dart';
import '../../auth/models/user_data.dart';
import '../../home/cubit/bookmark/bookmark_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../../daily_brief/pages/daily_brief_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfileCubit(context.read<UserService>())..loadProfile();
      },
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) => curr is ProfileLoggedOut,
        listener: (context, state) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded) {
                final user = state.user;

                return RefreshIndicator(
                  onRefresh: () => context.read<ProfileCubit>().loadProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _ProfileHeader(user: user),
                        const SizedBox(height: 12),
                        _StatsRow(),
                        const SizedBox(height: 12),
                        _QuickActions(onLogout: () {
                          context.read<ProfileCubit>().logout();
                        }),
                        const SizedBox(height: 12),
                        _Shortcuts(),
                        const SizedBox(height: 12),
                        _BookmarkSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserData user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.18),
            theme.colorScheme.secondary.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Builder(
                builder: (context) {
                  final avatarProvider = _avatarProvider(user.avatar);
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarProvider,
                    backgroundColor: theme.colorScheme.surface,
                    child: avatarProvider == null
                        ? Icon(
                            Icons.person,
                            size: 42,
                            color: theme.colorScheme.onSurface,
                          )
                        : null,
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: 
               const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 16, color: Colors.blue),
                SizedBox(width: 6),
                Text('Pro reader'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

ImageProvider? _avatarProvider(String avatar) {
  try {
    if (avatar.isNotEmpty && avatar.startsWith('data:image')) {
      final b64 = avatar.split(',').last;
      return MemoryImage(base64Decode(b64));
    }
    if (avatar.isNotEmpty) {
      return NetworkImage(avatar);
    }
  } catch (_) {
    // fall through to null result to show placeholder icon
  }
  return null;
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, bState) {
          final bookmarksCount =
              bState is BookmarkLoaded ? bState.bookmarks.length : 0;
          final cards = <_StatCardData>[
            _StatCardData(
              label: 'Bookmarks',
              value: '$bookmarksCount',
              icon: Icons.bookmark_rounded,
              color: Colors.blue,
            ),
            const _StatCardData(
              label: 'Daily brief',
              value: 'Today',
              icon: Icons.bolt_rounded,
              color: Colors.orange,
            ),
            const _StatCardData(
              label: 'Streak',
              value: '3 days',
              icon: Icons.local_fire_department_rounded,
              color: Colors.redAccent,
            ),
          ];

          return Row(
            children: [
              Expanded(child: _StatCard(data: cards[0])),
              const SizedBox(width: 8),
              Expanded(child: _StatCard(data: cards[1])),
              const SizedBox(width: 8),
              Expanded(child: _StatCard(data: cards[2])),
            ],
          );
        },
      ),
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onLogout;

  const _QuickActions({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final state = context.read<ProfileCubit>().state;
                if (state is! ProfileLoaded) return;
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      user: state.user,
                      service: context.read<UserService>(),
                    ),
                  ),
                );
                if (!context.mounted) {
                  return;
                }
                if (result is UserData) {
                  context.read<ProfileCubit>().loadProfile();
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcuts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _ShortcutTile(
            icon: Icons.bolt_rounded,
            label: 'Daily Brief',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DailyBriefPage()),
            ),
          ),
          _ShortcutTile(
            icon: Icons.chrome_reader_mode_outlined,
            label: 'Reader mode',
            color: Colors.blue,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open any article to use reader mode')),
              );
            },
          ),
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return _ShortcutTile(
                icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                label: isDark ? 'Light mode' : 'Dark mode',
                color: isDark ? Colors.indigo : Colors.amber,
                onTap: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
            _ShortcutTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bookmarks',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.bookmarks),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, bState) {
              if (bState is BookmarkLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (bState is BookmarkLoaded && bState.bookmarks.isNotEmpty) {
                final items = bState.bookmarks.take(5).toList();
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final b = items[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      tileColor: theme.cardColor,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: b.image.isNotEmpty
                            ? Image.network(
                                b.image,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.article_outlined),
                              ),
                      ),
                      title: Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        b.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.articleDetails,
                        arguments: b.toArticle(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            context.read<BookmarkCubit>().toggleBookmark(
                                  b.toArticle(),
                                ),
                      ),
                    );
                  },
                );
              }

              if (bState is BookmarkLoaded && bState.bookmarks.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_border,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'No bookmarks yet – start saving interesting reads.',
                        ),
                      ),
                    ],
                  ),
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

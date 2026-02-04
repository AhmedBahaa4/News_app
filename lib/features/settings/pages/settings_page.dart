// ignore_for_file: always_put_control_body_on_new_line, control_flow_in_finally, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/services/user_service.dart';
import 'package:news_app/features/profile/page/edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool dataSaver = false;
  bool _loadingEdit = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Personalization',
            children: [
              _SwitchTile(
                title: 'Notifications',
                subtitle: 'Breaking news & daily brief alerts',
                value: notificationsEnabled,
                onChanged: (v) => setState(() => notificationsEnabled = v),
              ),
              _SwitchTile(
                title: 'Data saver',
                subtitle: 'Load lower‑res images on mobile data',
                value: dataSaver,
                onChanged: (v) => setState(() => dataSaver = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Account',
            children: [
              _NavTile(
                icon: Icons.edit_outlined,
                title: 'Edit profile',
                subtitle: 'Name, avatar, email',
                onTap: _openEditProfile,
              ),
              _NavTile(
                icon: Icons.lock_outline,
                title: 'Privacy',
                subtitle: 'Permissions, data & security',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'About',
            children: [
              _NavTile(
                icon: Icons.info_outline,
                title: 'About app',
                subtitle: 'Version, licenses',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'News App',
                  applicationVersion: '1.0.0',
                ),
              ),
              _NavTile(
                icon: Icons.description_outlined,
                title: 'Terms of use',
                subtitle: 'Read terms & conditions',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms page coming soon')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditProfile() async {
    if (_loadingEdit) return;
    setState(() => _loadingEdit = true);
    try {
      final fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser == null) {
        throw Exception('Please log in first');
      }
      final token = await fbUser.getIdToken(true);
      final service = context.read<UserService>();
      final userData = await service.getProfile(token!);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfilePage(
            user: userData,
            service: service,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edit profile failed: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _loadingEdit = false;
      });
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: EdgeInsets.zero,
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: children,
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

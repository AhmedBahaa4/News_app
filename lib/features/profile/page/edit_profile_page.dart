// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/core/services/user_service.dart';
import 'package:news_app/features/auth/models/user_data.dart';

class EditProfilePage extends StatefulWidget {
  final UserData user;
  final UserService service;

  const EditProfilePage({
    super.key,
    required this.user,
    required this.service,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _avatarCtrl;
  bool _loading = false;
  XFile? _picked;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _avatarCtrl = TextEditingController(text: widget.user.avatar);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final token = await user.getIdToken(true);
      final avatarValue = _avatarCtrl.text.trim();
      final updated = await widget.service.updateProfile(
        token: token!,
        name: _nameCtrl.text.trim(),
        avatar: avatarValue,
      );

      await user.updateDisplayName(_nameCtrl.text.trim());
      // تجنب خطأ طول الرابط في Firebase عندما يكون Base64
      if (avatarValue.startsWith('data:image')) {
        await user.updatePhotoURL(null);
      } else {
        await user.updatePhotoURL(avatarValue);
      }
      await user.reload();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_avatar', avatarValue);
      await prefs.setString('last_name', _nameCtrl.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.pop(context, updated);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _avatarCtrl,
              decoration: InputDecoration(
                labelText: 'Avatar URL',
                prefixIcon: const Icon(Icons.image_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _pickImage,
                  tooltip: 'Pick from device',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _AvatarPreview(url: _avatarCtrl.text, picked: _picked),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _save,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_loading ? 'Saving...' : 'Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 900,
      );
      if (file == null) {
        return;
      }

      final bytes = await file.readAsBytes();
      final b64 = base64Encode(bytes);
      final mime = file.mimeType ?? 'image/jpeg';
      final dataUrl = 'data:$mime;base64,$b64';
      setState(() {
      _picked = file;
        _avatarCtrl.text = dataUrl;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick image: $e')),
      );
    }
  }
}

class _AvatarPreview extends StatelessWidget {
  final String url;
  final XFile? picked;
  const _AvatarPreview({required this.url, required this.picked});

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (picked != null) {
      image = FileImage(File(picked!.path));
    } else if (url.isNotEmpty) {
      if (url.startsWith('data:image')) {
        image = MemoryImage(base64Decode(url.split(',').last));
      } else {
        image = NetworkImage(url);
      }
    }

    if (image == null) {
      return const SizedBox.shrink();
    }

    return CircleAvatar(
      radius: 42,
      backgroundImage: image,
    );
  }
}

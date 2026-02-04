import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/core/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/features/auth/models/user_data.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserService userService;

  ProfileCubit(this.userService) : super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Not logged in');
      }

      // Show cached Firebase data immediately for faster UX
      final cachedUser = UserData(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? (user.email?.split('@').first ?? 'Guest'),
        avatar: user.photoURL ?? '',
        role: 'user',
        createdAt: '',
      );
      emit(ProfileLoaded(cachedUser));

      final token = await user.getIdToken(true);
      final userData = await userService.getProfile(token!);
      emit(ProfileLoaded(userData));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(ProfileLoggedOut());
  }
}

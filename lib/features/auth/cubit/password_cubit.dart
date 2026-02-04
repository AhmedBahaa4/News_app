

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(const PasswordVisibilityChanged(false));

  void toggleVisibility() {
    final currentVisibility = state is PasswordVisibilityChanged
        ? (state as PasswordVisibilityChanged).isVisible
        : false;

    emit(PasswordVisibilityChanged(!currentVisibility));
  }

  void showPassword() => emit(const PasswordVisibilityChanged(true));

  void hidePassword() => emit(const PasswordVisibilityChanged(false));

  void setError(String message) => emit(PasswordError(message));

  Future<void> sendResetLink(String email) async {
    emit(const PasswordLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );
      emit(const PasswordSuccess('Reset link sent. Check your inbox.'));
      emit(const PasswordVisibilityChanged(false)); // reset UI state
    } catch (e) {
      emit(PasswordFailure(e.toString()));
      emit(const PasswordVisibilityChanged(false));
    }
  }
}

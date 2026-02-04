part of 'password_cubit.dart';

sealed class PasswordState {
  const PasswordState();
}

final class PasswordVisibilityChanged extends PasswordState {
  final bool isVisible;
  const PasswordVisibilityChanged(this.isVisible);
}

final class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

final class PasswordSuccess extends PasswordState {
  final String message;
  const PasswordSuccess(this.message);
}

final class PasswordFailure extends PasswordState {
  final String error;
  const PasswordFailure(this.error);
}

final class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);
}

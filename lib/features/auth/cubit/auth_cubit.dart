


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/auth/models/user_data.dart';
import 'package:news_app/features/auth/utlis/api_path.dart';
import 'package:news_app/features/search/services/firestore_services.dart';
import 'package:news_app/core/services/auth_services.dart';
import 'package:news_app/core/services/user_service.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.userService) : super(AuthInitial());
  
  final AuthServices authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;
  final UserService userService;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await authServices.loginWithEmailAndPassword(
        email,
        password,
      );

      if (result) {
        await _syncUserWithBackend(strict: false);
        emit(AuthDone());
      } else {
        emit(AuthError(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
  String email,
  String password,
  String username,
) async {
  emit(AuthLoading());

  try {
    final result = await authServices.registerWithEmailAndPassword(
      email,
      password,
    );

    if (result) {
      await _saveUserData(email, username);
      await _syncUserWithBackend(strict: false);
      emit(AuthDone());
    } else {
      emit(AuthError(message: 'Register failed'));
    }
  } catch (e) {
    emit(AuthError(message: e.toString()));
  }
}


Future<void> _saveUserData(String email , String username) async{
  final currentUser = authServices.currentUser();
  final userData = UserData(
    uid: currentUser!.uid,
    email: email,
    name: username,
    avatar: '',
      role: 'user',
    createdAt: DateTime.now().toIso8601String(),
  );
  await firestoreServices.setData(
    path: ApiPath.users(currentUser.uid),
    data: userData.toMap(),
  );
}
  



  // void checkAuth() {
  //   final user = authServices.currentUser();

  //   if (user != null) {
  //     emit(AuthDone());
  //   }
  // }

  Future<void> checkAuth() async {
    final user = authServices.currentUser();

    if (user != null) {
      await _syncUserWithBackend();
      emit(AuthDone());
    } else {
      emit(AuthLoggedOut()); // ← لازم تكون موجودة
    }
  }


  Future<void> logout() async {
    emit(AuthloggingOut());
    try {
      await authServices.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> authWithGoogle() async {
    emit(AuthLoading());
    try {
      final result = await authServices.authWithGoogle();
      if (result) {
        await _syncUserWithBackend(strict: false);
        emit(AuthDone());
      } else {
        emit(AuthError(message: 'Google authentication failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> authWithFacebook() async {
    emit(FacebookAuthenticating());
    try {
      final result = await authServices.authWithFacebook();
      if (result) {
        await _syncUserWithBackend(strict: false);
        emit(FacebookAuthDone());
      } else {
        emit(FacebookAuthError(message: 'Facebook authentication failed'));
      }
    } catch (e) {
      emit(FacebookAuthError(message: e.toString()));
    }
  }

  Future<void> _syncUserWithBackend({bool strict = false}) async {
    final user = authServices.currentUser();
    if (user == null) {
      if (strict) {
        throw Exception('Not logged in');
      }
      return;
    }

    try {
      final token = await user.getIdToken(true);
      await userService.getProfile(token!);
    } catch (e) {
      if (strict) {
        rethrow;
      }
      // Non-strict: لا تمنع إكمال تسجيل الدخول إذا الـ API غير متاح
    }
  }
}


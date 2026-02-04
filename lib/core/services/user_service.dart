import 'package:dio/dio.dart';

import '../../features/auth/models/user_data.dart';


class UserService {
  final Dio dio;

  UserService(this.dio);

  // جلب بيانات المستخدم من الـ backend
  Future<UserData> getProfile(String token) async {
    final response = await dio.get(
      '/users/me',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return UserData.fromMap(response.data);
  }

  /// Update profile fields (e.g. name, avatar). Returns updated user.
  Future<UserData> updateProfile({
    required String token,
    required String name,
    required String avatar,
  }) async {
    final response = await dio.patch(
      '/users/me',
      data: {
        'name': name,
        'avatar': avatar,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return UserData.fromMap(response.data);
  }
}

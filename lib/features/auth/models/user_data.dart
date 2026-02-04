class UserData {
  final String uid;
  final String email;
  final String name;
  final String avatar;
  final String role;
  final String createdAt;

  UserData({
    required this.uid,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      avatar: map['avatar']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      createdAt: map['createdAt']?.toString() ?? '',
    );
  }
}

class AuthUser {
  final String id;
  final String email;
  final bool isAdmin;
  const AuthUser({required this.id, required this.email, required this.isAdmin});

  factory AuthUser.fromJson(Map<String, dynamic> j) =>
      AuthUser(id: j['id'].toString(), email: j['email'], isAdmin: (j['roles'] ?? []).contains('ADMIN'));
}

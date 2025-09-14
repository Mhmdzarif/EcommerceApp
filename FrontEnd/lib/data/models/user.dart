
class RegisterRequest {
	final String email;
	final String password;
	final String role;
	RegisterRequest(this.email, this.password, this.role);
}

class LoginRequest {
	final String email;
	final String password;
	LoginRequest(this.email, this.password);
}

class RegisterResponse {
	final String id;
	final String email;
	final String role;
	RegisterResponse(this.id, this.email, this.role);
	factory RegisterResponse.fromJson(Map<String, dynamic> j) => RegisterResponse(
		j['id'].toString(),
		j['email'],
		j['role'] ?? 'USER',
	);
}

class LoginResponse {
	final String token;
	final String role;
	LoginResponse(this.token, this.role);
	factory LoginResponse.fromJson(Map<String, dynamic> j) => LoginResponse(
		j['token'],
		j['role'] ?? 'USER',
	);
}

class RegisterRequest { final String email; final String password; RegisterRequest(this.email, this.password); }
class LoginRequest { final String email; final String password; LoginRequest(this.email, this.password); }

class RegisterResponse { final String id; final String email; RegisterResponse(this.id, this.email); factory RegisterResponse.fromJson(Map<String,dynamic> j)=>RegisterResponse(j['id'].toString(), j['email']); }
class LoginResponse { final String token; LoginResponse(this.token); factory LoginResponse.fromJson(Map<String,dynamic> j)=>LoginResponse(j['token']); }

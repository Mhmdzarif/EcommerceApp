namespace Ecommerce.Api.DTOs;

public record RegisterRequest(string Email, string Password, string Role);
public record LoginRequest(string Email, string Password);
public record AuthResponse(int Id, string Email, string Role, string Token);

using Ecommerce.Api.DTOs;
using Ecommerce.Api.Entities;
using Ecommerce.Api.Repositories;
using Ecommerce.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("auth")]
public class AuthController : ControllerBase
{
    private readonly IUserRepository _users;
    private readonly TokenService _tokens;

    public AuthController(IUserRepository users, TokenService tokens)
    {
        _users = users;
        _tokens = tokens;
    }

    [HttpPost("register")]
    public async Task<ActionResult<AuthResponse>> Register(RegisterRequest req)
    {
        var exists = await _users.GetByEmailAsync(req.Email);
        if (exists != null) return Conflict("Email already registered");

        var user = new User
        {
            Email = req.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(req.Password),
            Role = "USER"
        };

        user = await _users.AddAsync(user);
        var token = _tokens.CreateToken(user);

        return Created("", new AuthResponse(user.Id, user.Email, user.Role, token));
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResponse>> Login(LoginRequest req)
    {
        var user = await _users.GetByEmailAsync(req.Email);
        if (user == null) return Unauthorized("Invalid credentials");

        if (!BCrypt.Net.BCrypt.Verify(req.Password, user.PasswordHash))
            return Unauthorized("Invalid credentials");

        var token = _tokens.CreateToken(user);
        return Ok(new AuthResponse(user.Id, user.Email, user.Role, token));
    }
}

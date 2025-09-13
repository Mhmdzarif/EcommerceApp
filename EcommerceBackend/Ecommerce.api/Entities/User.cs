namespace Ecommerce.Api.Entities;

public class User
{
    public int Id { get; set; }
    public string Email { get; set; } = default!;
    public string PasswordHash { get; set; } = default!;
    public string Role { get; set; } = "USER"; // USER or ADMIN
    public List<Order> Orders { get; set; } = new();
}

using Ecommerce.Api.Data;
using Ecommerce.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce.Api.Services;

public class SeedService
{
    private readonly ApplicationDbContext _db;

    public SeedService(ApplicationDbContext db)
    {
        _db = db;
    }

    public async Task SeedAsync()
    {
        await _db.Database.MigrateAsync();

        if (!await _db.Users.AnyAsync())
        {
            _db.Users.AddRange(
                new User { Email = "admin@shop.com", Role = "ADMIN", PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!") },
                new User { Email = "user@shop.com", Role = "USER", PasswordHash = BCrypt.Net.BCrypt.HashPassword("User123!") }
            );
        }

        if (!await _db.Products.AnyAsync())
        {
            _db.Products.AddRange(
                new Product { Name = "Gaming Laptop", Price = 1999.99m, Stock = 5 },
                new Product { Name = "Smartphone", Price = 999.99m, Stock = 10 },
                new Product { Name = "Wireless Earbuds", Price = 149.99m, Stock = 25 }
            );
        }

        await _db.SaveChangesAsync();
    }
}

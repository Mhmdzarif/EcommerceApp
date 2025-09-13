using Ecommerce.Api.Data;
using Ecommerce.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce.Api.Repositories;

public class ProductRepository : IProductRepository
{
    private readonly ApplicationDbContext _db;
    public ProductRepository(ApplicationDbContext db) => _db = db;

    public Task<List<Product>> GetAllAsync() => _db.Products.AsNoTracking().ToListAsync();

    public Task<Product?> GetByIdAsync(int id) => _db.Products.FindAsync(id).AsTask();

    public async Task<Product> AddAsync(Product p)
    {
        _db.Products.Add(p);
        await _db.SaveChangesAsync();
        return p;
    }

    public async Task<Product?> UpdateAsync(Product p)
    {
        if (!await _db.Products.AnyAsync(x => x.Id == p.Id)) return null;
        _db.Products.Update(p);
        await _db.SaveChangesAsync();
        return p;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var p = await _db.Products.FindAsync(id);
        if (p == null) return false;
        _db.Products.Remove(p);
        await _db.SaveChangesAsync();
        return true;
    }

    public Task<List<Product>> GetLowStockAsync(int threshold) =>
        _db.Products.AsNoTracking().Where(p => p.Stock < threshold).ToListAsync();
}

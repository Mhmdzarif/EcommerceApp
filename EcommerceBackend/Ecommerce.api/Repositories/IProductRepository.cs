using Ecommerce.Api.Entities;

namespace Ecommerce.Api.Repositories;

public interface IProductRepository
{
    Task<List<Product>> GetAllAsync();
    Task<Product?> GetByIdAsync(int id);
    Task<Product> AddAsync(Product p);
    Task<Product?> UpdateAsync(Product p);
    Task<bool> DeleteAsync(int id);
    Task<List<Product>> GetLowStockAsync(int threshold);
}

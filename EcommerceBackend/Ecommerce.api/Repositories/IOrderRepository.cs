using Ecommerce.Api.Entities;

namespace Ecommerce.Api.Repositories;

public interface IOrderRepository
{
    Task<Order> CreateOrderAsync(int userId, List<(int productId, int quantity)> items);
    Task<List<Order>> GetMyOrdersAsync(int userId);
    Task<List<Order>> GetAllOrdersAsync();
}

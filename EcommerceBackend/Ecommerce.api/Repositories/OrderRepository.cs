using Ecommerce.Api.Data;
using Ecommerce.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce.Api.Repositories;

public class OrderRepository : IOrderRepository
{
    private readonly ApplicationDbContext _db;
    public OrderRepository(ApplicationDbContext db) => _db = db;

    public async Task<Order> CreateOrderAsync(int userId, List<(int productId, int quantity)> items)
    {
        using var tx = await _db.Database.BeginTransactionAsync();

        var productIds = items.Select(i => i.productId).ToList();
        var products = await _db.Products.Where(p => productIds.Contains(p.Id)).ToDictionaryAsync(p => p.Id);

        if (products.Count != productIds.Count)
            throw new InvalidOperationException("One or more products not found");

        var order = new Order { UserId = userId };

        decimal total = 0m;
        foreach (var (productId, qty) in items)
        {
            var p = products[productId];
            if (p.Stock < qty)
                throw new InvalidOperationException($"Insufficient stock for product {p.Name}");

            p.Stock -= qty;

            var lineTotal = p.Price * qty;
            total += lineTotal;

            order.Items.Add(new OrderItem
            {
                ProductId = productId,
                Quantity = qty,
                Price = p.Price
            });
        }

        order.Total = total;

        _db.Orders.Add(order);
        await _db.SaveChangesAsync();
        await tx.CommitAsync();

        return order;
    }

    public Task<List<Order>> GetMyOrdersAsync(int userId) =>
        _db.Orders.AsNoTracking()
            .Where(o => o.UserId == userId)
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync();

    public Task<List<Order>> GetAllOrdersAsync() =>
        _db.Orders.AsNoTracking()
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync();
}

using System.Security.Claims;
using Ecommerce.Api.DTOs;
using Ecommerce.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("")]
public class OrdersController : ControllerBase
{
    private readonly IOrderRepository _orders;
    private readonly IProductRepository _products;

    public OrdersController(IOrderRepository orders, IProductRepository products)
    {
        _orders = orders;
        _products = products;
    }

    private int CurrentUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ??
                                             User.FindFirstValue(ClaimTypes.NameIdentifier) ??
                                             User.FindFirstValue(ClaimTypes.Sid) ??
                                             throw new InvalidOperationException("No user id"));

    [Authorize]
    [HttpPost("orders")]
    public async Task<ActionResult> CreateOrder(CreateOrderRequest req)
    {
        try
        {
            var items = req.Items.Select(i => (i.ProductId, i.Quantity)).ToList();
            var order = await _orders.CreateOrderAsync(CurrentUserId(), items);
            return Created("", new { order.Id, order.Total, order.CreatedAt });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [Authorize]
    [HttpGet("orders/me")]
    public async Task<ActionResult<List<OrderSummaryResponse>>> MyOrders()
    {
        var orders = await _orders.GetMyOrdersAsync(CurrentUserId());
        return Ok(orders.Select(o => new OrderSummaryResponse(o.Id, o.CreatedAt, o.Total)));
    }

    [Authorize(Policy = "AdminOnly")]
    [HttpGet("admin/orders")]
    public async Task<ActionResult<List<OrderSummaryResponse>>> AllOrders()
    {
        var orders = await _orders.GetAllOrdersAsync();
        return Ok(orders.Select(o => new OrderSummaryResponse(o.Id, o.CreatedAt, o.Total)));
    }
}

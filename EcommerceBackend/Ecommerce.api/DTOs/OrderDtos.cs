namespace Ecommerce.Api.DTOs;

public record OrderItemRequest(int ProductId, int Quantity);
public record CreateOrderRequest(List<OrderItemRequest> Items);
public record OrderSummaryResponse(int Id, DateTime CreatedAt, decimal Total);

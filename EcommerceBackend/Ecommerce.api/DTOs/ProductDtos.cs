namespace Ecommerce.Api.DTOs;

public record CreateProductRequest(string Name, string? Description, decimal Price, int Stock, string? Thumbnail);
public record ProductResponse(int Id, string Name, string? Description, decimal Price, int Stock, string? Thumbnail);

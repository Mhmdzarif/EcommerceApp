using Ecommerce.Api.DTOs;
using Ecommerce.Api.Entities;
using Ecommerce.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("products")]
public class ProductsController : ControllerBase
{
    private readonly IProductRepository _repo;

    public ProductsController(IProductRepository repo) => _repo = repo;

    [HttpGet]
    public async Task<ActionResult<List<ProductResponse>>> GetAll()
    {
        var items = await _repo.GetAllAsync();
        return Ok(items.Select(p => new ProductResponse(p.Id, p.Name, p.Description, p.Price, p.Stock, p.Thumbnail)));
    }

    [Authorize(Policy = "AdminOnly")]
    [HttpPost]
    public async Task<ActionResult<ProductResponse>> Create(CreateProductRequest req)
    {
        var p = await _repo.AddAsync(new Product
        {
            Name = req.Name,
            Description = req.Description,
            Price = req.Price,
            Stock = req.Stock,
            Thumbnail = req.Thumbnail
        });
        return CreatedAtAction(nameof(GetAll), new { id = p.Id }, new ProductResponse(p.Id, p.Name, p.Description, p.Price, p.Stock, p.Thumbnail));
    }

    [Authorize(Policy = "AdminOnly")]
    [HttpGet("low-stock")]
    public async Task<ActionResult<List<ProductResponse>>> LowStock([FromQuery] int threshold = 5)
    {
        var items = await _repo.GetLowStockAsync(threshold);
        return Ok(items.Select(p => new ProductResponse(p.Id, p.Name, p.Description, p.Price, p.Stock, p.Thumbnail)));
    }
}

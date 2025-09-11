package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.ProductRequest;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.repository.ProductRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductService {
  private final ProductRepository repo;

  public ProductService(ProductRepository repo) {
    this.repo = repo;
  }

  public List<Product> getAll() {
    return repo.findAll();
  }

  public Product add(ProductRequest req) {
    Product p = new Product();
    p.setName(req.name);
    p.setDescription(req.description);
    p.setPrice(req.price);
    p.setStock(req.stock);
    p.setThumbnail(req.thumbnail);
    return repo.save(p);
  }

  public List<Product> lowStock(int threshold) {
    return repo.findByStockLessThan(threshold);
  }
}

package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.ProductRequest;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {
  private final ProductRepository productRepository;

  // used by ProductController.getAll()
  public List<Product> getAll() {
    return productRepository.findAll();
  }

  // used by ProductController.add()
  public Product add(ProductRequest req) {
    Product p = new Product();
    p.setName(req.getName());
    p.setDescription(req.getDescription());
    p.setPrice(req.getPrice());
    p.setStock(req.getStock());
    p.setThumbnail(req.getThumbnail());
    return productRepository.save(p);
  }

  // used by AdminController.lowStock()
  public List<Product> lowStock(int threshold) {
    return productRepository.findAll().stream()
      .filter(p -> p.getStock() < threshold)
      .collect(Collectors.toList());
  }
}

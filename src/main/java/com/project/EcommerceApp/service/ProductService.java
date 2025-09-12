package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.ProductRequest;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {

  private final ProductRepository productRepository;

  public Product createProduct(ProductRequest req) {
    Product p = new Product();
    // always use getters on the DTO
    p.setName(req.getName());
    p.setDescription(req.getDescription());
    p.setPrice(req.getPrice());
    p.setStock(req.getStock());
    p.setThumbnail(req.getThumbnail());
    return productRepository.save(p);
  }

  public List<Product> listAll() {
    return productRepository.findAll();
  }
}

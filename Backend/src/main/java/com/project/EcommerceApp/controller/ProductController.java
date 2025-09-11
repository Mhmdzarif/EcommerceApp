package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.dto.ProductRequest;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {

  private final ProductService productService;

  public ProductController(ProductService productService) {
    this.productService = productService;
  }

  @GetMapping
  public List<Product> all() {
    return productService.getAll();
  }

  @PostMapping
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<Product> add(@Valid @RequestBody ProductRequest req) {
    Product saved = productService.add(req);
    return ResponseEntity.status(201).body(saved);
  }
}

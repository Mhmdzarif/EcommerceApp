package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.dto.ProductRequest;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
  private final ProductService productService;

  @GetMapping
  public List<Product> getAll() {
    return productService.getAll();
  }

  @PostMapping
  public Product add(@Valid @RequestBody ProductRequest req) {
    return productService.add(req);
  }
}

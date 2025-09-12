package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.entity.Order;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.service.OrderService;
import com.project.EcommerceApp.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {
  private final OrderService orderService;
  private final ProductService productService;

  @GetMapping("/orders")
  public List<Order> allOrders() {
    return orderService.allOrders();
  }

  @GetMapping("/products/low-stock/{threshold}")
  public List<Product> lowStock(@PathVariable int threshold) {
    return productService.lowStock(threshold);
  }
}

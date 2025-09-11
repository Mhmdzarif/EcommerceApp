package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.entity.Order;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.service.OrderService;
import com.project.EcommerceApp.service.ProductService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

  private final OrderService orderService;
  private final ProductService productService;

  public AdminController(OrderService orderService, ProductService productService) {
    this.orderService = orderService;
    this.productService = productService;
  }

  @GetMapping("/orders")
  public List<Order> allOrders() {
    return orderService.allOrders();
  }

  @GetMapping("/low-stock")
  public List<Product> lowStock() {
    return productService.lowStock(5);
  }
}

package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.dto.OrderRequest;
import com.project.EcommerceApp.entity.Order;
import com.project.EcommerceApp.service.OrderService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {
  private final OrderService orderService;

  @PostMapping("/{userId}")
  public Order placeOrder(@PathVariable Long userId,
                          @Valid @RequestBody OrderRequest req) {
    return orderService.placeOrder(userId, req);
  }

  @GetMapping("/{userId}")
  public List<Order> myOrders(@PathVariable Long userId) {
    return orderService.myOrders(userId);
  }
}

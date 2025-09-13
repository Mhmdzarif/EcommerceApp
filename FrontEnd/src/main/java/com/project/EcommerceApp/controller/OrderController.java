package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.dto.OrderRequest;
import com.project.EcommerceApp.entity.Order;
import com.project.EcommerceApp.service.OrderService;
import com.project.EcommerceApp.service.UserFacade;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/orders")
public class OrderController {

  private final OrderService orderService;
  private final UserFacade userFacade;

  public OrderController(OrderService orderService, UserFacade userFacade) {
    this.orderService = orderService;
    this.userFacade = userFacade;
  }

  @PostMapping
  public ResponseEntity<Order> place(@Valid @RequestBody OrderRequest req, Authentication auth) {
    String email = ((org.springframework.security.core.userdetails.User) auth.getPrincipal()).getUsername();
    Long uid = userFacade.getUserIdByEmail(email);
    return ResponseEntity.status(201).body(orderService.placeOrder(uid, req));
  }

  @GetMapping("/me")
  public List<Order> myOrders(Authentication auth) {
    String email = ((org.springframework.security.core.userdetails.User) auth.getPrincipal()).getUsername();
    Long uid = userFacade.getUserIdByEmail(email);
    return orderService.myOrders(uid);
  }
}

package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.OrderRequest;
import com.project.EcommerceApp.entity.*;
import com.project.EcommerceApp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {
  private final OrderRepository orderRepository;
  private final UserRepository userRepository;
  private final ProductRepository productRepository;

  // used by OrderController.placeOrder()
  @Transactional
  public Order placeOrder(Long userId, OrderRequest req) {
    User user = userRepository.findById(userId)
      .orElseThrow(() -> new RuntimeException("User not found"));

    Order order = new Order();
    order.setUser(user);
    order.setCreatedAt(LocalDateTime.now());

    List<OrderItem> items = req.getItems().stream().map(itemReq -> {
      Product p = productRepository.findById(itemReq.getProductId())
        .orElseThrow(() -> new RuntimeException("Product not found"));
      OrderItem oi = new OrderItem();
      oi.setOrder(order);
      oi.setProduct(p);
      oi.setQuantity(itemReq.getQuantity());
      oi.setPrice(p.getPrice());
      return oi;
    }).toList();

    order.setItems(items);
    double total = items.stream()
      .mapToDouble(i -> i.getQuantity() * i.getPrice())
      .sum();
    order.setTotal(total);

    return orderRepository.save(order);
  }

  // used by OrderController.myOrders()
  public List<Order> myOrders(Long userId) {
    return orderRepository.findAllByUserId(userId);
  }

  // used by AdminController.allOrders()
  public List<Order> allOrders() {
    return orderRepository.findAll();
  }
}

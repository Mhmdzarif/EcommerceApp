package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.OrderRequest;
import com.project.EcommerceApp.entity.*;
import com.project.EcommerceApp.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class OrderService {
  private final OrderRepository orderRepo;
  private final OrderItemRepository itemRepo;
  private final ProductRepository productRepo;
  private final UserRepository userRepo;

  public OrderService(OrderRepository orderRepo, OrderItemRepository itemRepo,
                      ProductRepository productRepo, UserRepository userRepo) {
    this.orderRepo = orderRepo;
    this.itemRepo = itemRepo;
    this.productRepo = productRepo;
    this.userRepo = userRepo;
  }

  @Transactional
  public Order placeOrder(Long userId, OrderRequest req) {
    User user = userRepo.findById(userId).orElseThrow(() -> new NoSuchElementException("User not found"));

    // Load all products referenced
    Map<Long, Product> products = new HashMap<>();
    for (var item : req.items) {
      Product p = productRepo.findById(item.productId)
          .orElseThrow(() -> new NoSuchElementException("Product not found: " + item.productId));
      products.put(item.productId, p);
    }

    // Check stock first
    for (var item : req.items) {
      Product p = products.get(item.productId);
      if (p.getStock() < item.quantity) {
        throw new IllegalStateException("Insufficient stock for product id " + p.getId());
      }
    }

    // Decrement stock
    for (var item : req.items) {
      Product p = products.get(item.productId);
      p.setStock(p.getStock() - item.quantity);
      productRepo.save(p);
    }

    // Create order + items
    Order order = new Order();
    order.setUser(user);
    order.setCreatedAt(LocalDateTime.now());

    List<OrderItem> orderItems = new ArrayList<>();
    double total = 0.0;
    for (var item : req.items) {
      Product p = products.get(item.productId);
      OrderItem oi = new OrderItem();
      oi.setOrder(order);
      oi.setProduct(p);
      oi.setQuantity(item.quantity);
      oi.setUnitPrice(p.getPrice());
      orderItems.add(oi);
      total += p.getPrice() * item.quantity;
    }
    order.setItems(orderItems);
    order.setTotal(total);

    Order saved = orderRepo.save(order);
    itemRepo.saveAll(orderItems);
    return saved;
  }

  public List<Order> myOrders(Long userId) {
    return orderRepo.findByUserIdOrderByCreatedAtDesc(userId);
  }

  public List<Order> allOrders() {
    return orderRepo.findAll();
  }
}

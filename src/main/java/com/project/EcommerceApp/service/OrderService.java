package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.OrderRequest;
import com.project.EcommerceApp.entity.Order;
import com.project.EcommerceApp.entity.OrderItem;
import com.project.EcommerceApp.entity.Product;
import com.project.EcommerceApp.entity.User;
import com.project.EcommerceApp.repository.OrderRepository;
import com.project.EcommerceApp.repository.ProductRepository;
import com.project.EcommerceApp.repository.UserRepository;
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

  @Transactional
  public Order createOrder(String userEmail, OrderRequest req) {
    User user = userRepository.findByEmail(userEmail)
      .orElseThrow(() -> new RuntimeException("User not found"));

    Order order = new Order();
    order.setUser(user);
    order.setCreatedAt(LocalDateTime.now());

    List<OrderItem> items = req.getItems().stream()
      .map(itemReq -> {
        Product p = productRepository.findById(itemReq.getProductId())
          .orElseThrow(() -> new RuntimeException("Product not found"));
        OrderItem oi = new OrderItem();
        oi.setOrder(order);
        oi.setProduct(p);
        oi.setQuantity(itemReq.getQuantity());
        // set price on the item
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
}

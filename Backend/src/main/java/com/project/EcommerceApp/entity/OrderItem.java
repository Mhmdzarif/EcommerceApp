package com.project.EcommerceApp.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Entity
public class OrderItem {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  private Order order;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  private Product product;

  @Column(nullable = false)
  private int quantity;

  @Column(nullable = false)
  private double unitPrice; // snapshot of price at purchase time
}

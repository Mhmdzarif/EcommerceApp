package com.project.EcommerceApp.repository;

import com.project.EcommerceApp.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
  List<Product> findByStockLessThan(int threshold);
}

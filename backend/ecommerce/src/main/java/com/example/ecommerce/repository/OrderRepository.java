package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.ecommerce.model.Order;
import java.util.*;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findAllByOrderByIdDesc();
    List<Order> findByUserIdOrderByIdDesc(Long userId);
    List<Order> findByUserId(Long userId);
    
}

package com.example.ecommerce.repository;

import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.ProductVariant;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CartRepository extends JpaRepository<CartItem, Long> {

   Optional<CartItem> findByUserIdAndVariant(Long userId, ProductVariant variant); 
   List<CartItem> findByUserId(Long userId); 
   void deleteByUserId(Long userId);
}
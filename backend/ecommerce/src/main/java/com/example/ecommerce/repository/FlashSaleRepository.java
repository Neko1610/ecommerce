package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.ecommerce.model.FlashSale;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDateTime;
import java.util.List;

public interface FlashSaleRepository extends JpaRepository<FlashSale, Long> {

    @Query("SELECT f FROM FlashSale f WHERE f.active = true AND :now BETWEEN f.startTime AND f.endTime")
    List<FlashSale> findActive(LocalDateTime now);
}
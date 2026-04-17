package com.example.ecommerce.repository;

import com.example.ecommerce.model.FlashSaleItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDateTime;
import java.util.Optional;

public interface FlashSaleItemRepository extends JpaRepository<FlashSaleItem, Long> {

    @Query("""
        SELECT i FROM FlashSaleItem i
        WHERE i.variant.id = :variantId
        AND i.flashSale.active = true
        AND :now BETWEEN i.flashSale.startTime AND i.flashSale.endTime
    """)
    Optional<FlashSaleItem> findActiveByVariant(Long variantId, LocalDateTime now);
}
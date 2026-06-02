package com.example.ecommerce.repository;

import com.example.ecommerce.model.PaymentMethodEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PaymentMethodRepository extends JpaRepository<PaymentMethodEntity, Long> {
    List<PaymentMethodEntity> findByUserId(Long userId);

    List<PaymentMethodEntity> findByUserIdAndIsLinkedTrue(Long userId);
}

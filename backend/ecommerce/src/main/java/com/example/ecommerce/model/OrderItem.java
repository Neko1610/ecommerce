package com.example.ecommerce.model;

import jakarta.persistence.*;
import lombok.Data;


@Data
@Entity
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long variantId;
    private Long productId;
    private Double price;
    private int quantity;
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
}
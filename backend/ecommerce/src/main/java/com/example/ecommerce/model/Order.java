package com.example.ecommerce.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;
import lombok.Data;

@Entity
@Table(name = "orders")
@Data
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long userId;
    private String address;
    private String phone;
    private String paymentMethod;
    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<OrderItem> items;
    private Double subtotal;
    private Double discount;
    private Double total;

    private String status; // PENDING

    private LocalDateTime createdAt = LocalDateTime.now();
    
}
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

    private Double shippingFee;
    private Double distance;
    private Integer etaDays;

    private String status;

    private LocalDateTime createdAt = LocalDateTime.now();
}

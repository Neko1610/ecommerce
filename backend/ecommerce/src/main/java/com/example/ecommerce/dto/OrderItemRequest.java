package com.example.ecommerce.dto;

import lombok.Data;

@Data
public class OrderItemRequest {
    private Long variantId;
    private int quantity;
}
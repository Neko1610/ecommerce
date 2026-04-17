package com.example.ecommerce.dto;

import lombok.Data;

@Data
public class FlashSaleItemRequest {
    private Long flashSaleId;
    private Long variantId;
    private double flashPrice;
    private int quantity;
}

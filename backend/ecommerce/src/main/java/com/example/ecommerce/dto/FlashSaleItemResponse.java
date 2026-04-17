package com.example.ecommerce.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FlashSaleItemResponse {
    private Long id;
    private Long flashSaleId;
    private Long variantId;
    private double flashPrice;
    private int quantity;
    private int sold;
}

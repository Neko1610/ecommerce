package com.example.ecommerce.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FlashSaleRequest {
    private String name;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Boolean active;
}

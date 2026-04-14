package com.example.ecommerce.dto;

import lombok.Data;

@Data
public class ProductRequest {

    private String name;
    private String image;
    private Long categoryId;
}
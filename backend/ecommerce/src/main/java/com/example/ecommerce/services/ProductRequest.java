package com.example.ecommerce.services;

import lombok.Data;

@Data
public class ProductRequest {

    private String name;
    private String image;
    private Long categoryId;
}
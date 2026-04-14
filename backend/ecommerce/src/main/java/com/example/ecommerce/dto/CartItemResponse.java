package com.example.ecommerce.dto;


import lombok.Data;

@Data
public class CartItemResponse {

    private Long id;
    private int quantity;

    private Long variantId;
    private String productName;
    private String productImage;

    private String color;
    private String size;

    private double price;
    private int stock;
}
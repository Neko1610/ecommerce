package com.example.ecommerce.dto;


public class CartItemResponse {

    private Long id;
    private int quantity;   
    private Long userId;
    private VariantResponse variant;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public VariantResponse getVariant() {
        return variant;
    }

    public void setVariant(VariantResponse variant) {
        this.variant = variant;
    }
}
package com.example.ecommerce.dto;

public class CartRequest {
    private Long userId;
    private Long variantId;
    private int quantity;

    public Long getUserId() {
        return userId;
    }

    public Long getVariantId() {
        return variantId;
    }

    public void setUserId(Long userId ) {
        this.userId = userId;
    }

    public void setVariantId(Long variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
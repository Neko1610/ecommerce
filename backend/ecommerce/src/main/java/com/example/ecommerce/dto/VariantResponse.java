package com.example.ecommerce.dto;

import lombok.Data;
import java.util.List;

@Data
public class VariantResponse {
    private Long id;
    private String size;
    private String color;
    private double price;
    private Double oldPrice;
    private int stock;
    private String image;
    private ProductDetailResponse product;
    private List<String> images;

    public ProductDetailResponse getProduct() {
    return product;
}

public void setProduct(ProductDetailResponse product) {
    this.product = product;
}
}

package com.example.ecommerce.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class ProductDetailResponse {
    private Long id;
    private String name;
    private String description;
    private Double price;
    private Double oldPrice;
    private String image;

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
       private List<VariantResponse> variants = new ArrayList<>();
}
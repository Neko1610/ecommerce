package com.example.ecommerce.dto;

import lombok.Data;
import java.util.ArrayList;
import java.util.List;

@Data
public class ProductDetailResponse {

    private Long id;
    private String name;
    private String description;

    private Double minPrice;
    private Double maxPrice;

    private String image;

    private List<VariantResponse> variants = new ArrayList<>();
}
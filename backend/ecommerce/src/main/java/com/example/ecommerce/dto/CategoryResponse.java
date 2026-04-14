package com.example.ecommerce.dto;

import java.util.List;

import lombok.Data;

@Data
public class CategoryResponse {
    private Long id;
    private String name;
    private String banner;
    private List<CategoryResponse> children;
}

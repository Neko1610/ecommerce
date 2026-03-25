package com.example.ecommerce.dto;

import lombok.Data;
import java.util.List;

@Data
public class OrderListResponse {

    private Long id;
    private String status;
    private Double total;
    private String createdAt;

    private List<String> images;
    private String title;
}
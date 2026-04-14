package com.example.ecommerce.dto;

import lombok.*;

@Data
public class UpdateProfileRequest {
    private String fullName;
    private String phone;
    private String avatar;
}
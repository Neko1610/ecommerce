package com.example.ecommerce.dto;
import lombok.*;
@Data
public class AddressRequest {
    private String fullAddress;
    private Double latitude;
    private Double longitude;
    private boolean isDefault;
    private String label;
}
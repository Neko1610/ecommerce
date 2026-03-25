package com.example.ecommerce.dto;

import lombok.Data;
import java.util.List;

@Data
public class OrderRequest {
    private String address;
    private String phone;
    private String paymentMethod;
    private String voucherCode;
    private List<OrderItemRequest> items;
    private double shippingFee;
    
}
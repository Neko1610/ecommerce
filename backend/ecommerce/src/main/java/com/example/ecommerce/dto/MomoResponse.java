package com.example.ecommerce.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MomoResponse {

    private String payUrl;

    private String qrCodeUrl;

    private String deeplink;

    private String orderId;

    private String requestId;

    private Integer resultCode;

    private String message;
}
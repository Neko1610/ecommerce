package com.example.ecommerce.services;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.ecommerce.dto.MomoResponse;
import com.example.ecommerce.Utils.HmacUtils;

@Service
public class MomoService {

    @Value("${momo.partner-code}")
    private String partnerCode;

    @Value("${momo.access-key}")
    private String accessKey;

    @Value("${momo.secret-key}")
    private String secretKey;

    @Value("${momo.endpoint}")
    private String endpoint;

    @Value("${momo.redirect-url}")
    private String redirectUrl;

    @Value("${momo.ipn-url}")
    private String ipnUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public MomoResponse createPayment(
            Long amount) {

        try {

            String orderId = partnerCode +
                    System.currentTimeMillis();

            String requestId = orderId;

            String orderInfo = "Thanh toan don hang";

            String requestType = "payWithMethod";

            String extraData = "";

            String rawHash = "accessKey=" + accessKey +
                    "&amount=" + amount +
                    "&extraData=" + extraData +
                    "&ipnUrl=" + ipnUrl +
                    "&orderId=" + orderId +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + partnerCode +
                    "&redirectUrl=" + redirectUrl +
                    "&requestId=" + requestId +
                    "&requestType=" + requestType;

            String signature = HmacUtils.signSHA256(
                    rawHash,
                    secretKey);

            Map<String, Object> body = new HashMap<>();

            body.put("partnerCode", partnerCode);

            body.put("partnerName", "Test");

            body.put("storeId", "MomoTestStore");

            body.put("requestId", requestId);

            body.put("amount",
                    amount.toString());

            body.put("orderId", orderId);

            body.put("orderInfo",
                    orderInfo);

            body.put("redirectUrl",
                    redirectUrl);

            body.put("ipnUrl",
                    ipnUrl);

            body.put("lang", "vi");

            body.put("requestType",
                    requestType);

            body.put("autoCapture",
                    true);

            body.put("extraData",
                    extraData);

            body.put("signature",
                    signature);

            HttpHeaders headers = new HttpHeaders();

            headers.setContentType(
                    MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(
                    body,
                    headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    endpoint,
                    HttpMethod.POST,
                    entity,
                    Map.class);

            Map<String, Object> responseBody = response.getBody();

            return MomoResponse.builder()
                    .payUrl(
                            (String) responseBody.get("payUrl"))
                    .qrCodeUrl(
                            (String) responseBody.get("qrCodeUrl"))
                    .deeplink(
                            (String) responseBody.get("deeplink"))
                    .orderId(orderId)
                    .requestId(requestId)
                    .resultCode(
                            (Integer) responseBody.get("resultCode"))
                    .message(
                            (String) responseBody.get("message"))
                    .build();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Create momo payment failed: "
                            + e.getMessage());
        }
    }
}
package com.example.ecommerce.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.ecommerce.dto.MomoCreateRequest;
import com.example.ecommerce.dto.MomoResponse;
import com.example.ecommerce.services.MomoService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/momo")
@RequiredArgsConstructor
public class MomoController {

    private final MomoService momoService;

    @PostMapping("/create")
    public ResponseEntity<MomoResponse>
    createPayment(
            @RequestBody
            MomoCreateRequest request
    ) {

        MomoResponse response =
                momoService.createPayment(
                        request.getAmount()
                );

        return ResponseEntity.ok(response);
    }

    @PostMapping("/ipn")
    public ResponseEntity<?> momoIpn(
            @RequestBody Map<String, Object> body
    ) {

        System.out.println(
                "MOMO IPN: " + body
        );

        // TODO:
        // update order paid

        return ResponseEntity.ok().build();
    }

    @GetMapping("/test")
    public String test() {
        return "Momo API Running";
    }
}
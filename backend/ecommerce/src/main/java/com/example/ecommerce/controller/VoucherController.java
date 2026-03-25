package com.example.ecommerce.controller;

import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.services.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/voucher")
@CrossOrigin
public class VoucherController {

    @Autowired
    private VoucherService service;

    @PostMapping("/apply")
    public Voucher apply(@RequestBody Map<String, Object> body) {

        String code = body.get("code").toString();
        double subtotal = Double.parseDouble(body.get("subtotal").toString());

        return service.applyVoucher(code, subtotal);
    }
}
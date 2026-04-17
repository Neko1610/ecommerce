package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.dto.FlashSaleItemRequest;
import com.example.ecommerce.dto.FlashSaleItemResponse;
import com.example.ecommerce.dto.FlashSaleRequest;
import com.example.ecommerce.dto.FlashSaleResponse;
import com.example.ecommerce.services.FlashSaleService;
import com.example.ecommerce.services.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminFlashSaleController {

    private final FlashSaleService flashSaleService;
    private final UserService userService;

    @PostMapping("/flash-sales")
    public FlashSaleResponse createFlashSale(@RequestBody FlashSaleRequest request) {
        userService.requireAdmin();
        return flashSaleService.createFlashSale(request);
    }

    @PostMapping("/flash-sale-items")
    public FlashSaleItemResponse createFlashSaleItem(@RequestBody FlashSaleItemRequest request) {
        userService.requireAdmin();
        return flashSaleService.createFlashSaleItem(request);
    }

    @GetMapping("/flash-sales")
    public List<FlashSaleResponse> getFlashSales() {
        userService.requireAdmin();
        return flashSaleService.getAllFlashSales();
    }
}

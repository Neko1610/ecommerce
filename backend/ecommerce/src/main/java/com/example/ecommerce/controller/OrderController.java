package com.example.ecommerce.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.example.ecommerce.services.OrderService;

import java.util.List;
import lombok.RequiredArgsConstructor;

import com.example.ecommerce.dto.OrderListResponse;
import com.example.ecommerce.dto.OrderRequest;


@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

   @PostMapping("/checkout")
    public ResponseEntity<?> checkout(@RequestBody OrderRequest request) {

        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        orderService.checkoutByEmail(email, request);

        return ResponseEntity.ok("Order success");
    }
    @GetMapping
    public List<OrderListResponse> getOrders() {

        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return orderService.getOrdersByEmail(email);
}
    @GetMapping("/{id}")
    public ResponseEntity<?> getDetail(@PathVariable Long id) {

        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return ResponseEntity.ok(orderService.getDetailByEmail(email, id));
    }
 
}
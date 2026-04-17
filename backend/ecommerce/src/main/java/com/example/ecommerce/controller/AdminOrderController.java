package com.example.ecommerce.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.dto.OrderListResponse;
import com.example.ecommerce.dto.OrderStatusUpdateRequest;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.services.OrderService;
import com.example.ecommerce.services.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/orders")
@RequiredArgsConstructor
public class AdminOrderController {

    private final OrderService orderService;
    private final UserService userService;

    @GetMapping
    public List<OrderListResponse> getOrders() {
        userService.requireAdmin();
        return orderService.getAllOrdersForAdmin();
    }

    @GetMapping("/{id}")
    public Map<String, Object> getOrderDetail(@PathVariable Long id) {
        userService.requireAdmin();
        return orderService.getDetailForAdmin(id);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Order> updateStatus(
            @PathVariable Long id,
            @RequestBody OrderStatusUpdateRequest request) {
        userService.requireAdmin();
        return ResponseEntity.ok(orderService.updateOrderStatus(id, request.getStatus()));
    }
}

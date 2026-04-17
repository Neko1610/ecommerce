package com.example.ecommerce.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.services.UserService;
import com.example.ecommerce.services.VoucherService;

@RestController
@CrossOrigin
public class VoucherController {

    @Autowired
    private VoucherService service;

    @Autowired
    private UserService userService;

    @GetMapping("/api/admin/vouchers")
    public List<Voucher> getAll() {
        userService.requireAdmin();
        return service.getAll();
    }

    @GetMapping("/api/vouchers")
    public List<Voucher> getPublicVouchers() {
        return service.getAll(); // hoặc getAll()
    }

    @GetMapping("/api/admin/vouchers/{id}")
    public Voucher getById(@PathVariable Long id) {
        userService.requireAdmin();
        return service.getById(id);
    }

    @PostMapping("/api/admin/vouchers")
    public Voucher create(@RequestBody Voucher voucher) {
        userService.requireAdmin();
        return service.create(voucher);
    }

    @PutMapping("/api/admin/vouchers/{id}")
    public Voucher update(@PathVariable Long id, @RequestBody Voucher voucher) {
        userService.requireAdmin();
        return service.update(id, voucher);
    }

    @DeleteMapping("/api/admin/vouchers/{id}")
    public void delete(@PathVariable Long id) {
        userService.requireAdmin();
        service.delete(id);
    }

    @PostMapping("/api/vouchers/apply")
    public Voucher apply(@RequestBody Map<String, Object> body) {
        String code = body.get("code").toString();
        double subtotal = Double.parseDouble(body.get("subtotal").toString());
        return service.applyVoucher(code, subtotal);
    }
}

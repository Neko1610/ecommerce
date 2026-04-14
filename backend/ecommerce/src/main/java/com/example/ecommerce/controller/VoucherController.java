package com.example.ecommerce.controller;

import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.services.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/vouchers")
@CrossOrigin
public class VoucherController {

    @Autowired
    private VoucherService service;

    // ✅ GET ALL
    @GetMapping
    public List<Voucher> getAll() {
        return service.getAll();
    }

    // ✅ GET BY ID
    @GetMapping("/{id}")
    public Voucher getById(@PathVariable Long id) {
        return service.getById(id);
    }

    // ✅ CREATE
    @PostMapping
    public Voucher create(@RequestBody Voucher voucher) {
        return service.create(voucher);
    }

    // ✅ UPDATE (FULL UPDATE)
    @PutMapping("/{id}")
    public Voucher update(@PathVariable Long id, @RequestBody Voucher v) {
        return service.update(id, v);
    }

    // ✅ DELETE
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }

    // ✅ APPLY VOUCHER
    @PostMapping("/apply")
    public Voucher apply(@RequestBody Map<String, Object> body) {
        String code = body.get("code").toString();
        double subtotal = Double.parseDouble(body.get("subtotal").toString());
        return service.applyVoucher(code, subtotal);
    }
}
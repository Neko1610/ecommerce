package com.example.ecommerce.services;

import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.repository.VoucherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class VoucherService {

    @Autowired
    private VoucherRepository repo;

    public Voucher applyVoucher(String code, double subtotal) {

        Voucher v = repo.findByCode(code)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));

        if (!v.isActive()) {
            throw new RuntimeException("Voucher is inactive");
        }

        if (v.getExpiryDate().isBefore(LocalDate.now())) {
            throw new RuntimeException("Voucher expired");
        }

        if (subtotal < v.getMinOrder()) {
            throw new RuntimeException("Minimum order not reached");
        }

        return v;
    }
}
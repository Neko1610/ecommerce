package com.example.ecommerce.services;

import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.repository.VoucherRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class VoucherService {

    private final VoucherRepository repository;

    public VoucherService(VoucherRepository repository) {
        this.repository = repository;
    }

    // ✅ GET ALL
    public List<Voucher> getAll() {
        return repository.findAll();
    }

    // ✅ GET BY ID
    public Voucher getById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));
    }

    // ✅ CREATE
    public Voucher create(Voucher v) {
        return repository.save(v);
    }

    // ✅ UPDATE (QUAN TRỌNG)
    public Voucher update(Long id, Voucher v) {
        Voucher existing = getById(id);

        existing.setCode(v.getCode());
        existing.setDiscountPercent(v.getDiscountPercent());
        existing.setExpiryDate(v.getExpiryDate());
        existing.setMinOrder(v.getMinOrder());
        existing.setActive(v.isActive());

        return repository.save(existing);
    }

    // ✅ DELETE
    public void delete(Long id) {
        repository.deleteById(id);
    }

    // ✅ APPLY VOUCHER
    public Voucher applyVoucher(String code, double subtotal) {
        Voucher v = repository.findByCode(code)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));

        if (!v.isActive())
            throw new RuntimeException("Voucher is inactive");

        if (subtotal < v.getMinOrder())
            throw new RuntimeException("Minimum order not reached");

        if (v.getExpiryDate().isBefore(LocalDate.now()))
            throw new RuntimeException("Voucher expired");

        return v;
    }
}
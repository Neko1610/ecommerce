package com.example.ecommerce.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "voucher")
public class Voucher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String code;

    private double discountPercent;

    private LocalDate expiryDate;

    private double minOrder;

    private boolean active;

    // ===== CONSTRUCTOR =====
    public Voucher() {}

    public Voucher(String code, double discountPercent, LocalDate expiryDate, double minOrder, boolean active) {
        this.code = code;
        this.discountPercent = discountPercent;
        this.expiryDate = expiryDate;
        this.minOrder = minOrder;
        this.active = active;
    }

    // ===== GETTER / SETTER =====

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public double getMinOrder() {
        return minOrder;
    }

    public void setMinOrder(double minOrder) {
        this.minOrder = minOrder;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
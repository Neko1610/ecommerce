package com.example.ecommerce.controller;

import com.example.ecommerce.model.PaymentMethodEntity;
import com.example.ecommerce.services.PaymentMethodService;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
public class PaymentMethodController {

    private final PaymentMethodService service;

    public PaymentMethodController(
            PaymentMethodService service
    ) {
        this.service = service;
    }

    @GetMapping
    public List<PaymentMethodEntity> getAll(
            Authentication authentication
    ) {

        return service.getAllByUser(
                authentication.getName()
        );
    }

    @PostMapping
    public PaymentMethodEntity add(
            @RequestBody PaymentMethodEntity payment,
            Authentication authentication
    ) {

        return service.addMethod(
                payment,
                authentication.getName()
        );
    }

    @PutMapping("/{id}")
    public PaymentMethodEntity update(
            @PathVariable Long id,
            @RequestBody PaymentMethodEntity payment
    ) {

        return service.updateMethod(
                id,
                payment
        );
    }

    @DeleteMapping("/{id}")
    public void delete(
            @PathVariable Long id
    ) {

        service.deleteMethod(id);
    }

    @PutMapping("/default/{id}")
    public void setDefault(
            @PathVariable Long id
    ) {

        service.setDefault(id);
    }

    @PutMapping("/unlink/{id}")
    public void unlink(
            @PathVariable Long id
    ) {

        service.unlinkMethod(id);
    }
}
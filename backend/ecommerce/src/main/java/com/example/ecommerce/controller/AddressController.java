package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.dto.AddressRequest;
import com.example.ecommerce.model.Address;
import com.example.ecommerce.services.AddressService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/address")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService service;

    private String getEmail() {
        return SecurityContextHolder.getContext()
                .getAuthentication()
                .getName();
    }

    @GetMapping
    public List<Address> getAll() {
        return service.getMyAddress(getEmail());
    }

    @GetMapping("/default")
    public Address getDefault() {
        return service.getDefault(getEmail());
    }

    @PostMapping
    public Address create(@RequestBody AddressRequest req) {
        return service.create(req, getEmail());
    }

    @PutMapping("/{id}")
    public Address update(@PathVariable Long id,
                          @RequestBody AddressRequest req) {
        return service.update(id, req, getEmail());
    }

    @PutMapping("/{id}/default")
    public void setDefault(@PathVariable Long id) {
        service.setDefault(id, getEmail());
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id, getEmail());
    }
}
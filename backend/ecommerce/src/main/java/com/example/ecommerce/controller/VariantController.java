package com.example.ecommerce.controller;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.ProductRepository;
import com.example.ecommerce.repository.ProductVariantRepository;
import com.example.ecommerce.services.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/variants")
@RequiredArgsConstructor
public class VariantController {

    private final ProductVariantRepository variantRepository;
    private final ProductRepository productRepository;
    private final UserService userService;

    @PutMapping("/{id}")
    public ProductVariant updateVariant(@PathVariable Long id, @RequestBody ProductVariant request) {
        userService.requireAdmin();

        ProductVariant variant = variantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Variant not found"));

        variant.setSize(request.getSize());
        variant.setColor(request.getColor());
        variant.setPrice(request.getPrice());
        variant.setOldPrice(request.getOldPrice());
        variant.setStock(request.getStock());
        variant.setImage(request.getImage());

        if (request.getProduct() != null && request.getProduct().getId() != null) {
            Product product = productRepository.findById(request.getProduct().getId())
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            variant.setProduct(product);
        }

        return variantRepository.save(variant);
    }

    @DeleteMapping("/{id}")
    public void deleteVariant(@PathVariable Long id) {
        userService.requireAdmin();
        variantRepository.deleteById(id);
    }
}

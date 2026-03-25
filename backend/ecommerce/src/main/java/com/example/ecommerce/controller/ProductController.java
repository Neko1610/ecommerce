package com.example.ecommerce.controller;

import com.example.ecommerce.dto.ProductDetailResponse;
import com.example.ecommerce.dto.VariantResponse;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.ProductImageRepository;
import com.example.ecommerce.repository.ProductRepository;
import com.example.ecommerce.repository.ProductVariantRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    @Autowired
    private ProductRepository productRepo;

    @Autowired
    private ProductVariantRepository variantRepo;

    @Autowired
    private ProductImageRepository imageRepo;

@GetMapping
public List<ProductDetailResponse> getAll() {
    List<Product> products = productRepo.findAll();

    return products.stream().map(p -> {

        List<ProductVariant> variants = variantRepo.findByProductId(p.getId());

        String image = "";

        if (!variants.isEmpty()) {
            List<String> images = imageRepo.findByVariantId(variants.get(0).getId())
                    .stream()
                    .map(img -> img.getImageUrl())
                    .toList();

            if (!images.isEmpty()) {
                image = images.get(0);
            }
        }

        ProductDetailResponse res = new ProductDetailResponse();
        res.setId(p.getId());
        res.setName(p.getName());
        res.setDescription(p.getDescription());

        res.setPrice(p.getPrice() != null ? p.getPrice() : 0);
        res.setOldPrice(p.getOldPrice());
        res.setImage(image);

        // 🔥 THÊM ĐOẠN NÀY
        List<VariantResponse> variantResponses = variants.stream().map(v -> {

            VariantResponse vr = new VariantResponse();
            vr.setId(v.getId());
            vr.setSize(v.getSize());
            vr.setColor(v.getColor());
            vr.setPrice(v.getPrice());
            vr.setStock(v.getStock());

            List<String> images = imageRepo.findByVariantId(v.getId())
                    .stream()
                    .map(img -> img.getImageUrl())
                    .toList();

            vr.setImages(images);

            return vr;

        }).toList();

        res.setVariants(variantResponses); // 🔥 QUAN TRỌNG

        return res;

    }).toList();
}

    @PostMapping
    public Product create(@RequestBody Product p) {
        return productRepo.save(p);
    }

    @GetMapping("/{id}/variants")
    public List<ProductVariant> getVariants(@PathVariable Long id) {
        return variantRepo.findByProductId(id);
    }

    @PostMapping("/variant")
    public ProductVariant addVariant(@RequestBody ProductVariant v) {
        return variantRepo.save(v);
    }

    @GetMapping("/{id}")
    public ProductDetailResponse getDetail(@PathVariable Long id) {

        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        List<ProductVariant> variants = variantRepo.findByProductId(id);

        ProductDetailResponse res = new ProductDetailResponse();
        res.setId(product.getId());
        res.setName(product.getName());
        res.setDescription(product.getDescription());

        /// 💰 PRICE
        res.setPrice(
            product.getPrice() != null ? product.getPrice() : 0
        );

        res.setOldPrice(product.getOldPrice());

        /// 🔁 VARIANTS
        List<VariantResponse> variantResponses = variants.stream().map(v -> {

            VariantResponse vr = new VariantResponse();
            vr.setId(v.getId());
            vr.setSize(v.getSize());
            vr.setColor(v.getColor());
            vr.setPrice(v.getPrice());
            vr.setStock(v.getStock());

            /// 🖼 IMAGES
            List<String> images = imageRepo.findByVariantId(v.getId())
                    .stream()
                    .map(img -> img.getImageUrl())
                    .toList();

            vr.setImages(images);

            return vr;

        }).toList();

        res.setVariants(variantResponses);

        return res;
    }
}
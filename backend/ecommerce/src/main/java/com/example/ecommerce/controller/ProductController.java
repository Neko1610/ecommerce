package com.example.ecommerce.controller;

import com.example.ecommerce.dto.ProductDetailResponse;
import com.example.ecommerce.dto.VariantResponse;
import com.example.ecommerce.model.Category;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.CategoryRepository;
import com.example.ecommerce.repository.ProductImageRepository;
import com.example.ecommerce.repository.ProductRepository;
import com.example.ecommerce.repository.ProductVariantRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

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

    @Autowired
    private CategoryRepository categoryRepo;

    // =========================
    // GET ALL / FILTER / SEARCH
    // =========================
    @GetMapping
    public List<ProductDetailResponse> getAll(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword) {

        List<Product> products;

        if (categoryId != null) {

            Category category = categoryRepo.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));

            if (category.getParent() == null) {

                List<Long> subIds = categoryRepo.findByParentId(categoryId)
                        .stream()
                        .map(Category::getId)
                        .collect(Collectors.toList());

                products = productRepo.findByCategoryIdIn(subIds);

            } else {
                products = productRepo.findByCategoryId(categoryId);
            }

        } else {
            products = productRepo.findAll();
        }

        // ðŸ” SEARCH
        if (keyword != null && !keyword.isEmpty()) {
            String lower = keyword.toLowerCase();

            products = products.stream()
                    .filter(p -> p.getName().toLowerCase().contains(lower))
                    .collect(Collectors.toList());
        }

        return products.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    // =========================
    // GET DETAIL
    // =========================
    @GetMapping("/{id}")
    public ProductDetailResponse getDetail(@PathVariable Long id) {

        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        return mapToResponse(product);
    }

    // =========================
    // CREATE PRODUCT
    // =========================
    @PostMapping
    public ProductDetailResponse create(@RequestBody Product product) {

        if (product.getCategory() == null) {
            throw new RuntimeException("Category is required");
        }

        Category category = categoryRepo.findById(product.getCategory().getId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        // âŒ khÃ´ng cho chá»n category cha
        if (category.getParent() == null) {
            throw new RuntimeException("Pháº£i chá»n subcategory");
        }

        product.setCategory(category);

        Product savedProduct = productRepo.save(product);
        return mapToResponse(savedProduct);
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        if (!productRepo.existsById(id)) {
            throw new RuntimeException("Product not found");
        }
        productRepo.deleteById(id);
    }

    // =========================
    // GET VARIANTS
    // =========================
    @GetMapping("/{id}/variants")
    public List<VariantResponse> getVariants(@PathVariable Long id) {
        return variantRepo.findByProductId(id).stream()
                .map(this::mapVariantResponse)
                .collect(Collectors.toList());
    }

    @PostMapping("/{id}/variants")
    public VariantResponse addVariantForProduct(@PathVariable Long id, @RequestBody ProductVariant variant) {
        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        variant.setProduct(product);
        ProductVariant savedVariant = variantRepo.save(variant);
        return mapVariantResponse(savedVariant);
    }

    // =========================
    // ADD VARIANT
    // =========================
    @PostMapping("/variant")
    public VariantResponse addVariant(@RequestBody ProductVariant v) {
        if (v.getProduct() == null || v.getProduct().getId() == null) {
            throw new RuntimeException("Product is required");
        }

        Product product = productRepo.findById(v.getProduct().getId())
                .orElseThrow(() -> new RuntimeException("Product not found"));
        v.setProduct(product);
        ProductVariant savedVariant = variantRepo.save(v);
        return mapVariantResponse(savedVariant);
    }

    // =========================
    // MAP RESPONSE (QUAN TRá»ŒNG)
    // =========================
    private ProductDetailResponse mapToResponse(Product p) {

        List<ProductVariant> variants = variantRepo.findByProductId(p.getId());

        // ðŸ–¼ IMAGE (láº¥y tá»« variant Ä‘áº§u)
        String image = "";
        if (!variants.isEmpty()) {
            image = resolveVariantImage(variants.get(0));
        }

        // ðŸ’° PRICE RANGE (SAFE)
        double minPrice = variants.stream()
                .mapToDouble(ProductVariant::getPrice)
                .min()
                .orElse(0);

        double maxPrice = variants.stream()
                .mapToDouble(ProductVariant::getPrice)
                .max()
                .orElse(0);

        List<VariantResponse> variantResponses = variants.stream()
                .map(this::mapVariantResponse)
                .collect(Collectors.toList());

        // ðŸ“¦ RESPONSE
        ProductDetailResponse res = new ProductDetailResponse();
        res.setId(p.getId());
        res.setName(p.getName());
        res.setDescription(p.getDescription());
        res.setMinPrice(minPrice);
        res.setMaxPrice(maxPrice);
        res.setImage(image);
        res.setVariants(variantResponses);

        return res;
    }

    private String resolveVariantImage(ProductVariant variant) {
        if (variant.getImage() != null && !variant.getImage().isBlank()) {
            return variant.getImage();
        }

        return imageRepo.findByVariantId(variant.getId())
                .stream()
                .map(img -> img.getImageUrl())
                .findFirst()
                .orElse("");
    }

    private VariantResponse mapVariantResponse(ProductVariant v) {
        VariantResponse vr = new VariantResponse();
        vr.setId(v.getId());
        vr.setSize(v.getSize());
        vr.setColor(v.getColor());
        vr.setPrice(v.getPrice());

        // ðŸ”¥ SAFE
        Double oldPrice = v.getOldPrice();
        vr.setOldPrice(oldPrice);

        // â— KHÃ”NG BAO GIá»œ lÃ m:
        // if (v.getOldPrice() > ...)
        if (oldPrice != null && oldPrice > v.getPrice()) {
            // náº¿u cáº§n logic discount
        }

        vr.setStock(v.getStock());
        vr.setImage(resolveVariantImage(v));

        List<String> images = imageRepo.findByVariantId(v.getId())
                .stream()
                .map(img -> img.getImageUrl())
                .collect(Collectors.toList());

        vr.setImages(images);

        return vr;
    }
}

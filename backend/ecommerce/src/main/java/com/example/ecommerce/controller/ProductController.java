package com.example.ecommerce.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.dto.ProductDetailResponse;
import com.example.ecommerce.dto.VariantResponse;
import com.example.ecommerce.model.Category;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.CategoryRepository;
import com.example.ecommerce.repository.ProductImageRepository;
import com.example.ecommerce.repository.ProductRepository;
import com.example.ecommerce.repository.ProductVariantRepository;
import com.example.ecommerce.services.FlashSaleService;
import com.example.ecommerce.services.UserService;

@RestController
@CrossOrigin(origins = "*")
public class ProductController {

    @Autowired
    private FlashSaleService flashSaleService;

    @Autowired
    private ProductRepository productRepo;

    @Autowired
    private ProductVariantRepository variantRepo;

    @Autowired
    private ProductImageRepository imageRepo;

    @Autowired
    private CategoryRepository categoryRepo;

    @Autowired
    private UserService userService;

    @GetMapping("/api/products")
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

        if (keyword != null && !keyword.isEmpty()) {
            String lower = keyword.toLowerCase();
            products = products.stream()
                    .filter(product -> product.getName().toLowerCase().contains(lower))
                    .collect(Collectors.toList());
        }

        return products.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @GetMapping("/api/products/{id}")
    public ProductDetailResponse getDetail(@PathVariable Long id) {
        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        return mapToResponse(product);
    }

    @PostMapping("/api/admin/products")
    public ProductDetailResponse create(@RequestBody Product product) {
        userService.requireAdmin();

        if (product.getCategory() == null) {
            throw new RuntimeException("Category is required");
        }

        Category category = categoryRepo.findById(product.getCategory().getId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (category.getParent() == null) {
            throw new RuntimeException("Subcategory is required");
        }

        product.setCategory(category);

        Product savedProduct = productRepo.save(product);
        return mapToResponse(savedProduct);
    }

    @DeleteMapping("/api/admin/products/{id}")
    public void deleteProduct(@PathVariable Long id) {
        userService.requireAdmin();

        if (!productRepo.existsById(id)) {
            throw new RuntimeException("Product not found");
        }

        productRepo.deleteById(id);
    }

    @PutMapping("/api/admin/products/{id}")
    public ProductDetailResponse updateProduct(
            @PathVariable Long id,
            @RequestBody Product request) {
        userService.requireAdmin();

        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        // update field
        product.setName(request.getName());
        product.setDescription(request.getDescription());

        if (request.getCategory() != null) {
            Category category = categoryRepo.findById(request.getCategory().getId())
                    .orElseThrow(() -> new RuntimeException("Category not found"));

            product.setCategory(category);
        }

        Product updated = productRepo.save(product);

        return mapToResponse(updated);
    }

    @GetMapping("/api/products/{id}/variants")
    public List<VariantResponse> getVariants(@PathVariable Long id) {
        return variantRepo.findByProductId(id).stream()
                .map(this::mapVariantResponse)
                .collect(Collectors.toList());
    }

    @PostMapping("/api/admin/products/{id}/variants")
    public VariantResponse addVariantForProduct(@PathVariable Long id, @RequestBody ProductVariant variant) {
        userService.requireAdmin();

        Product product = productRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        variant.setProduct(product);
        ProductVariant savedVariant = variantRepo.save(variant);
        return mapVariantResponse(savedVariant);
    }

    @PostMapping("/api/admin/variants")
    public VariantResponse addVariant(@RequestBody ProductVariant variant) {
        userService.requireAdmin();

        if (variant.getProduct() == null || variant.getProduct().getId() == null) {
            throw new RuntimeException("Product is required");
        }

        Product product = productRepo.findById(variant.getProduct().getId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        variant.setProduct(product);
        ProductVariant savedVariant = variantRepo.save(variant);
        return mapVariantResponse(savedVariant);
    }

    private ProductDetailResponse mapToResponse(Product product) {
        List<ProductVariant> variants = variantRepo.findByProductId(product.getId());

        String image = "";
        if (!variants.isEmpty()) {
            image = resolveVariantImage(variants.get(0));
        }

        double minPrice = variants.stream()
                .mapToDouble(variant -> flashSaleService.getPrice(variant.getId(), variant.getPrice()))
                .min()
                .orElse(0);

        double maxPrice = variants.stream()
                .mapToDouble(variant -> flashSaleService.getPrice(variant.getId(), variant.getPrice()))
                .max()
                .orElse(0);

        List<VariantResponse> variantResponses = variants.stream()
                .map(this::mapVariantResponse)
                .collect(Collectors.toList());

        ProductDetailResponse response = new ProductDetailResponse();
        response.setId(product.getId());
        response.setName(product.getName());
        response.setDescription(product.getDescription());
        response.setMinPrice(minPrice);
        response.setMaxPrice(maxPrice);
        response.setImage(image);
        response.setVariants(variantResponses);

        return response;
    }

    private String resolveVariantImage(ProductVariant variant) {
        if (variant.getImage() != null && !variant.getImage().isBlank()) {
            return variant.getImage();
        }

        return imageRepo.findByVariantId(variant.getId())
                .stream()
                .map(image -> image.getImageUrl())
                .findFirst()
                .orElse("");
    }

    private VariantResponse mapVariantResponse(ProductVariant variant) {
        VariantResponse response = new VariantResponse();
        response.setId(variant.getId());
        response.setSize(variant.getSize());
        response.setColor(variant.getColor());

        double originalPrice = variant.getPrice();
        double finalPrice = flashSaleService.getPrice(variant.getId(), originalPrice);
        boolean flashSale = flashSaleService.isFlashSale(variant.getId());
        double oldPrice = variant.getOldPrice() != null ? variant.getOldPrice() : originalPrice;
        response.setPrice(finalPrice);
        response.setOldPrice(flashSale ? originalPrice : oldPrice);
        response.setFlashSale(flashSale);
        response.setStock(variant.getStock());
        response.setImage(resolveVariantImage(variant));

        List<String> images = imageRepo.findByVariantId(variant.getId())
                .stream()
                .map(image -> image.getImageUrl())
                .collect(Collectors.toList());

        response.setImages(images);
        return response;
    }
}

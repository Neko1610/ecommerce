package com.example.ecommerce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Category;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.repository.*;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    public Product createProduct(ProductRequest request) {

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (category.getParent() == null) {
            throw new RuntimeException("Phải chọn subcategory (leaf)");
        }

        Product product = new Product();
        product.setName(request.getName());
        product.setImage(request.getImage());
        product.setCategory(category);

        return productRepository.save(product);
    }

    public List<Product> getProducts(String keyword, Long categoryId) {

    List<Product> products;

    /// 🔥 CASE 1: có category
    if (categoryId != null) {

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        // 👉 nếu là parent → lấy sub
        if (category.getChildren() != null && !category.getChildren().isEmpty()) {

            List<Long> subIds = category.getChildren()
                    .stream()
                    .map(Category::getId)
                    .toList();

            products = productRepository.findByCategoryIdIn(subIds);

        } else {
            // 👉 sub category
            products = productRepository.findByCategoryId(categoryId);
        }

    } else {
        products = productRepository.findAll();
    }

    /// 🔍 FILTER KEYWORD (QUAN TRỌNG)
    if (keyword != null && !keyword.isEmpty()) {
        String lower = keyword.toLowerCase();

        products = products.stream()
                .filter(p -> p.getName().toLowerCase().contains(lower))
                .toList();
    }

    return products;
}
}
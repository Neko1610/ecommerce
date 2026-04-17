package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.dto.CategoryRequest;
import com.example.ecommerce.dto.CategoryResponse;
import com.example.ecommerce.model.Category;
import com.example.ecommerce.repository.CategoryRepository;
import com.example.ecommerce.services.CategoryService;
import com.example.ecommerce.services.UserService;

@RestController
public class CategoryController {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @GetMapping("/api/categories")
    public List<CategoryResponse> getCategories() {
        return categoryService.getCategoryTree();
    }

    @GetMapping("/api/categories/{id}")
    public CategoryResponse getCategoryById(@PathVariable Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        return categoryService.mapToResponse(category);
    }

    @PostMapping("/api/admin/categories")
    public CategoryResponse createCategory(@RequestBody CategoryRequest request) {
        userService.requireAdmin();

        Category category = categoryService.createCategory(
                request.getName(),
                request.getParentId(),
                request.getBanner());

        return categoryService.mapToResponse(category);
    }

    @PutMapping("/api/admin/categories/{id}")
    public CategoryResponse updateCategory(
            @PathVariable Long id,
            @RequestBody CategoryRequest request) {
        userService.requireAdmin();

        Category category = categoryService.updateCategory(
                id,
                request.getName(),
                request.getParentId(),
                request.getBanner());

        return categoryService.mapToResponse(category);
    }

    @DeleteMapping("/api/admin/categories/{id}")
    public void deleteCategory(@PathVariable Long id) {
        userService.requireAdmin();
        categoryService.deleteCategory(id);
    }
}

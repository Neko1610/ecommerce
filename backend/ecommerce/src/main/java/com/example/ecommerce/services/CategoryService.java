package com.example.ecommerce.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.example.ecommerce.dto.CategoryResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Category;
import com.example.ecommerce.repository.CategoryRepository;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<CategoryResponse> getCategoryTree() {
        List<Category> all = categoryRepository.findAll();

        Map<Long, CategoryResponse> map = new HashMap<>();
        List<CategoryResponse> roots = new ArrayList<>();

        for (Category c : all) {
            CategoryResponse dto = new CategoryResponse();
            dto.setId(c.getId());
            dto.setName(c.getName());
            dto.setBanner(c.getBanner());
            dto.setChildren(new ArrayList<>());
            map.put(c.getId(), dto);
        }

        for (Category c : all) {
            CategoryResponse dto = map.get(c.getId());

            if (c.getParent() == null) {
                roots.add(dto);
            } else {
                CategoryResponse parent = map.get(c.getParent().getId());
                if (parent != null) {
                    parent.getChildren().add(dto);
                }
            }
        }

        for (CategoryResponse dto : roots) {
            System.out.println("TOTAL CHILDREN: " + dto.getChildren().size());
        }

        return roots;
    }

    public CategoryResponse mapToResponse(Category category) {
        CategoryResponse dto = new CategoryResponse();
        dto.setId(category.getId());
        dto.setName(category.getName());
        dto.setBanner(category.getBanner());
        dto.setChildren(new ArrayList<>());
        return dto;
    }

    public Category createCategory(String name, Long parentId, String banner) {

        Category category = new Category();
        category.setName(normalizeName(name));
        category.setBanner(banner);
        applyParent(category, parentId);

        return categoryRepository.save(category);
    }

    public Category updateCategory(Long id, String name, Long parentId, String banner) {

        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        category.setName(normalizeName(name));
        category.setBanner(banner);
        applyParent(category, parentId);

        return categoryRepository.save(category);
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }

    private String normalizeName(String name) {
        String normalized = name == null ? "" : name.trim();
        if (normalized.isEmpty()) {
            throw new RuntimeException("Category name is required");
        }
        return normalized;
    }

    private void applyParent(Category category, Long parentId) {
        if (parentId == null) {
            category.setParent(null);
            return;
        }

        if (category.getId() != null && Objects.equals(category.getId(), parentId)) {
            throw new RuntimeException("Category cannot be its own parent");
        }

        Category parent = categoryRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Parent not found"));

        if (isDescendant(parent, category)) {
            throw new RuntimeException("Category cannot be moved under its child");
        }

        category.setParent(parent);
    }

    private boolean isDescendant(Category candidateParent, Category category) {
        if (candidateParent == null || category == null || category.getId() == null) {
            return false;
        }

        Category current = candidateParent;
        while (current != null) {
            if (Objects.equals(current.getId(), category.getId())) {
                return true;
            }
            current = current.getParent();
        }

        return false;
    }
}

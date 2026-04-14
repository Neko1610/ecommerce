package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import com.example.ecommerce.model.User;
import com.example.ecommerce.repository.UserRepository;
import com.example.ecommerce.services.UserService;

@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    // 🔥 LẤY DANH SÁCH USER
    @GetMapping
    public List<User> getAllUsers() {
        userService.requireAdmin();
        return userRepository.findAll();
    }

    // 🔥 XOÁ USER
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.requireAdmin();
        userRepository.deleteById(id);
    }
}
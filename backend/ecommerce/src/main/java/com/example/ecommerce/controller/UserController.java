package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.ecommerce.dto.*;
import com.example.ecommerce.services.UserService;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public ProfileResponse getProfile() {
        return userService.getProfile();
    }

    @PutMapping("/profile")
    public ProfileResponse update(@RequestBody UpdateProfileRequest req) {
        return userService.updateProfile(req.getFullName(), req.getPhone(),req.getAvatar());
    }
}
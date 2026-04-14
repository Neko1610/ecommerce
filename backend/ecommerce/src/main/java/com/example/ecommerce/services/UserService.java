package com.example.ecommerce.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.example.ecommerce.repository.*;
import com.example.ecommerce.model.User;
import com.example.ecommerce.dto.ProfileResponse;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUserEntity() {
        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private ProfileResponse mapToResponse(User user) {
        return ProfileResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phone(user.getPhone())
                .avatar(user.getAvatar())
                .build();
    }

    public ProfileResponse getProfile() {
        return mapToResponse(getCurrentUserEntity());
    }

    public boolean isAdmin() {
        return getCurrentUserEntity().getRole().equals("ADMIN");
    }

    public void requireAdmin() {
        User user = getCurrentUserEntity();
        if (!"ADMIN".equals(user.getRole())) {
            throw new RuntimeException("Forbidden");
        }
    }

    public ProfileResponse updateProfile(String fullName, String phone, String avatar) {
        User user = getCurrentUserEntity();

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAvatar(avatar);

        userRepository.save(user);

        return mapToResponse(user);
    }
}
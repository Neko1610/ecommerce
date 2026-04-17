package com.example.ecommerce.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.example.ecommerce.dto.ProfileResponse;
import com.example.ecommerce.model.User;
import com.example.ecommerce.repository.UserRepository;

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

    private String normalizeRole(String role) {
        String normalized = role == null || role.isBlank() ? "ROLE_USER" : role.trim().toUpperCase();
        return normalized.startsWith("ROLE_") ? normalized : "ROLE_" + normalized;
    }

    public ProfileResponse getProfile() {
        return mapToResponse(getCurrentUserEntity());
    }

    public boolean isAdmin() {
        return "ROLE_ADMIN".equals(normalizeRole(getCurrentUserEntity().getRole()));
    }

    public void requireAdmin() {
        if (!isAdmin()) {
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

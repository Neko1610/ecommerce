package com.example.ecommerce.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.Utils.JwtUtil;
import com.example.ecommerce.model.User;
import com.example.ecommerce.repository.UserRepository;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

   @PostMapping("/firebase")
    public String loginFirebase(@RequestBody Map<String, String> body) throws Exception {

        String token = body.get("token");

        if (token == null || token.isEmpty()) {
            throw new RuntimeException("Token is missing");
        }

        FirebaseToken decodedToken =
                FirebaseAuth.getInstance().verifyIdToken(token);

        String email = decodedToken.getEmail();

        if (email == null) {
            throw new RuntimeException("Email not found");
        }

        User user = userRepository.findByEmail(email)
                .orElse(null);

        if (user == null) {
            user = new User();
            user.setEmail(email);
            user.setFullName(decodedToken.getName());   // 🔥 thêm
            user.setAvatar(decodedToken.getPicture());  // 🔥 thêm
            user.setCreatedAt(System.currentTimeMillis());

            user = userRepository.save(user);
        }

        return jwtUtil.generateToken(user.getEmail());
    }
}
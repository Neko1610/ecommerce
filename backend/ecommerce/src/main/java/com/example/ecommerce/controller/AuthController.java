package com.example.ecommerce.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<?> loginFirebase(@RequestBody Map<String, String> body) {

        try {
         
            System.out.println("BODY: " + body);

            String token = body.get("token");

            if (token == null || token.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Token is missing"));
            }

            FirebaseToken decodedToken =
                    FirebaseAuth.getInstance().verifyIdToken(token);

            String email = decodedToken.getEmail();

            if (email == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Email not found"));
            }

            User user = userRepository.findByEmail(email)
                    .orElse(null);

            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setFullName(decodedToken.getName());
                user.setAvatar(decodedToken.getPicture());
                user.setRole("USER");
                user.setCreatedAt(System.currentTimeMillis());
                user = userRepository.save(user);
            }

            String jwt = jwtUtil.generateToken(user.getEmail(), user.getRole());

            return ResponseEntity.ok(Map.of(
                    "token", jwt,
                    "email", user.getEmail()
            ));

        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.status(500)
                    .body(Map.of("error", e.getMessage()));
        }
    }
    
}
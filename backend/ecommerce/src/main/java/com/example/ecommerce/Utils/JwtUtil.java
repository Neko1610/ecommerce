package com.example.ecommerce.Utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtil {

    private final SecretKey SECRET_KEY =
            Keys.hmacShaKeyFor("mysecretkeymysecretkeymysecretkey".getBytes());

    // 🔥 CREATE TOKEN
    public String generateToken(String email, String role) {
        return Jwts.builder()
                .setSubject(email)
                .claim("role", role) // 👈 QUAN TRỌNG
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24))
                .signWith(SECRET_KEY)
                .compact();
    }

    // 🔥 GET EMAIL
    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }

    // 🔥 GET ROLE
    public String extractRole(String token) {
        return extractAllClaims(token).get("role", String.class);
    }

    // 🔥 CORE
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
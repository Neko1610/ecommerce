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
    public String generateToken(String email) {
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000))
                .signWith(SECRET_KEY)
                .compact();
    }

    // 🔥 EXTRACT EMAIL
    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }

    // 🔥 CORE
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY) // ✅ FIX
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
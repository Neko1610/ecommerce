package com.example.ecommerce.Utils;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");

        if (header != null && header.startsWith("Bearer ")) {

            String token = header.substring(7);

            try {
                String email = jwtUtil.extractUsername(token);
                String role = jwtUtil.extractRole(token);

                if (role == null)
                    role = "USER";

                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                        email,
                        null,
                        List.of(new SimpleGrantedAuthority("ROLE_" + role)));

                // 🔥 QUAN TRỌNG NHẤT (fix 403)
                SecurityContextHolder.getContext().setAuthentication(auth);
                System.out.println("HEADER: " + header);
                System.out.println("TOKEN: " + token);
                System.out.println("EMAIL: " + email);
                System.out.println("ROLE: " + role);
                System.out.println("AUTH SET: " + SecurityContextHolder.getContext().getAuthentication());

            } catch (Exception e) {
                System.out.println("JWT ERROR: " + e.getMessage());

            }
        }

        filterChain.doFilter(request, response);
    }
}
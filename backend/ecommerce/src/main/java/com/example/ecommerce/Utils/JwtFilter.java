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
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");

        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);

            try {
                String email = jwtUtil.extractUsername(token);
                String role = jwtUtil.extractRole(token);

                if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {

                    if (role != null && !role.startsWith("ROLE_")) {
                        role = "ROLE_" + role;
                    }

                    System.out.println("ROLE FINAL: " + role); // debug

                    UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                            email,
                            null,
                            List.of(new SimpleGrantedAuthority(role)));

                    SecurityContextHolder.getContext().setAuthentication(auth);
                }

            } catch (Exception ex) {
                System.out.println("JWT ERROR: " + ex.getMessage());
            }
        }

        filterChain.doFilter(request, response);
    }
}

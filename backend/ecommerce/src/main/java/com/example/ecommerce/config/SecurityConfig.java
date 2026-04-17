package com.example.ecommerce.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.example.ecommerce.Utils.JwtFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> {
                })
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth

                        // 🔓 PUBLIC
                        .requestMatchers("/api/auth/**").permitAll()

                        .requestMatchers(HttpMethod.GET,
                                "/api/products", "/api/products/**",
                                "/api/categories", "/api/categories/**",
                                "/api/flash-sales", "/api/flash-sales/**",
                                "/api/vouchers", "/api/vouchers/**" 
                        ).permitAll()

                        .requestMatchers("/api/admin/**").hasRole("ADMIN")

                        .requestMatchers(
                                "/api/cart/**",
                                "/api/orders/**", 
                                "/api/order/**", 
                                "/api/address/**",
                                "/api/user/**",
                                "/api/users/**" 
                        ).authenticated()

                        .anyRequest().authenticated());

        http.addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}

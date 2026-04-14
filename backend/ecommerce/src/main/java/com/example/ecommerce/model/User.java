package com.example.ecommerce.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    private String password;

    private String fullName;

    private String userName;

    private String phone;

    private String avatar;
    
    private String role;
    
    @Column(name = "created_at")
    private Long createdAt;

    @PrePersist
    public void prePersist() {
        this.createdAt = System.currentTimeMillis();
    }
}
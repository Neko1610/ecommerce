package com.example.ecommerce.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "address")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullAddress;

    private Double latitude;
    private Double longitude;

    @JsonProperty("isDefault")
    private boolean isDefault;
    private String label;
    private String email;

}

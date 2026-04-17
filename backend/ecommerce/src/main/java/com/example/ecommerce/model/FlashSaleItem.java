package com.example.ecommerce.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class FlashSaleItem {

    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne
    private FlashSale flashSale;

    @ManyToOne
    private ProductVariant variant;

    private double flashPrice;

    private int quantity;       
    private int sold;          
}
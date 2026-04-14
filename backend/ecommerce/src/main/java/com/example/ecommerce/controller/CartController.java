package com.example.ecommerce.controller;

import com.example.ecommerce.dto.CartRequest;
import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.services.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import com.example.ecommerce.dto.CartItemResponse;
import com.example.ecommerce.dto.ProductDetailResponse;
import com.example.ecommerce.dto.VariantResponse;
import com.example.ecommerce.repository.ProductImageRepository;
import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartController {
    @Autowired
    private CartService cartService;
    @Autowired
    private ProductImageRepository imageRepo;

    // 🛒 ADD
    @PostMapping("/add")
    public String addToCart(@RequestBody CartRequest request) {

        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        System.out.println("EMAIL FROM TOKEN: " + email);

        cartService.addToCartByEmail(
                email,
                request.getVariantId(),
                request.getQuantity());

        return "Added";
    }

    // 📦 GET CART
    @GetMapping
    public List<CartItemResponse> getCart() {

        // 🔥 lấy user từ token
        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        List<CartItem> items = cartService.getCartByEmail(email);

        return items.stream().map(item -> {

            var v = item.getVariant();

            VariantResponse vr = new VariantResponse();
            vr.setId(v.getId());
            vr.setSize(v.getSize());
            vr.setColor(v.getColor());
            vr.setPrice(v.getPrice());
            vr.setStock(v.getStock());

            List<String> images = imageRepo.findByVariantId(v.getId())
                    .stream()
                    .map(img -> img.getImageUrl())
                    .toList();

            vr.setImages(images);

            var p = v.getProduct();

            ProductDetailResponse pr = new ProductDetailResponse();
            pr.setId(p.getId());
            pr.setName(p.getName());
            pr.setDescription(p.getDescription());

            CartItemResponse res = new CartItemResponse();
            res.setId(item.getId());
            res.setQuantity(item.getQuantity());

            res.setVariantId(v.getId());
            res.setProductName(p.getName());
            res.setProductImage(images.isEmpty() ? "" : images.get(0));

            res.setColor(v.getColor());
            res.setSize(v.getSize());

            res.setPrice(v.getPrice());
            res.setStock(v.getStock());

            return res;

        }).toList();
    }

    // ❌ REMOVE
    @DeleteMapping("/{id}")
    public void remove(@PathVariable Long id) {
        cartService.remove(id);
    }

    // 🔄 UPDATE
    @PutMapping("/{id}")
    public void update(@PathVariable Long id,
            @RequestParam int qty) {
        cartService.updateQty(id, qty);
    }

    @DeleteMapping("/clear")
    public void clearCart() {

        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        cartService.clearCartByEmail(email);
    }
}
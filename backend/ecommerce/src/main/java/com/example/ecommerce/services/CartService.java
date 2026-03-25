package com.example.ecommerce.services;

import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.CartRepository;
import com.example.ecommerce.repository.ProductVariantRepository;
import com.example.ecommerce.repository.UserRepository;
import com.example.ecommerce.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private ProductVariantRepository variantRepository;

    @Autowired
    private UserRepository userRepository;

    
    public List<CartItem> getCartByEmail(String email) {

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

        return cartRepository.findByUserId(user.getId());
    }
        

    public void addToCartByEmail(String email, Long variantId, int quantity) {

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

    ProductVariant variant = variantRepository.findById(variantId)
            .orElseThrow(() -> new RuntimeException("Variant not found"));

    CartItem item = cartRepository
            .findByUserIdAndVariant(user.getId(), variant)
            .orElse(null);

    if (item != null) {
        item.setQuantity(item.getQuantity() + quantity);
    } else {
        item = new CartItem();
        item.setUserId(user.getId());
        item.setVariant(variant);
        item.setQuantity(quantity);
    }

    cartRepository.save(item);
}

    public List<CartItem> getCart(Long userId) {
        return cartRepository.findByUserId(userId);
    }

    public void remove(Long id) {
        cartRepository.deleteById(id);
    }

    public void updateQty(Long id, int qty) {
        CartItem item = cartRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Not found"));

        item.setQuantity(qty);
        cartRepository.save(item);
    }
    public void clearCartByEmail(String email) {

    User user = userRepository.findByEmail(email).orElseThrow();

    cartRepository.deleteByUserId(user.getId());
    }
}
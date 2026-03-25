package com.example.ecommerce.services;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import com.example.ecommerce.dto.OrderRequest;
import com.example.ecommerce.dto.OrderItemRequest;
import com.example.ecommerce.dto.OrderListResponse;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.model.OrderItem;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.model.Voucher;
import com.example.ecommerce.model.User;
import com.example.ecommerce.repository.CartRepository;
import com.example.ecommerce.repository.OrderRepository;
import com.example.ecommerce.repository.ProductVariantRepository;
import com.example.ecommerce.repository.UserRepository;
import com.example.ecommerce.repository.OrderItemRepository;
import com.example.ecommerce.repository.VoucherRepository;

import jakarta.transaction.Transactional;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepo;
    private final OrderItemRepository orderItemRepo;
    private final VoucherRepository voucherRepo;
    private final ProductVariantRepository variantRepo;
    private final UserRepository userRepository;
    private final CartRepository cartRepository;

    // 🔥 CHECKOUT (JWT)
    @Transactional
    public void checkoutByEmail(String email, OrderRequest request) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        double subtotal = 0;
        List<OrderItem> orderItems = new ArrayList<>();

        for (OrderItemRequest item : request.getItems()) {

            ProductVariant variant = variantRepo.findById(item.getVariantId())
                    .orElseThrow(() -> new RuntimeException("Variant not found"));

            double price = variant.getPrice();
            int qty = item.getQuantity();

            subtotal += price * qty;

            OrderItem oi = new OrderItem();
            oi.setProductId(variant.getProduct().getId());
            oi.setVariantId(variant.getId());
            oi.setPrice(price);
            oi.setQuantity(qty);

            orderItems.add(oi);
        }

        double discount = 0;

        if (request.getVoucherCode() != null && !request.getVoucherCode().isEmpty()) {
            Voucher v = voucherRepo.findByCode(request.getVoucherCode())
                    .orElseThrow(() -> new RuntimeException("Voucher not found"));

            discount = subtotal * v.getDiscountPercent() / 100;
        }

        double total = subtotal - discount + request.getShippingFee();

        Order order = new Order();
        order.setUserId(user.getId());
        order.setAddress(request.getAddress());
        order.setPhone(request.getPhone());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setSubtotal(subtotal);
        order.setDiscount(discount);
        order.setTotal(total);
        order.setStatus("PENDING");

        orderRepo.save(order);

        for (OrderItem oi : orderItems) {
            oi.setOrder(order);
            orderItemRepo.save(oi);
        }

        // 🔥 CLEAR CART SAU CHECKOUT
        cartRepository.deleteByUserId(user.getId());
    }

    // 🔥 ORDER LIST (JWT)
    public List<OrderListResponse> getOrdersByEmail(String email) {

        User user = userRepository.findByEmail(email)
                .orElseThrow();

        return orderRepo.findByUserIdOrderByIdDesc(user.getId())
                .stream()
                .map(order -> {

                    OrderListResponse res = new OrderListResponse();

                    res.setId(order.getId());
                    res.setStatus(order.getStatus());
                    res.setTotal(order.getTotal());

                    res.setCreatedAt(
                            order.getCreatedAt()
                                    .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                    );

                    // 🔥 images
                    List<String> images = orderItemRepo
                            .findByOrder_Id(order.getId())
                            .stream()
                            .limit(3)
                            .map(item -> {
                                ProductVariant variant = variantRepo.findById(item.getVariantId()).orElse(null);

                                if (variant != null &&
                                        variant.getImages() != null &&
                                        !variant.getImages().isEmpty()) {
                                    return variant.getImages().get(0).getImageUrl();
                                }

                                return "https://picsum.photos/200";
                            })
                            .toList();

                    res.setImages(images);
                    res.setTitle("Order #" + order.getId());

                    return res;

                }).toList();
    }

    // 🔥 ORDER DETAIL (SECURE)
    public Map<String, Object> getDetailByEmail(String email, Long id) {

        User user = userRepository.findByEmail(email)
                .orElseThrow();

        Order order = orderRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (!order.getUserId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }

        List<OrderItem> items = orderItemRepo.findByOrder_Id(id);

        List<Map<String, Object>> itemList = items.stream().map(item -> {

            Map<String, Object> map = new HashMap<>();

            ProductVariant variant = variantRepo.findById(item.getVariantId()).orElse(null);

            String productName = variant != null ? variant.getProduct().getName() : "";
            String image = "https://picsum.photos/80";

            if (variant != null && variant.getImages() != null && !variant.getImages().isEmpty()) {
                image = variant.getImages().get(0).getImageUrl();
            }

            String variantText = variant != null
                    ? variant.getColor() + " / " + variant.getSize()
                    : "";

            map.put("productName", productName);
            map.put("image", image);
            map.put("quantity", item.getQuantity());
            map.put("price", item.getPrice());
            map.put("variant", variantText);

            return map;

        }).toList();

        Map<String, Object> res = new HashMap<>();
        res.put("order", order);
        res.put("items", itemList);

        return res;
    }
}
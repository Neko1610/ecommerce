package com.example.ecommerce.services;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import com.example.ecommerce.dto.OrderRequest;
import com.example.ecommerce.dto.OrderItemRequest;
import com.example.ecommerce.dto.OrderListResponse;
import com.example.ecommerce.model.Address;
import com.example.ecommerce.model.FlashSaleItem;
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
import com.example.ecommerce.repository.AddressRepository;

import jakarta.transaction.Transactional;

@Service
@RequiredArgsConstructor
public class OrderService {

    private static final Set<String> ALLOWED_STATUSES = Set.of(
            "PENDING",
            "CONFIRMED",
            "SHIPPED",
            "DELIVERED",
            "CANCELLED");

    private final OrderRepository orderRepo;
    private final OrderItemRepository orderItemRepo;
    private final VoucherRepository voucherRepo;
    private final ProductVariantRepository variantRepo;
    private final UserRepository userRepository;
    private final CartRepository cartRepository;
    private final AddressRepository addressRepository;
    private final ShippingService shippingService;
    private final FlashSaleService flashSaleService;

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

            int qty = item.getQuantity();
            if (variant.getStock() < qty) {
                throw new RuntimeException("Insufficient stock");
            }

            FlashSaleItem flashSaleItem = flashSaleService.getActiveItem(variant.getId())
                    .filter(activeItem -> activeItem.getSold() < activeItem.getQuantity())
                    .orElse(null);

            if (flashSaleItem != null && flashSaleItem.getSold() + qty > flashSaleItem.getQuantity()) {
                throw new RuntimeException("Flash sale out of stock");
            }

            double price = flashSaleItem != null ? flashSaleItem.getFlashPrice() : variant.getPrice();

            subtotal += price * qty;

            OrderItem oi = new OrderItem();
            oi.setProductId(variant.getProduct().getId());
            oi.setVariantId(variant.getId());
            oi.setPrice(price);
            oi.setQuantity(qty);

            orderItems.add(oi);

            variant.setStock(variant.getStock() - qty);
            variantRepo.save(variant);

            if (flashSaleItem != null) {
                flashSaleService.consumeStock(variant.getId(), qty);
            }
        }

        double discount = 0;

        if (request.getVoucherCode() != null && !request.getVoucherCode().isEmpty()) {
            Voucher v = voucherRepo.findByCode(request.getVoucherCode())
                    .orElseThrow(() -> new RuntimeException("Voucher not found"));

            discount = subtotal * v.getDiscountPercent() / 100;

        }

        // 🔥 LẤY ADDRESS
        Address address = addressRepository
                .findByIdAndEmail(request.getAddressId(), email)
                .orElseThrow(() -> new RuntimeException("Address not found"));
        if (address.getLatitude() == null || address.getLongitude() == null) {
            throw new RuntimeException("Address chưa có tọa độ");
        }
        // 🔥 TÍNH SHIPPING
        double[] warehouse = shippingService.getNearestWarehouse(
                address.getLatitude(),
                address.getLongitude());

        double distance = shippingService.calculateDistance(
                warehouse[0], warehouse[1],
                address.getLatitude(), address.getLongitude());

        double fee = shippingService.calculateFee(distance);
        int eta = shippingService.calculateETA(distance);

        // 🔥 TOTAL
        double total = subtotal - discount + fee;

        // 🔥 CREATE ORDER
        Order order = new Order();
        order.setUserId(user.getId());

        order.setAddress(address.getFullAddress()); // snapshot
        order.setPhone(request.getPhone());
        order.setPaymentMethod(request.getPaymentMethod());

        order.setSubtotal(subtotal);
        order.setDiscount(discount);

        // 🔥 SHIPPING SAVE
        order.setShippingFee(fee);
        order.setDistance(distance);
        order.setEtaDays(eta);

        order.setTotal(total);
        order.setStatus("PENDING");

        orderRepo.save(order);

        for (OrderItem oi : orderItems) {
            oi.setOrder(order);
            orderItemRepo.save(oi);
        }
        cartRepository.deleteByUserId(user.getId());
    }

    // 🔥 ORDER LIST (JWT)
    public List<OrderListResponse> getOrdersByEmail(String email) {

        User user = userRepository.findByEmail(email)
                .orElseThrow();

        return orderRepo.findByUserIdOrderByIdDesc(user.getId())
                .stream()
                .map(this::mapOrderSummary)
                .toList();
    }

    public List<OrderListResponse> getAllOrdersForAdmin() {
        return orderRepo.findAllByOrderByIdDesc()
                .stream()
                .map(this::mapOrderSummary)
                .toList();
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

        return buildOrderDetail(order);
    }

    public Map<String, Object> getDetailForAdmin(Long id) {
        Order order = orderRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        return buildOrderDetail(order);
    }

    @Transactional
    public Order updateOrderStatus(Long id, String status) {
        Order order = orderRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        String normalizedStatus = normalizeStatus(status);
        order.setStatus(normalizedStatus);

        return orderRepo.save(order);
    }

    private String normalizeStatus(String status) {
        String normalized = status == null ? "" : status.trim().toUpperCase();
        if (!ALLOWED_STATUSES.contains(normalized)) {
            throw new RuntimeException("Invalid order status");
        }
        return normalized;
    }

    private OrderListResponse mapOrderSummary(Order order) {
        OrderListResponse res = new OrderListResponse();

        res.setId(order.getId());
        res.setStatus(order.getStatus());
        res.setTotal(order.getTotal());
        res.setCreatedAt(
                order.getCreatedAt()
                        .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));

        List<String> images = orderItemRepo.findByOrder_Id(order.getId())
                .stream()
                .limit(3)
                .map(item -> resolveVariantImage(variantRepo.findById(item.getVariantId()).orElse(null)))
                .toList();

        res.setImages(images);
        res.setTitle("Order #" + order.getId());
        return res;
    }

    private Map<String, Object> buildOrderDetail(Order order) {
        List<OrderItem> items = orderItemRepo.findByOrder_Id(order.getId());

        List<Map<String, Object>> itemList = items.stream().map(item -> {

            Map<String, Object> map = new HashMap<>();

            ProductVariant variant = variantRepo.findById(item.getVariantId()).orElse(null);

            String productName = variant != null ? variant.getProduct().getName() : "";
            String variantText = variant != null
                    ? variant.getColor() + " / " + variant.getSize()
                    : "";

            map.put("productName", productName);
            map.put("image", resolveVariantImage(variant));
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

    private String resolveVariantImage(ProductVariant variant) {
        if (variant == null) {
            return "https://picsum.photos/200";
        }

        if (variant.getImage() != null && !variant.getImage().isBlank()) {
            return variant.getImage();
        }

        if (variant.getImages() != null && !variant.getImages().isEmpty()) {
            return variant.getImages().get(0).getImageUrl();
        }

        return "https://picsum.photos/200";
    }
}

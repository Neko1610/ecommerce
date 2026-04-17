package com.example.ecommerce.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.ecommerce.dto.FlashSaleItemRequest;
import com.example.ecommerce.dto.FlashSaleItemResponse;
import com.example.ecommerce.dto.FlashSaleRequest;
import com.example.ecommerce.dto.FlashSaleResponse;
import com.example.ecommerce.model.FlashSale;
import com.example.ecommerce.model.FlashSaleItem;
import com.example.ecommerce.model.ProductVariant;
import com.example.ecommerce.repository.FlashSaleItemRepository;
import com.example.ecommerce.repository.FlashSaleRepository;
import com.example.ecommerce.repository.ProductVariantRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashSaleService {

    private final FlashSaleRepository flashSaleRepository;
    private final FlashSaleItemRepository itemRepo;
    private final ProductVariantRepository productVariantRepository;

    public Optional<FlashSaleItem> getActiveItem(Long variantId) {
        return itemRepo.findActiveByVariant(variantId, LocalDateTime.now());
    }

    public boolean isFlashSale(Long variantId) {
        return getActiveItem(variantId)
                .filter(item -> item.getSold() < item.getQuantity())
                .isPresent();
    }

    public double getPrice(Long variantId, double originalPrice) {
        return getActiveItem(variantId)
                .filter(item -> item.getSold() < item.getQuantity())
                .map(FlashSaleItem::getFlashPrice)
                .orElse(originalPrice);
    }

    public void consumeStock(Long variantId, int qty) {
        FlashSaleItem item = itemRepo.findActiveByVariant(variantId, LocalDateTime.now())
                .orElseThrow(() -> new RuntimeException("Flash sale not found"));

        if (item.getSold() + qty > item.getQuantity()) {
            throw new RuntimeException("Flash sale out of stock");
        }

        item.setSold(item.getSold() + qty);
        itemRepo.save(item);
    }

    public FlashSaleResponse createFlashSale(FlashSaleRequest request) {
        FlashSale flashSale = new FlashSale();
        flashSale.setName(request.getName());
        flashSale.setStartTime(request.getStartTime());
        flashSale.setEndTime(request.getEndTime());
        flashSale.setActive(request.getActive() == null || request.getActive());
        return toResponse(flashSaleRepository.save(flashSale));
    }

    public FlashSaleItemResponse createFlashSaleItem(FlashSaleItemRequest request) {
        FlashSale flashSale = flashSaleRepository.findById(request.getFlashSaleId())
                .orElseThrow(() -> new RuntimeException("Flash sale not found"));

        ProductVariant variant = productVariantRepository.findById(request.getVariantId())
                .orElseThrow(() -> new RuntimeException("Variant not found"));

        FlashSaleItem item = new FlashSaleItem();
        item.setFlashSale(flashSale);
        item.setVariant(variant);
        item.setFlashPrice(request.getFlashPrice());
        item.setQuantity(request.getQuantity());
        item.setSold(0);

        return toItemResponse(itemRepo.save(item));
    }

    public List<FlashSaleResponse> getAllFlashSales() {
        return flashSaleRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private FlashSaleResponse toResponse(FlashSale flashSale) {
        return FlashSaleResponse.builder()
                .id(flashSale.getId())
                .name(flashSale.getName())
                .startTime(flashSale.getStartTime())
                .endTime(flashSale.getEndTime())
                .active(flashSale.isActive())
                .build();
    }

    private FlashSaleItemResponse toItemResponse(FlashSaleItem item) {
        return FlashSaleItemResponse.builder()
                .id(item.getId())
                .flashSaleId(item.getFlashSale().getId())
                .variantId(item.getVariant().getId())
                .flashPrice(item.getFlashPrice())
                .quantity(item.getQuantity())
                .sold(item.getSold())
                .build();
    }
}

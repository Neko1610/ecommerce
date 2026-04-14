package com.example.ecommerce.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.services.ShippingService;
import com.example.ecommerce.model.Address;
import com.example.ecommerce.repository.AddressRepository;

@RestController
@RequestMapping("/api/shipping")
public class ShippingController {

    @Autowired
    private ShippingService shippingService;

    @Autowired
    private AddressRepository addressRepository;

    @PostMapping("/calculate/{addressId}")
    public Map<String, Object> calculate(@PathVariable Long addressId) {

        Address address = addressRepository.findById(addressId).orElseThrow();

        double userLat = address.getLatitude();
        double userLng = address.getLongitude();

        double[] warehouse = shippingService.getNearestWarehouse(userLat, userLng);

        double distance = shippingService.calculateDistance(
                warehouse[0], warehouse[1],
                userLat, userLng
        );

        double fee = shippingService.calculateFee(distance);
        int eta = shippingService.calculateETA(distance);

        Map<String, Object> res = new HashMap<>();
        res.put("distance", distance);
        res.put("fee", fee);
        res.put("etaDays", eta);

        return res;
    }
}
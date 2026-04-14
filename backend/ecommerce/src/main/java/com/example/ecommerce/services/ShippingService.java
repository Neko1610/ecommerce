package com.example.ecommerce.services;

import org.springframework.stereotype.Service;

@Service
public class ShippingService {

    private static final double HCM_LAT = 10.762622;
    private static final double HCM_LNG = 106.660172;

    private static final double HN_LAT = 21.0285;
    private static final double HN_LNG = 105.8542;

    public double[] getNearestWarehouse(double userLat, double userLng) {

        double d1 = calculateDistance(userLat, userLng, HCM_LAT, HCM_LNG);
        double d2 = calculateDistance(userLat, userLng, HN_LAT, HN_LNG);

        return d1 < d2
                ? new double[]{HCM_LAT, HCM_LNG}
                : new double[]{HN_LAT, HN_LNG};
    }

    public double calculateDistance(double lat1, double lon1,
                                    double lat2, double lon2) {

        double R = 6371;

        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);

        double a =
                Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(Math.toRadians(lat1)) *
                Math.cos(Math.toRadians(lat2)) *
                Math.sin(dLon/2) * Math.sin(dLon/2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

        return R * c;
    }

    public double calculateFee(double distance) {

        double fee;

        if (distance <= 3) fee = 15000;
        else fee = 15000 + (distance - 3) * 3000;

        if (fee > 50000) fee = 50000;

        return fee;
    }

    public int calculateETA(double distance) {
        return (int) Math.ceil(distance / 30);
    }
}
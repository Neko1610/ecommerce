package com.example.ecommerce.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum PaymentType {
    MOMO,
    ZALOPAY,
    CREDIT_CARD,
    BANK;

    @JsonCreator
    public static PaymentType fromValue(String value) {
        if (value == null) {
            return CREDIT_CARD;
        }

        String normalized = value
                .trim()
                .toUpperCase()
                .replace("-", "_")
                .replace(" ", "_");

        if ("ZALO_PAY".equals(normalized)) {
            return ZALOPAY;
        }

        if ("CREDITCARD".equals(normalized)) {
            return CREDIT_CARD;
        }

        try {
            return PaymentType.valueOf(normalized);
        } catch (IllegalArgumentException ex) {
            return CREDIT_CARD;
        }
    }

    @JsonValue
    public String toValue() {
        return name();
    }
}

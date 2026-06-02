package com.example.ecommerce.Utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Hex;

public class HmacUtils {

    public static String signSHA256(
            String data,
            String secretKey
    ) {

        try {

            Mac hmacSHA256 =
                    Mac.getInstance("HmacSHA256");

            SecretKeySpec secretKeySpec =
                    new SecretKeySpec(
                            secretKey.getBytes(),
                            "HmacSHA256"
                    );

            hmacSHA256.init(secretKeySpec);

            byte[] hash =
                    hmacSHA256.doFinal(data.getBytes());

            return Hex.encodeHexString(hash);

        } catch (Exception e) {

            throw new RuntimeException(e);
        }
    }
}